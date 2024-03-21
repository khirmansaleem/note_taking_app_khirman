import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';
import 'package:note_taking_app_khirman/services/auth/auth_exceptions.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
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
    return Scaffold(
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

                      try{
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

                      }
                      on InvalidCredentialsAuthException catch(e){
                        await showErrDialog(context, 'Invalid Credentials');
                      }
                       catch(e){
                        await showErrDialog(context,e.toString());
                      }
                      // ALSO HANDLING GENERIC EXCEPTIONS
                      catch(e){
                        await showErrDialog(context,e.toString());
                      }
                      }
                   ,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                    // final user=FirebaseAuth.instance.currentUser;
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, registerRoute);

                  },
                      child: const Text("Not Registered yet? Register here!")
                  ),
                ],
              ),
      );
  }
}

