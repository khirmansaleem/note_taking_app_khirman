// creating new cloud firestore service.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_note.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_storage_constants.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage{
  // grab all the notes from the firestore storage.
  final notes=FirebaseFirestore.instance.collection('notes');


  // Get all the notes for a specific user:
  // if you want to get realtime data of all notes, and remain updated about then
  // you need to subscribe to snapshot
  // all the changes that are happening live will be updated to you
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId})=>
  // in query snapshot then are docs and mapping every doc with cloud note,
      // where note's user id is equal to current user id
      notes.snapshots().map((event) => event.docs.map((doc) => 
          CloudNote.fromSnapshot(doc)).where((note) => note.ownerUserId==ownerUserId)
      );

  //Create a function for creating new Notes:
  // you can read and write as well to the collectionReference.
  Future<CloudNote> createNewNote({required String ownerUserId})async{
// whether you are adding will be packaged into a doc that will be stored
  // in the database with fields and values specified.
  final document= await notes.add({
      ownerUserIdFieldName : ownerUserId,
      textFieldName : ''

    });
  final fetchedNote= await document.get();
  return CloudNote(documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '');
  }

  Future <Iterable<CloudNote>> getNotes({required String ownerUserId})async {
    try{
      // search for all notes, that belongs to current owner user id
      // notes.where() gives you a query then you execute that query and you do that
      // using get()
      //USING then() inside future allow you to return a synchronous value from that
      // future or let you return another future from that. 
      return await  notes.where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId
      ).get().then((value) => value.docs.map((doc)=>
          CloudNote.fromSnapshot(doc),
      )
      );
        /*
        //commenting it out to use instead convenient constructor
        return CloudNote(documentId: doc.id,
            ownerUserId: doc.data()[ownerUserIdFieldName] as String,
            text: doc.data()[textFieldName] as String
        );*/
    }
    catch(e){
      throw CouldNotGetAllNotesException();
    }

  }

  Future<void> updateNote({required String documentId, required String text}) async{
      try{
        // based on doc id fetch that doc and update given field in
        // doc with the given text.
       await notes.doc(documentId).update({textFieldName: text});


      }
      catch(e){
        throw CouldNotUpdateNoteException();

      }

  }

  Future<void> deleteNote({required String documentId})async{
    try{
     await notes.doc(documentId).delete();
    }
    catch(e){
      throw CouldNotDeleteNoteException();

    }

  }

  // singleton instance of firebase Cloud storage.
  static final FirebaseCloudStorage _shared=FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage()=> _shared;

}