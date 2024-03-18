import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:note_taking_app_khirman/constants/routes.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/crud/notes_services.dart';
import '../../lib/enums/MenuActions.dart';

// you can use alias for the import so you may not confuse in choosing right
// import in your project.

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}
Future<bool> showLogOutDialog(BuildContext context) {
   return showDialog(context: context, builder:
      (context) {
    return AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure want to Sign out?'),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);

        }, child: const Text("Cancel")
        ),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);

        }, child: const Text("Log Out")
        )
      ],
    );
  },
  ).then((value) => value ?? false);
}

//--------------------------------------------------------------------------------------------------------
//==============================================================================
//--------------------------------------------------------------------------------------------------------
class _NotesViewState extends State<NotesView> {
// here we are getting the user email which is optional, but here we are making an assertion that it will not
// be null.
// current email of firebase user.
//--------------------------------------------------------------------------------------------------------
  String get userEmail => AuthService.firebase().currentUser!.email ?? 'default@email.com';

  late final NoteService notesService;
//----------------------------------------------------------------------------------------------------------
// open the database when notesView is initiated, and close database when notesView is closed.
  @override
  void initState(){
  // in the init state, we are creating a new note service everytime.
    // open the database when notesView is initiated first

    notesService=NoteService();
   super.initState();
  }
  @override
  void dispose() {
    // when this noteView will be closed, database will be closed as well.
    notesService.close();
    super.dispose();
  }
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
              Navigator.pushNamed(context,newNotesRoute);

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
      body: FutureBuilder(future: notesService.getOrCreateUser(email: userEmail)
          , builder: (context,snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
            return StreamBuilder(stream:notesService.AllNotes ,
                builder: (context,snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.active:
                return const Text("Waiting for notes");
                default:
                  return const  CircularProgressIndicator();
              }

                });
          default:
            return const  CircularProgressIndicator();

        }

          }),

    );
  }
}
