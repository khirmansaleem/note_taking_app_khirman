import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: const Text("Verify Email",
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align items along the main axis
          children: [
            const Text('We have send you verification email, please check'),
            const Text('If not received yet, press the button below.'),
            TextButton(
              onPressed: () async{
                final user=FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();


              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
              ),
              child: const Text('Send email verification',style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              onPressed: ()async{
               await FirebaseAuth.instance.signOut();
               Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);

              },
              child: const Text('Restart'),
            ),
          ],
        ),
      ),

    );
  }
}