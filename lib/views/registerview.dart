import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';
import 'dart:developer' as devtools show log;
import 'package:note_taking_app_khirman/utilities/show_error_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
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
                        final a = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: email, password: password);
                        Fluttertoast.showToast(msg: "User registered Successfully");
                        devtools.log(a.toString());
                        // before navigating to email_verification_view
                      // actually send the email
                        final user=FirebaseAuth.instance.currentUser;
                         await user?.sendEmailVerification();
                        Navigator.of(context).pushNamed(emailVerRoute);

                      }
                      on FirebaseAuthException catch (e) {
                        await showErrDialog(context,e.code);
                        Fluttertoast.showToast(msg:e.code);
                      }
                      // ALSO HANDLING GENERIC EXCEPTIONS
                      catch(e){
                        await showErrDialog(context,e.toString());
                      }

                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/login');
                  },
                      child: const Text("Already Registered? Sign in here!")
                  ),
                ],
              ),
    );
  }
}