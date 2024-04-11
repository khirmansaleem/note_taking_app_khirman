import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_note.dart';
import 'package:note_taking_app_khirman/services/cloud/firebase_cloud_storage.dart';
import 'package:note_taking_app_khirman/utilities/dailog/cannot_share_empty_note_dialog.dart';
import 'package:note_taking_app_khirman/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';
import '../../utilities/deltaJsonToString/textspan.dart';

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
  late final FirebaseCloudStorage _noteService;
   late quill.QuillController controller;


  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    controller = quill.QuillController.basic();
   // updateListener('');
    super.initState();
  }

  @override
  void dispose() {
    deleteNoteIfTextEmpty();
    saveNoteIfNotEmpty();
    controller.dispose();
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
     final text=widgetNote.text;
     updateListener(text);
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
      final newNote= await _noteService.createNewNote(ownerUserId: user.id);
      _note=newNote;
      return newNote;
    }
  }

  // if the view is disposed off, or like back button is pressed so
  // current note if it is empty should be deleted.
  // if we don't do this then the view will be full of empty notes,
  // everytime move from screen
  void deleteNoteIfTextEmpty()async{
    print('inside deleteNoteIfNotEmpty');
    final note=_note;
    final text=deltaText();
    final text2=plainText();
   // if there is no text, but note exist, then delete it,

  if(text2.isEmpty && note!=null ){
    print('note is empty');
   await _noteService.deleteNote(documentId: note.documentId);
  }

  }

  // now about saving the note if it is not empty
  void saveNoteIfNotEmpty()async{
    final note=_note;
   final text= deltaText();
   final text2=plainText();
   print('inside save note if not empty');
   print(text2);
    if(text2.isNotEmpty && note != null){
     await _noteService.updateNote(documentId: note.documentId,
         text: text);
    }
  }

  void updateListener(String jsondelta) {

    // Decode the JSON string to obtain the delta format
    final decodedDelta = json.decode(jsondelta);

    // Since `Document.fromDelta` expects a Delta object, convert `decodedDelta` to Delta
    final Delta delta = Delta.fromJson(decodedDelta);

    // Create a new document with the delta
    final Document initialDocument = Document.fromDelta(delta);

    // Check if the controller is already initialized
    if (controller != null) {
      // Replace the document in the existing controller
      controller.document = initialDocument;
      // Correctly update the selection
      controller.updateSelection(TextSelection.collapsed(offset:initialDocument.length-1),
          ChangeSource.local);
    } else {
      // If the controller is not initialized, create a new instance with the initial document
      controller = QuillController(
        document: initialDocument,
        selection: TextSelection.collapsed(offset: initialDocument.length-1),
      );
    }
  }


/*
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

   */
  void setupQuillControllerListener() {
    controller.document.changes.listen((_) {
      _quillControllerListener(); // Call your update method directly
    });
  }

  void _quillControllerListener() async {
    final note=_note;
    // Serialize the Quill document (Delta format) to JSON
    // String text = jsonEncode(controller.document.toDelta().toJson());
    String text=deltaText();
    if(note==null){
      return; // break out of function
    }
    await _noteService.updateNote(documentId: note.documentId,
        text: text);
  }

  String plainText(){
    final String text1 = jsonEncode(controller.document.toDelta().toJson());
    final List<dynamic> ops=jsonDecode(text1);
    final StringBuffer text = StringBuffer();
    for (var op in ops) {
      if (op is Map<String, dynamic> && op.containsKey('insert')) {
        // Write the 'insert' value to our text buffer.
        text.write(op['insert']);
      }
    }
    // Return the concatenated text content.
    return text.toString().trim();
  }


  String deltaText() {
    final  jsonDelta = jsonEncode(controller.document.toDelta().toJson());
    final List<dynamic> ops = jsonDecode(jsonDelta);
    final StringBuffer formattedText = StringBuffer();
    return jsonDelta.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final text = plainText();
              if (_note == null || text.isEmpty) {
                await cannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
            color: Color(0xFF404040),
          )
        ],
        title:
            const Text('Add new note', style: TextStyle(color: Color(0xFF404040))),
        backgroundColor: Color(0xFFFFD700),

      ),
      body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
            case ConnectionState.done:
            setupQuillControllerListener();
            return Column(
            children: [

            Card(
            color: Color(0xFF404040),
            elevation: 4.0, // Adjust the elevation as needed
            child: Theme(
            data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(
                subtitle1: TextStyle(color: Colors.white), // Adjusts dropdown text color
                // You may need to adjust other text style properties depending on your needs
              ),// Set your desired icon color
            ),

            child: quill.QuillToolbar.simple(
            configurations: quill.QuillSimpleToolbarConfigurations(
            controller: controller,
            showClearFormat: false,
            showCodeBlock: false,
            // showDirection: false,
            showSubscript: false,
            showFontFamily: true,
            showSuperscript: false,
            showInlineCode: false,
            showLink: false,
            showRedo: false,
            showUndo: false,
            showFontSize: true,
            sharedConfigurations:
            const quill.QuillSharedConfigurations(
            locale: Locale('de'),
            ),
            ),
            ),
            ),
            ),
            const SizedBox(height: 60),
            Expanded(child: Container(
            padding: const EdgeInsets.only(bottom: 30),
            // Extra padding for word count display
            decoration: BoxDecoration(
            border: Border.all(
            color: const Color(0xFFe6e6e6),
            // Color of the border
            width: 2.0, // Width of the border
            ),
            borderRadius: BorderRadius.circular(
            5.0), // Optional: if you need rounded corners
            ),
            child: Stack(
            children: [
            quill.QuillEditor.basic(
            configurations: quill.QuillEditorConfigurations(
            controller: controller,
            readOnly: false,
            placeholder: 'Enter your text here....',
            scrollable: true,
            autoFocus: true,
            expands: false,
            padding: const EdgeInsets.all(10),
            sharedConfigurations:
            const quill.QuillSharedConfigurations(
            locale: Locale('de'),
            ),
            ),
            ),

            ],

            ),
            ),)// Adds space between the Card and Container

            ],
            );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }

// Your existing methods like deleteNoteIfTextEmpty and saveNoteIfNotEmpty
// need to be updated to work with the rich text format
}

//---------------------------------------------------------------------
/*
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
     title:  const Text('Add new note', style: TextStyle(color: Colors.white),),
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
          setupQuillControllerListener();
          return TextField(
            controller: textController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'start making your notes here ...',
              border: InputBorder.none, // Removes the underline
            ),
          );


          default:
           return const CircularProgressIndicator();

        }
          }
          )
      ,
    );
  }*/


