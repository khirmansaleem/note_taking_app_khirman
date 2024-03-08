
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            const Text('Please verify your email.'),
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
          ],
        ),
      ),

    );
  }
}