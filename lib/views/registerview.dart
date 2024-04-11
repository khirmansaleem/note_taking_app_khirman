import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';
import 'package:note_taking_app_khirman/services/auth/auth_exceptions.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_bloc.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_state.dart';
import '../services/auth/bloc/auth_events.dart';
import '../utilities/dailog/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if(state is AuthStateRegistering){
            if(state.exception is EmailAlreadyInUseAuthException){
              await showErrDialog(context, 'Email is already in use');
            }
            else if(state.exception is InvalidEmailAuthException){
               await showErrDialog(context, 'Invalid Email');
            }
            else if(state.exception is WeakPasswordAuthException){
              await showErrDialog(context, 'Weak Password');
            }
            else if(state.exception is GenericAuthException){
              await showErrDialog(context, 'Failed to Register');
            }
          }

        },
        child: Scaffold(

          body: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Create Account",
                  style: TextStyle(
                    color: Color(0xFF404040),
                    fontSize: 32.0, // Choose the size that fits your needs
                    fontWeight: FontWeight.bold,
                  ),),
                // for passing the textfields info to the button pressed event.
                // text editing controller can be used here

                SizedBox(height: 32),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 70% of screen width
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                    const InputDecoration(hintText: "Enter your email",
                      hintStyle: TextStyle(
                        fontSize: 14.0, // Adjust the font size of the hint text here
                        color: Colors.grey, // Optionally adjust the color of the hint text
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black, // Color for the border when the TextField is focused
                        ),
                      ),
                    ),

                  ),
                ),
                SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child:  TextField(
                  textAlign: TextAlign.center,
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration:
                  const InputDecoration(hintText: "Enter your password",
                    hintStyle: TextStyle(
                      fontSize: 14.0, // Adjust the font size of the hint text here
                      color: Colors.grey, // Optionally adjust the color of the hint text
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black, // Color for the border when the TextField is focused
                      ),
                    ),
                  ),
                ),
              ),
                SizedBox(height: 24),
               Container(
                 width: MediaQuery.of(context).size.width * 0.8,
                 child:  TextButton(
                   onPressed: () async {
                     final email = _email.text;
                     final password = _password.text;
                     context.read<AuthBloc>().add(
                         RegisterEvent(email: email,password: password)
                     );

                   },
                   style: TextButton.styleFrom(
                     padding: EdgeInsets.symmetric(vertical: 8),
                     backgroundColor: Color(0xFFFFD700), // Background color
                   ),
                   child: const Text(
                     'Register',
                     style: TextStyle(color: Color(0xFF404040),
                       fontSize: 18.0,),
                   ),
                 ),
               ),


                TextButton(onPressed: () {
                  context.read<AuthBloc>().add(
                      const LogoutEvent() // adding this event to authbloc
                    // will lead authbloc to emit a state which will be
                    //logout which leads to login view

                  );
                },
                    child:
                      RichText(
                      text:const  TextSpan(
                        style: TextStyle( // Default text style for all spans
                          color: Color(0xFF404040), // Specify the color for the text
                          fontSize: 12.0, // Specify the font size for the text
                        ),
                        children: <TextSpan>[
                            TextSpan(text: 'Already Registered? '),
                             TextSpan(
                            text: 'sign in here!',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                             fontWeight: FontWeight.bold
                              // This underlines the text
                            ),
                          ),

                        ],
                      ),
                    )
                )

              ],
            ),
          ),


        ),
      );
    }


  }