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
      appBar: AppBar(
      title: const Text('Forgot Password',
      style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
    ),
       body:
         Column(
            children: [
              const Text('If you forgot your password, enter your email so we send you reset link.'),
               TextField(
               controller: controller,
               keyboardType: TextInputType.emailAddress,
               autocorrect: false,
               autofocus: true,
               decoration: const InputDecoration(
                   hintText: 'Write your email here'
               ),
             ),
              TextButton(onPressed:(){
                context.read<AuthBloc>().add(
                     ForgotPasswordEvent(email: controller.text)
                );

              },
                  child: const Text('Send Password Reset Email')
              ),

              TextButton(onPressed:(){
                context.read<AuthBloc>().add(
                    const LogoutEvent()// send user to login page
                );

              },
                  child: const Text('Back to login page')
              )
           ]
         ),
      )
    );
  }
}
