// this service will grab the hold of database, read and write to the database using queries.
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app_khirman/services/crud/crud_constants.dart';
import 'package:note_taking_app_khirman/services/crud/crud_crudexceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;
//-------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------
class NoteService {
  Database? _db;
  // Functionality of updating the existing notes:
  Future<DatabaseNotes> updateNotes({required DatabaseNotes note,
    required String text
  })async{
    final db=_getDatabaseOrThrow();
   await getNote(id: note.id);
 final updateCounts= await  db.update(notesTable, {
       columnText:text,
      columnSynced: 0
    });
 if(updateCounts==0){
   throw CanNotUpdateDatabase();

 }
 return await getNote(id: note.id);


  }

  // get all the notes from the database.
  Future< List<Map<String, Object?>>> getAllNotes() async{
    final db=_getDatabaseOrThrow();
    final notes= await db.query(notesTable);
    return notes;
  }


  // get a particular note using it's id
  Future<DatabaseNotes> getNote({ required int id}) async{
    final db=_getDatabaseOrThrow();
    // limit:1--> means query will return at most one record that matches the specified condition.
    // query the database and returns the result.
    final result= await db.query(notesTable,limit: 1,where: 'id = ?',whereArgs: [id]);
    // as limit set to one so there will be only one record taken from the table
    if(result.isEmpty){
      throw NoteNotExistInTable();
    }
    // it can be the other way
    return DatabaseNotes.fromRow(result.first);

  }
  //---------------------------------------------------------------------------------------------------
  // function which allow you to delete all the notes from the database:
  // it will return the number of notes that were deleted from the database.
  Future<int> deleteAllNotes()async{
    final db=_getDatabaseOrThrow();
    // this operation will delete all the rows from the table, not the column names or struture of the table.
   final  deleteCount=  await db.delete(notesTable);
   return deleteCount;
  }

  // now create function to delete a note.
  Future<void> deleteNotes({ required int id})async{
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
    }

  }
 //=========================================================================================================

//this function createNotes return the notes and also take in as parameter, who is owner of the notes.
 // which will be a database user.
  Future<DatabaseNotes> createNotes({required DatabaseUser owner}) async{
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
    return DatabaseNotes(id:notesId, userId: owner.id, text: text,
        syncWithCloud: true);


  }

  // read a user from the database
  Future<DatabaseUser> getUser({ required String email})async{
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

