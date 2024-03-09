// generic dialog with text that error occured
import 'package:flutter/material.dart';

Future<void> showErrDialog(
    BuildContext context,
    String text
    ){
  return showDialog(context:context, builder: (context){
    return AlertDialog(
      title: const Text('An error occured'),
      content: Text(text),
      actions: [
        TextButton(onPressed:(){
          // this is used to dismiss the dialog.
          Navigator.of(context).pop();

        }, child: const Text('OK'),
        ),
      ],
    );
  },);

}