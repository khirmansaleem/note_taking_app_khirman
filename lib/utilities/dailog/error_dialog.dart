
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app_khirman/utilities/dailog/generic_dialog.dart';

Future<void> showErrDialog(BuildContext context,
    String text) async {

  return showGenericDialog<void>(context: context, text: text,
      title: 'An error occur', content: text,
      optionBuilder: ()=>{
     'OK' :null

      },
  );
}