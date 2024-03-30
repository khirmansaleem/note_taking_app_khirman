import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/utilities/dailog/generic_dialog.dart';

Future<void> showResetEmailSentDialog(BuildContext context,
    String text) async {

  return showGenericDialog<void>(context: context, text: text,
    title: 'Password Reset', content: 'If your email address is registered with us, you will receive a link to reset your password.',
    optionBuilder: ()=>{
      'OK' :null

    },
  );
}