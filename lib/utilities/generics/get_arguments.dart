import 'package:flutter/material.dart' show BuildContext,ModalRoute;


extension GetArgument on BuildContext{
// to get any type of argument on current build context
//------------------------------------------------------------------------
  T? getArgument<T>(){
    // this refers to current build context on which getArgument() is invoked.

    final modalRoute=ModalRoute.of(this);
    if(modalRoute!=null){
      // Inside a widget build method or any method that has a BuildContext parameter
      final args = ModalRoute.of(this)?.settings.arguments;
      if(args!=null && args is T){
        return args as T;
      }
    }
    return null;

  }

}