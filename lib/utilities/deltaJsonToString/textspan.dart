import 'dart:convert';
import 'package:flutter/material.dart';

TextSpan parseDeltaJsonToTextSpan(String? deltaJson) {
  // Check if the input string is null or empty
  if (deltaJson == null || deltaJson.isEmpty) {
    return TextSpan(text: ''); // or return an empty TextSpan()
  }

  try {
    final dynamic decodedJson = jsonDecode(deltaJson);
    List<TextSpan> spans = [];

    // Assuming decodedJson directly contains a list of operations
    if (decodedJson is List) {
      for (var op in decodedJson) {
        if (op is Map<String, dynamic>) {
          final text = op['insert'];
          if (text is String) {
            final attributes = op['attributes'] as Map<String, dynamic>?;
            TextStyle style = TextStyle(color: Colors.white);

            if (attributes != null) {
              if (attributes['bold'] == true) {
                style = style.copyWith(fontWeight: FontWeight.bold);
              }
              if (attributes['italic'] == true) {
                style = style.copyWith(fontStyle: FontStyle.italic);
              }
              // Handle other styles as needed
            }

            spans.add(TextSpan(text: text, style: style));
          }
        }
      }
      return TextSpan(children: spans);
    } else {
      return TextSpan(text: 'Unexpected JSON Format');
    }
  } catch (e) {
    // Handle JSON decoding error
    print('Error parsing JSON to TextSpan: $e');
    return TextSpan(text: 'Error loading content');
  }
}
