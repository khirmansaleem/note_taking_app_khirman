import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_bloc.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_events.dart';
import 'package:note_taking_app_khirman/services/auth/bloc/auth_state.dart';
import 'package:note_taking_app_khirman/utilities/dailog/error_dialog.dart';
import 'package:note_taking_app_khirman/utilities/dailog/password_reset_email_sent_dialog.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller=TextEditingController();

    super.initState();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return BlocListener<AuthBloc,AuthState>(
        listener: (context,state)async{
          // listener listen to changes in the bloc and shows side effects.
          if(state is AuthStateForgotPassword){
            if(state.hasSentEmail){
              controller.clear();
              await showResetEmailSentDialog(context
                  ,'If your email address is registered with us, you will receive a link to reset your password.');
            }
           else if(!state.hasSentEmail){
              await showErrDialog(context, 'The email format is incorrect.');
            }
          }
        },
      child: Scaffold(

       body: Center(
             child:  Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text("Forgot Password",
                     style: TextStyle(
                       color: Color(0xFF404040),
                       fontSize: 32.0, // Choose the size that fits your needs
                       fontWeight: FontWeight.bold,
                     ),),

                   SizedBox(height: 32),

                   Container(
                     width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                       'If you forgot your password, enter your email so we send you a reset link.',
                       textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF404040),
                      ),


                      // This aligns the text to the center
                     ),
                   ),

                   SizedBox(height: 16),

                   Container(
                     width: MediaQuery.of(context).size.width * 0.8,
                   child:  TextField(
                     textAlign: TextAlign.center,
                       controller: controller,
                       keyboardType: TextInputType.emailAddress,
                       autocorrect: false,
                       autofocus: true,
                       decoration: const InputDecoration(
                         hintText: 'Write your email address here',
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
                     child:   TextButton(onPressed:(){
                       context.read<AuthBloc>().add(
                           ForgotPasswordEvent(email: controller.text)
                       );

                     },
                         style: TextButton.styleFrom(
                           padding: EdgeInsets.symmetric(vertical: 8),
                           backgroundColor: Color(0xFFFFD700), // Background color
                         ),
                         child: const Text('Send password reset email',
                           style: TextStyle(color: Color(0xFF404040),
                             fontSize: 16.0,),)
                     ),
                   ),

                   SizedBox(height: 4),

                   Container(
                       width: MediaQuery.of(context).size.width * 0.8,
                     child: TextButton(onPressed:(){
                       context.read<AuthBloc>().add(
                           const LogoutEvent()// send user to login page
                       );

                     },

                         style: TextButton.styleFrom(
                           padding: EdgeInsets.symmetric(vertical: 8),
                           backgroundColor: Color(0xFFFFD700), // Background color
                         ),
                         child: const Text('Back to login page',
                           style: TextStyle(color: Color(0xFF404040),
                             fontSize: 16.0,),)

                         // Increases the top and bottom padding
                     // You can adjust the vertical padding to increase or decrease the height.
                   ),
                     )


                 ]
             ),
           ),

      )
    );
  }
}
