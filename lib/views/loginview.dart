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

      body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login",
                style: TextStyle(
                  color: Color(0xFF404040),
                  fontSize: 32.0, // Choose the size that fits your needs
                  fontWeight: FontWeight.bold,
                ),),
              SizedBox(height: 32),
              // for passing the textfields info to the button pressed event.
              // text editing controller can be used here

          Container(
            width: MediaQuery.of(context).size.width * 0.8, // 70% of screen width
            child: TextField(
              textAlign: TextAlign.center,
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your email",
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
               // Adjust the width for desired spacing
          Container(
            width: MediaQuery.of(context).size.width * 0.8, // 70% of screen width
            child: TextField(
             // Focused state
              textAlign: TextAlign.center,
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  fontSize: 14.0, // Adjust the font size of the hint text here
                  color: Colors.grey, // Optionally adjust the color of the hint text
                ),
                border: OutlineInputBorder(),

                // Defines the border style when the TextField is focused
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // Color for the border when the TextField is focused
                  ),
                ),
                ),
            ),
          ),

              SizedBox(height: 24),// Adjust the width for desired spacing


          Container(
            width: MediaQuery.of(context).size.width * 0.8, // 70% of screen width
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                // Trigger login event
                context.read<AuthBloc>().add(
                    LoginEvent(email: email, password: password)
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 8),
                backgroundColor: Color(0xFFFFD700), // Background color
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Color(0xFF404040),
                  fontSize: 18.0,),
              ),
            ),
          ),


              SizedBox(height: 16),


              // final user=FirebaseAuth.instance.currentUser;
              TextButton(onPressed: (){
                context.read<AuthBloc>().add(
                    const ShouldRegisterEvent()
                );
              },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Set padding to zero
                    minimumSize: Size(0, 0), // Allows the button to shrink to the height of its content
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap target size
                  ),
                  child: RichText(
                    text:const  TextSpan(
                      style: TextStyle( // Default text style for all spans
                        color: Color(0xFF404040), // Specify the color for the text
                        fontSize: 12.0, // Specify the font size for the text
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Not Registered yet? '),
                        TextSpan(
                          text: 'Register here!',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold
                            // This underlines the text
                          ),
                        ),

                      ],
                    ),
                  ),

              ),


              SizedBox(height: 4),


              TextButton(onPressed: (){
                context.read<AuthBloc>().add(
                    const  ForgotPasswordEvent(email:null)
                );
              },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Set padding to zero
                    minimumSize: Size(0, 0), // Allows the button to shrink to the height of its content
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap target size
                  ),
              child:  RichText(
                  text:const  TextSpan(
                    style: TextStyle( // Default text style for all spans
                      color: Color(0xFF404040), // Specify the color for the text
                      fontSize: 12.0, // Specify the font size for the text
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Forgot Password, '),
                      TextSpan(
                        text: 'Click here to reset.',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold
                          // This underlines the text
                        ),
                      ),

                    ],
                  ),
                )

              ),

            ],
          )
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