import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_taking_app_khirman/views/registerview.dart';
import '../firebase_options.dart';

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
                        final a= await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        Fluttertoast.showToast(msg: "Logged In Successfully");
                        print(a);
                      }
                      on FirebaseAuthException catch (e) {
                        print(e.code);
                        switch (e.code) {
                          case 'invalid-credential':
                            Fluttertoast.showToast(msg: "Invalid credentials. Please check your email and password.");
                            break;
                          default:
                            Fluttertoast.showToast(msg: e.code);
                        }
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

                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/register');

                  },
                      child: const Text("Not Registered yet? Register here!")
                  ),
                ],
              ),

      );

  }
}
