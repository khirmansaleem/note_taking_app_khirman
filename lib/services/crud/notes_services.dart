// this service will grab the hold of database, read and write to the database using queries.
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app_khirman/constants/crud_constants.dart';
import 'package:note_taking_app_khirman/services/crud/crud_crudexceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;
//-------------------------------------------------------------------------------------------------------
// in the initial implementation, note service is directly talking with the database, it did not had any
// way to cache those notes, so for that purpose streams were introduced.
// in case of larger databases when there are millions of records, it is not good practice to go to the
// database each time and read the entire thing to just delete one row.
// these operations should be cached in your application before you just go and hit database.
//----------------------------------------------------------------------------------------------------------
// caching the list of notes that noteService has.
class NoteService {
  Database? _db;
  List<DatabaseNotes> _notes=[];// all te notes to current user
  // make the instance of note service as singleton
  // for creating the singleton instance of noteservice
  static final NoteService _shared=NoteService._sharedInstance();
  // private initializer , it cannot be called from outside.
  NoteService._sharedInstance();
  factory NoteService()=> _shared;// we can use it using factory constructor.

  // stream for holding data list of notes, and ui will listen to this stream.
  // stream controller control operations on that stream
  // every event inside stream is list of database.
  // stream controller controls the changes made to the notes list.
  final _notesStreamController=StreamController<List<DatabaseNotes>>.broadcast();
   // this stream will subscribe to the stream controller.
  Stream<List<DatabaseNotes>> get AllNotes=>_notesStreamController.stream;

  // MAKE OUR LOCAL DATABASE USER TO BE ASSOCIATED WITH FIREBASE USER TO PROCEED TO TAKE NOTES.
  Future<DatabaseUser> getOrCreateUser({ required String email})async{
    await ensureDbIsOpen();
    // we have passed as parameter the email of firebase user and this function either returns
    // that user from local database if exist or otherwise create that user in local database.
    // syncing our local database user with the firebase user
    try{
      final user= await getUser(email: email);
      return user;
    }on UserNotExistInTable{
      final createdUser=await createUser(email: email);
      return createdUser;
    }catch(e){ // again throw exception caught by catch block that was in try catch of createUser.
      // because in the createUser method there was already try and catch block that was not handle
      // here, so we rethrow
      rethrow;
    }

  }

  // read notes and cache them in "_notes" and _notesStreamController both.
  Future<void> _cacheNotes()async{
    await ensureDbIsOpen();
    final allNotes=await getAllNotes();
   final myNotes = allNotes.toList();
   _notesStreamController.add(myNotes.cast<DatabaseNotes>());

  }

  // Functionality of updating the existing notes:
  Future<DatabaseNotes> updateNotes({required DatabaseNotes note,
    required String text})async{
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
   await getNote(id: note.id);
 final updateCounts= await  db.update(notesTable, {
       columnText:text,
      columnSynced: 0
    });
 if(updateCounts==0){
   throw CanNotUpdateDatabase();
 }
 else{
   final givenNote= await getNote(id: note.id);
   _notes.removeWhere((note) =>note.id==givenNote.id); // maybe that note is updated so we will update the
   // cache and stream controller with latest note.
   // first update the local cache and then apply those changes to outside world.
   _notes.add(givenNote);
   _notesStreamController.add(_notes);

   return givenNote;
 }
  }

  // get all the notes from the database.
  Future< List<Map<String, Object?>>> getAllNotes() async{
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    final notes= await db.query(notesTable);
    return notes;
  }


  // get a particular note using it's id
  Future<DatabaseNotes> getNote({ required int id}) async{
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    // limit:1--> means query will return at most one record that matches the specified condition.
    // query the database and returns the result.
    final result= await db.query(notesTable,limit: 1,where: 'id = ?',whereArgs: [id]);
    // as limit set to one so there will be only one record taken from the table
    if(result.isEmpty){
      throw NoteNotExistInTable();
    }
    else{
      final note=DatabaseNotes.fromRow(result.first);
      _notes.removeWhere((note) =>note.id==id); // maybe that note is updated so we will update the
      // cache and stream controller with latest note.
      // first update the local cache and then apply those changes to outside world.
      _notes.add(note);
      _notesStreamController.add(_notes);

      // it can be the other way
      return note ;
    }

  }
  //---------------------------------------------------------------------------------------------------
  // function which allow you to delete all the notes from the database:
  // it will return the number of notes that were deleted from the database.
  Future<int> deleteAllNotes()async{
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    // this operation will delete all the rows from the table, not the column names or struture of the table.
   final  deleteCount=  await db.delete(notesTable);
   _notes.clear();
   _notesStreamController.add(_notes);
   return deleteCount;
  }

  // now create function to delete a note.
  Future<void> deleteNote({ required int id})async{
    await ensureDbIsOpen();
    // delete as many objects from the userTable, and their email should be equal to email passed to the
    // deleteUser function
    final db=_getDatabaseOrThrow();
    // it returns the number of rows affected by the delete operation
    final deleteCount= await db.delete(notesTable,where: 'id = ?',
      whereArgs: [id],
    );
    // deleteCount will be 1 as email is unique for each user.
    // otherwise it will throw an error for non existing email.
    // and these exceptions can be handled, when service will be used.
    if(deleteCount==0){
      throw CouldNotDeleteNotes();
    }else{
      // after deleting a note from database this should be updates in note list and stream controller
      // as well.
      _notes.removeWhere((note) =>note.id==id);
      _notesStreamController.add(_notes);
    }

  }
 //=========================================================================================================

//this function createNotes return the notes and also take in as parameter, who is owner of the notes.
 // which will be a database user.
  Future<DatabaseNotes> createNotes({required DatabaseUser owner}) async{
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    // we will check current user that we are passing is already exist in the database.
    final dbUser=await getUser(email: owner.email);
    // to ensure that user exist in the database with correct id
    if(dbUser!=owner){ // this operator will compare id's
      throw UserNotExistInTable();
    }
    const text='Reminder : Report sending to venture capital at 3 pm tomorrow.';
    // now ensuring everything , create the notes.
    final notesId=  await db.insert(notesTable, {
      columnUserid: owner.id,
      columnText: text,
      columnSynced:1
    });

   final note=DatabaseNotes(id:notesId, userId: owner.id, text: text,
        syncWithCloud: true);
  // this new note will be added to _note list and stream controller both
    _notes.add(note);
    _notesStreamController.add(_notes);

   return note;
  }

  // read a user from the database
  Future<DatabaseUser> getUser({ required String email})async{
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    // limit:1--> means query will return at most one record that matches the specified condition.
    final result= await db.query(userTable,limit: 1,where: 'email=?',whereArgs: [email.toLowerCase()]);
    // as limit set to one so there will be only one record taken from the table
    if(result.isEmpty){
      throw UserNotExistInTable();
    }
    // it can be the other way
    return DatabaseUser.fromRow(result.first);

  }

  Future<DatabaseUser> createUser({ required String email})async{
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    // search for single record in the table where email address matches the provided email address.
    // result returns the list of rows, if this list is not empty, it means user with provided email
    // address already exists in the database.
    // limit:1--> means query will return at most one record that matches the specified condition.
   final result= await db.query(userTable,limit: 1,where: 'email = ?',whereArgs: [email.toLowerCase()]);
   if(result.isNotEmpty){
     throw UserAlreadyExist();
   }
   // insert map of values into the specified table and return id of last inserted row.
   final userId=  await db.insert(userTable, {
     columnEmail: email.toLowerCase(),
   });
   return DatabaseUser(id: userId, email:email);
  }
//----------------------------------------------------------------------------------------------------
  Future<void> deleteUser({ required String email})async{
    // delete as many objects from the userTable, and their email should be equal to email passed to the
    // deleteUser function
    await ensureDbIsOpen();
    final db=_getDatabaseOrThrow();
    // it returns the number of rows affected by the delete operation
    final deleteCount= await db.delete(userTable,where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    // deleteCount will be 1 as email is unique for each user.
    // otherwise it will throw an error for non existing email.
    // and these exceptions can be handled, when service will be used.
    if(deleteCount!=1){
      throw CouldNotDeleteUser();
    }

  }

  Future<void> ensureDbIsOpen()async{
    // when notesView is hot reloaded, not going to open the database again and
    // again, otherwise exception will be thrown.
    try{
      await open();
    } on DatabaseAlreadyOpenException{
      //
    }

  }
  //opening the database is async because it involves grab the current document folder and append that document folder
  // with the dbName using the join
  // async means not immediately completed, takes some time to complete.
  Future<void> open() async {
    // after opening the database , store it somewhere in the note service
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      // now get the document directory path
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath =
          join(docsPath.path, dbname); // this will give us path of db
      // openDatabase also creates database for you, if it does not exist previously.
      final db = await openDatabase(dbPath);
      // then assign this db to local db instance
      _db = db;
      // now the code for creating the tables in the database.
      await db.execute(createUserTable);
      await db.execute(createNotesTable);

      // after opening database and creating tables, cache all the notes in the local variable
      await _cacheNotes();

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close()async{
    final db=_db;
    if(db==null){
      throw DatabaseIsNotOpen();
    }
    else{
     await db.close();
     _db=null;
    }

  }
  // actually we will have to need this database for later on operations so creating this function
  // reading and writing functions will get current db from this function.
  Database _getDatabaseOrThrow(){
    final db=_db;
    if(db==null){
      throw DatabaseIsNotOpen();
    }
    else{
      return db;
    }
  }
  // deleting the user from the database.

}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : // in map, key will be column name, and value will be data it contains.
        id = map[columnId] as int,
        email = map[columnEmail] as String;

  @override
  String toString() => 'id is $id and email is $email';

  @override
  // comparing user of our class to another user of same class.
  // if both are same users , they can refer to same notes, right?
  // this function requires you to compare an object with another object of other class, but here we are
  // using covariant to make it
  // possible to compare it with another instance of same class that is comparing one user with other within same class.
  bool operator ==(covariant DatabaseUser other) => id == other.id;// customise the implementation of
  // == operator so it will check id of one object to the other object when called

  @override
  int get hashCode => id.hashCode; // customizing the implementation and getting the hashcode of id
}

class DatabaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool syncWithCloud;

  DatabaseNotes({required this.id,
      required this.userId,
      required this.text,
      required this.syncWithCloud});

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : // in map, key will be column name, and value will be data it contains.
        id = map[columnId] as int,
        userId = map[columnUserid] as int,
        text=map[columnText] as String,
       syncWithCloud=(map[columnSynced] as int)== 1 ? true :false;

  @override
  String toString() => 'id : $id , user id : $userId, text : $text and synced : $syncWithCloud';

  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

}

