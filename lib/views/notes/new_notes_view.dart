import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/crud/notes_services.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  // keep hold of note
  DatabaseNotes? _note;
  // keep hold of note service too:
  // and make it late final so that no need to create instance over and over
  // instance will be created when it is used
  late final NoteService _noteservice;
  late final TextEditingController textController;

  @override
  void initState() {
    _noteservice=NoteService();
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
  Future<DatabaseNotes> createNote()async{
    final existingNote=_note;
    // if there is existing note, return that
    if(existingNote!=null){
      return existingNote;
    }
    else{
      // if not exist then create it.
      // null assertion at the end to assert that user cannot be null
      final user=AuthService.firebase().currentUser!;
      final email=user.email!;
      final owner=await _noteservice.getUser(email: email);
      final newNote= await _noteservice.createNotes(owner: owner);
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
   await _noteservice.deleteNote(id: note.id);
  }
  }

  // now about saving the note if it is not empty
  void saveNoteIfNotEmpty()async{
    final note=_note;
    if(textController.text.isNotEmpty && note != null){
     await _noteservice.updateNotes(note: note, text: _note!.text);
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
    await _noteservice.updateNotes(note: note, text: text);
  }

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

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     title:  const Text('New Notes', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(future: createNote(),
          builder: (context,snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
          // perform logic here
          // get note returned from future using snapshot.data:
          _note=snapshot.data as DatabaseNotes;
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

