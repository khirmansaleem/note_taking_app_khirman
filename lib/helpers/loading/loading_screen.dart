import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/helpers/loading/loading_screen_controller.dart';

  class LoadingScreen{

  factory LoadingScreen()=>_shared;
  static final LoadingScreen _shared=LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  LoadingScreenController? controller;


  void hide(){
    controller?.close(); // if there is controller available on screen close that.
    controller=null;
  }
  void show({required BuildContext context, required String text}){
    if(controller?.update(text) ?? false){
      return;
    }
    else{
      controller=showOverlay(context: context, text: text);
    }

  }

  // showOverlay function in turns returns the instance of loading screen controller.
   LoadingScreenController showOverlay(
   {  required BuildContext context,
    required String text,
   }){
     // create stream controller and add text to t
     final _text=StreamController<String>();
     _text.add(text);
     // get the state of nearest overlay widget up the widget tree from given context.
     final state= Overlay.of(context);

     // we need some size to base our overlay on top of it.
     final renderBox=context.findRenderObject() as RenderBox;
     final size=renderBox.size;
     final overlay= OverlayEntry(builder: (context){
       // material for styling your widgets.
       return Material( // covers entire screen
         color:Colors.black.withAlpha(150),
         child: Center(child:Container(
           constraints: BoxConstraints(
             maxWidth: size.width*0.8 // this dialog takes, 80% of the screen
             , maxHeight: size.height*0.8,
             minWidth: size.width*0.5,

           ),
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(10),

           ),
           child: Padding(
               padding:  EdgeInsets.all(16.0),
               child:  SingleChildScrollView( // only scrolls if content overflow container
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const SizedBox(height: 10),
                     const CircularProgressIndicator(),
                     const SizedBox(height: 10),
                     StreamBuilder(stream: _text.stream,
                         builder: (context,snapshot){
                           if(snapshot.hasData){
                             return Text(
                               snapshot.data as String,
                               textAlign: TextAlign.center,
                             );
                           }
                           else{
                             return Container();
                           }



                         },
                     ),
                   ],


                 ),
               ),

           ),
         )
         ),


       );


     });

     state.insert(overlay);
     
     return LoadingScreenController(close:(){
       _text.close();
       overlay.remove();
       return true;
       }, update: (text){
       _text.add(text);
       return true;

     });

   }
}