import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app_khirman/helpers/loading/loading_screen.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_bloc.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_events.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_state.dart';
import 'package:note_taking_app_khirman/services/auth/firebase_auth_provider.dart';
import 'package:note_taking_app_khirman/views/SplashScreen.dart';
import 'package:note_taking_app_khirman/views/forgotpasswordview.dart';
import 'package:note_taking_app_khirman/views/loginview.dart';
import 'package:note_taking_app_khirman/views/notes/create_update_noteview.dart';
import 'package:note_taking_app_khirman/views/registerview.dart';
import 'package:note_taking_app_khirman/views/verifyemailview.dart';
import 'package:note_taking_app_khirman/views/notes/notesview.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';


void main() {
  // for firebase to be initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      fontFamily:'Roboto',
      brightness: Brightness.light,
      textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
    ),
    home: BlocProvider<AuthBloc>(
      // create instance of AuthBloc and it will pass firebaseAuthProvider in it
        create: (context)=> AuthBloc(FirebaseAuthProvider()),
        child:  HomePage()
    ),
    routes: {
      createOrUpdateNotesRoute: (context)=> const CreateUpdateNotesView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    // sending initialize event to bloc
    // this it for firebase initialization, we dont need to include any logic
    // here , bloc and service can handle those stuff.
    context.read<AuthBloc>().add(const InitializeEvent());
    return BlocConsumer<AuthBloc,AuthState>(
      listener:(context,state)async{
        if(state.isLoading){
          LoadingScreen().show(context: context, text: 'please wait for a moment');
          await Future.delayed(const Duration(seconds: 1));

        }
        else{
          LoadingScreen().hide();
        }
      },

        builder: (context,state){
      // now we can use bloc states for HomePage
      if(state is AuthStateLoggedIn){ // using these states, navigation can be done anywhere within
        // the app when the state is met
        // like when we emit logout event then the bloc will emit state based
        // on event and state will be logged out, and based on that
        // logged out state it will move to loginView
        return const NotesView();
      }
      else if(state is AuthStateNeedsVerification){
        return const VerifyEmailView();
      }
      else if(state is AuthStateLoggedOut){
        return const LoginView();
      }
      else if(state is AuthStateRegistering){
        return const RegisterView();
      }
      else if(state is AuthStateForgotPassword){
        return const ForgotPassword();
      }
      else{
        return const Scaffold(
          body: CircularProgressIndicator() ,
        );
      }

    });

  }
}


