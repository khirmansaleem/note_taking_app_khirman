import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/utilities/dailog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context){
  return  showGenericDialog<bool>(context: context,
      text: 'logout'
      ,
      title: 'Log out', content: 'Are you sure want to log out?',
      optionBuilder: ()=>{
       'Cancel' : false,
        'Log out' : true,
      }
      ).then((value)=>value??false);
}