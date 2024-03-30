import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10.0),
        Text(text),
      ],
    ),
    actions: <Widget>[
      TextButton(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop(); // Dismiss the dialog
        },
      ),
    ],
  );
  showDialog(
    context: context,
    // means on clicking out of dialog it will not disappear, it will disappear on completing loading
    barrierDismissible: false,
    builder: (context) => dialog,
  );
  return () => Navigator.of(context).pop();
}
