import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/utilities/dailog/generic_dialog.dart';


Future<void> cannotShareEmptyNoteDialog (BuildContext context){
  return showGenericDialog<void>(context: context, text: '',
    title: 'Sharing', content: 'Cannot Share an Empty Note',
    optionBuilder: ()=>{
      'Ok' :null

    },
  );
}