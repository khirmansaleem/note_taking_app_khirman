import 'package:flutter/material.dart';

//=======================================================================
// we are making it generic because we want to make it return different
// types of dialog.
//======================================================================
// based on what you provide to it, return values to you.
//______________________________________________________________________
// generic dialog return optional because, user may click somewhere
// out of the dialog and dismiss the dialog.
//--------------------------------------------------------------------

// A type definition that represents a function returning a map.
// The map's keys are strings (titles of dialog options), and the values are of a generic type `T`, which may be nullable.
typedef DialogOptionBuilder<T> = Map<String, T?> Function();
// A generic asynchronous function to show a dialog.
// It can return a value of type T, which represents the result of the dialog.
Future<T?> showGenericDialog<T>({
  // The BuildContext is required to show the dialog within the widget tree.
  required BuildContext context,
  // 'text' is declared as a required parameter but is not used in the function.
  required String text,
  // The title of the dialog, displayed at the top of the AlertDialog.
  required String title,
  // The main content text of the dialog.
  required String content,
  // A function that builds the dialog options. It returns a Map where each entry represents a button in the dialog.
  required DialogOptionBuilder optionBuilder
}) {
  // Calls the optionBuilder function to get a Map of dialog options.
  final options = optionBuilder();
  // Displays a dialog and waits for it to close, returning the result of type T.
  return showDialog<T>(
    context: context,
    builder: (context) {
      // The actual dialog widget, AlertDialog, which is part of Flutter's material components.
      return AlertDialog(
        title: Text(title), // Sets the title of the dialog.
        content: Text(content), // Sets the main content text of the dialog.
        // Generates a list of TextButton widgets based on the entries in the 'options' Map.
        actions: options.keys.map((optionTitle) {
          // Retrieves the value associated with the key 'optionTitle' from the map. This is the value that will be returned when the button is pressed.
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                // If the value is not null, pop the dialog and return the value.
                Navigator.of(context).pop(value);
              } else {
                // If the value is null, just close the dialog without returning anything specific.
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle), // Sets the text of the button.
          );
        }).toList(), // Converts the iterable to a list since 'actions' expects a list.
      );
    },
  );
}
