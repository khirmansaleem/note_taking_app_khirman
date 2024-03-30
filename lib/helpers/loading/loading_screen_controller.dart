
// two abilities we need, close the loading screen and update it's content.

// two typedef of functions, one for closeLoadingScreen and other for updateLoading
// screen.
import 'package:flutter/material.dart' show immutable;

typedef CloseLoadingScreen= bool Function();
typedef UpdateLoadingScreen= bool Function(String text);

@immutable
class LoadingScreenController{
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({required this.close, required this.update});
}