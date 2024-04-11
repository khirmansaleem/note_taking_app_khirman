import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app_khirman/constants/routes.dart';
import 'package:note_taking_app_khirman/services/auth/auth_service.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_bloc.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_events.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align items along the main axis
          children: [
            const Text("Verify Your Email",
              style: TextStyle(
                color: Color(0xFF404040),
                fontSize: 32.0, // Choose the size that fits your needs
                fontWeight: FontWeight.bold,
              ),),
            // for passing the textfields info to the button pressed event.
            // text editing controller can be used here

            SizedBox(height: 32),

            const Text('We have send you verification email, please check', style: TextStyle(
              color: Color(0xFF404040),
            )),
            const Text('If not received yet, press the button below.',
              style: TextStyle(
                color: Color(0xFF404040),)
            ),
            SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextButton(
                onPressed: (){
                  //await AuthService.firebase().sendEmailVerification();
                  context.read<AuthBloc>().add(
                      const SendEmailVerificationEvent()
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Color(0xFFFFD700), // Background color
                ),
                child: const Text('Send Email Verification',style: TextStyle(color: Color(0xFF404040),
                  fontSize: 16.0,),),
              ),
            ),

            SizedBox(height: 4),

            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextButton(
                onPressed: (){
                  context.read<AuthBloc>().add(
                      const LogoutEvent()
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Color(0xFFFFD700), // Background color
                ),
                child: const Text('Restart',style: TextStyle(color: Color(0xFF404040),
                  fontSize: 16.0,),),
              ),
            ),


          ],
        ),
      ),

    );
  }
}