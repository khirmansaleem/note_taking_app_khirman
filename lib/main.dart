import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/views/loginview.dart';
import 'package:note_taking_app_khirman/views/notes/create_update_noteview.dart';
import 'package:note_taking_app_khirman/views/registerview.dart';
import 'package:note_taking_app_khirman/views/verifyemailview.dart';
import 'package:note_taking_app_khirman/views/notes/notesview.dart';
import 'firebase_options.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';
void main() {
  // for firebase to be initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
       loginRoute: (context) => const LoginView(),
      registerRoute : (context)=> const RegisterView(),
      emailVerRoute :(context)=> const VerifyEmailView(),
      notesRoute :(context)=> const NotesView(),
      createOrUpdateNotesRoute: (context)=> const CreateUpdateNotesView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
      // future passed to the futureBuilder is the firebase
      //initialization.
      future:AuthService.firebase().initialize(),
    builder: (context, snapshot){
    switch (snapshot.connectionState) {
    case ConnectionState.done:
      final user=AuthService.firebase().currentUser;// it gives us the logged in user
      //in the firebase.
      if(user!=null) {// user is logged in, current user not null
        if (!user.isEmailVerified) {
          return const VerifyEmailView();
        }
        else{
          return const NotesView();
        }
      }
      else {
        return const LoginView();
      }


    default:
    return const CircularProgressIndicator();
    }
    }

  );
  }
}


