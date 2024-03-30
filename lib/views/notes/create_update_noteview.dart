import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_note.dart';
import 'package:note_taking_app_khirman/services/cloud/firebase_cloud_storage.dart';
import 'package:note_taking_app_khirman/utilities/dailog/cannot_share_empty_note_dialog.dart';
import 'package:note_taking_app_khirman/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({super.key});

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  // keep hold of note
  CloudNote? _note;
  // keep hold of note service too:
  // they will be initialized in the initState, uptill that point we are making
  // contract that they will be initalized before use.
  late final FirebaseCloudStorage _noteservice;
  late final TextEditingController textController;

  @override
  void initState() {
    // calling factory constructor to return the existing instance from
    // _shared.
    _noteservice=FirebaseCloudStorage();
    textController=TextEditingController();

    super.initState();
  }


  @override
  void dispose() {
    // when this noteView will be closed,
    // these two functions will be called.
    deleteNoteIfTextEmpty();
    saveNoteIfNotEmpty();
    // after that get rid of text editing controller and dispose on
    // it as well:
    textController.dispose();
    super.dispose();
  }

  // creating a validation type function for creating notes,
  // if note already exist then not create, otherwise create.
  Future<CloudNote> createOrGetExistingNote(BuildContext context)async{
   // receive databaseNote as argument which is to be modified
    final widgetNote= context.getArgument<CloudNote>();
   if(widgetNote!= null){
     // note will contain it's content
     _note=widgetNote as CloudNote?;
     // prepopulate text controller with the content of this note.
     textController.text=widgetNote.text;
     return widgetNote;
   }
    final existingNote=_note;

    // if there is existing note, return that
    if(existingNote!=null){
      return existingNote;
    }
    else{
      // if not exist then create it.
      // null assertion at the end to assert that user cannot be null
      final user=AuthService.firebase().currentUser!;
      //final email=user.email;
     // final owner=await _noteservice.getUser(email: email);
      final newNote= await _noteservice.createNewNote(ownerUserId: user.id);
      _note=newNote;
      return newNote;
    }
  }

  // if the view is disposed off, or like back button is pressed so
  // current note if it is empty should be deleted.
  // if we don't do this then the view will be full of empty notes,
  // everytime move from screen
  void deleteNoteIfTextEmpty()async{
    final note=_note;
   // if there is no text, but note exist, then delete it,
  if(textController.text.isEmpty && note!=null ){
   await _noteservice.deleteNote(documentId: note.documentId);
  }
  }

  // now about saving the note if it is not empty
  void saveNoteIfNotEmpty()async{
    final note=_note;
   final text= textController.text;

    if(textController.text.isNotEmpty && note != null){
     await _noteservice.updateNote(documentId: note.documentId,
         text: text);
    }

  }

  // constantly updating current note based on the realtime changes
  // in the text field.
  void _textControllerListener()async{

    final note=_note;
     final text;
    if(note==null){
      return; // break out of function
    }
    text=textController.text;

    await _noteservice.updateNote(documentId: note.documentId,
        text: text);
  }
  //-------------------------------------------------------------------------
  //========================================================================
  //------------------------------------------------------------------------
  // now hook the text field changes to the listener:
  void setupTextControllerListener(){
    // remove and add listener
    // removing if already exist and then again listening
    textController.removeListener(() {
      _textControllerListener();
    });
    textController.addListener(() {
      _textControllerListener();
    });
    _textControllerListener();
  }
//---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      actions: [
        IconButton(onPressed: ()async{
          final text= textController.text;
          if(_note==null || text.isEmpty ){
           await cannotShareEmptyNoteDialog(context);
          }
          else{
            Share.share(text);
          }

        }, icon: const Icon(Icons.share),
          color: Colors.white,)
      ],
     title:  const Text('New Notes', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(future: createOrGetExistingNote(context),
          builder: (context,snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
          // perform logic here
          // get note returned from future using snapshot.data:
         // _note=snapshot.data as DatabaseNotes;
          // now start listening to user text changes on our UI
          setupTextControllerListener();
          return TextField(
            controller: textController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'start making your notes here ...'
            ),
          );


          default:
           return const CircularProgressIndicator();

        }
          }
          )
      ,
    );
  }
}

