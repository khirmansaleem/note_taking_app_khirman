import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app_khirman/services/auth/auth_exceptions.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_bloc.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_events.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_state.dart';
import 'package:note_taking_app_khirman/utilities/dailog/error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  // you will have to init and dispose both the email and password:
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc,AuthState>(
      listener: (context,state)async{
        // now handle exceptions in this bloc
        if(state is AuthStateLoggedOut){
          if(state.exception is InvalidCredentialsAuthException){
            await showErrDialog(context, 'Invalid Credentials');
          }
          else if(state.exception is UserNotLoggedInAuthException){
            await showErrDialog(context, 'Login Failure');
          }
          else if(state.exception is GenericAuthException){
            await showErrDialog(context, 'Login Failure');
          }

        }
      },
    child:  Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
                children: [
                  // for passing the textfields info to the button pressed event.
                  // text editing controller can be used here
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: "Enter your email"),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        const InputDecoration(hintText: "Enter your password"),
                  ),

                    TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                          LoginEvent(email: email, password: password)
                      );

                      }
                   ,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                  ,
                  // final user=FirebaseAuth.instance.currentUser;
                  TextButton(onPressed: (){
                  context.read<AuthBloc>().add(
                    const ShouldRegisterEvent()
                  );

                  },
                      child: const Text("Not Registered yet? Register here!")
                  ),
                  TextButton(onPressed: (){
                    context.read<AuthBloc>().add(
                       const  ForgotPasswordEvent(email:null)
                    );

                  },
                      child: const Text("Forgot Password, Click here to reset.")
                  ),

                ],
               )
              ),

              );
  }
}



/*
                      await AuthService.firebase().logIn(email: email, password: password);

                        final user=AuthService.firebase().currentUser;// it gives us the logged in user
                        //in the firebase.
                        if(user!=null) { // user is logged in, current user not null
                          if (user.isEmailVerified) {
                            Fluttertoast.showToast(msg: "Logged In Successfully");
                            //  Navigator.pushNamed(context, '/notesview');
                            Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);

                          }
                          else{
                            Fluttertoast.showToast(msg: "Verify your email first.");
                            Navigator.of(context).pushNamedAndRemoveUntil(emailVerRoute, (route) => false);

                          }
                        }
                    */