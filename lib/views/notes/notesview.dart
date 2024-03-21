import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:note_taking_app_khirman/constants/routes.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/auth/auth_user.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_note.dart';
import 'package:note_taking_app_khirman/services/cloud/firebase_cloud_storage.dart';
import 'package:note_taking_app_khirman/services/crud/notes_services.dart';
import 'package:note_taking_app_khirman/views/notes/notes_list_view.dart';
import '../../lib/enums/MenuActions.dart';
import '../../utilities/dailog/logout_dialog.dart';

// you can use alias for the import so you may not confuse in choosing right
// import in your project.

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

//--------------------------------------------------------------------------------------------------------
//==============================================================================
//--------------------------------------------------------------------------------------------------------
class _NotesViewState extends State<NotesView> {
// here we are getting the user email which is optional, but here we are making an assertion that it will not
// be null.
// current email of firebase user.
//--------------------------------------------------------------------------------------------------------
  String get userId => AuthService.firebase().currentUser!.id ?? 'default@email.com';
  late final FirebaseCloudStorage notesService;
//----------------------------------------------------------------------------------------------------------
// open the database when notesView is initiated, and close database when notesView is closed.
  @override
  void initState(){
  // in the init state, we are creating a new note service everytime.
    // open the database when notesView is initiated first
    notesService=FirebaseCloudStorage();
   super.initState();
  }
  /*
  noteService is singleton, upon creating one time it should keep it's state
  so we remove dispose function,
  // each time we do hot reload, it closes noteService, which in turn
  // closes database as well

  @override
  void dispose() {
    // when this noteView will be closed, database will be closed as well.
    notesService.close();
    super.dispose();
  }
  */

  //===========================================================================================================
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes',
          style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue,
          actions:[
            IconButton(onPressed:(){
              Navigator.pushNamed(context,createOrUpdateNotesRoute);

            }, icon: const Icon(Icons.add),
              color: Colors.white,
            ),
            PopupMenuButton<MenuAction>(
              icon: const Icon(Icons.more_vert,color: Colors.white),
              onSelected: (value)async{
                devtools.log(value.name);
                switch(value){
                  case MenuAction.logout:
                    final shouldlogout=await showLogOutDialog(context);
                    devtools.log(shouldlogout.toString());
                    if(shouldlogout){
                    await AuthService.firebase().logOut();
                    Navigator.pushNamed(context, loginRoute);
                    }
                    //break;
                }
              },
              itemBuilder: (context){ // return list of pop up menu items.
                return[
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
                ];
              },

            )
          ],
      ),
      // in body creating a new user in local database or getting it if already
      // exists.
      // future subscribes itself to the value returned by getOrCreateUser()
      // and tells us various updates which are async snapshots, based on
      // those updates some widget will be displayed.
        // after creating the user, we can grab all the notes using stream
        // controller.
        // as stream builder listening to all notes
      body: StreamBuilder(stream:notesService.allNotes(ownerUserId: userId) ,
             // so data get from snapshot will be all notes.
                builder: (context,snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.active:
                if(snapshot.hasData){
                  final allNotes= snapshot.data as Iterable<CloudNote>;
                  return NotesListView(notes: allNotes,
                      onDeleteNote: (note)async{
                    await notesService.deleteNote(documentId: note.documentId);

                  },
                    onTap: (note){
                      Navigator.pushNamed(context,createOrUpdateNotesRoute,
                          arguments:note);
                    },
                  );
                }
                else{
                  return const CircularProgressIndicator();
                }
                default:
                  return const  CircularProgressIndicator();
              }

                })


          );


  }
}
