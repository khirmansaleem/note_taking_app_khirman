import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:note_taking_app_khirman/constants/routes.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import '../lib/enums/MenuActions.dart';

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

//------------------------------------------------------------------------------
//==============================================================================
//------------------------------------------------------------------------------
class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes',
          style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue,
          actions:[
            PopupMenuButton<MenuAction>(
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
              },)
          ],
      ),

    );
  }
}
