import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/utilities/dailog/generic_dialog.dart';

Future<bool> showDeleteDialog (BuildContext context){
  return  showGenericDialog<bool>(context: context,
      text: 'Delete'
      ,
      title: 'Delete', content: 'Are you sure want to delete?',
      optionBuilder: ()=>{
        'Cancel' : false,
        'Delete' : true,
      }
  ).then((value)=>value??false);

}