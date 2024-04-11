import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_note.dart';
import 'package:note_taking_app_khirman/services/crud/notes_services.dart';
import 'package:note_taking_app_khirman/utilities/deltaJsonToString/textspan.dart';
import '../../utilities/dailog/delete_dialog.dart';

// this will be called when user press 'yes' on delete err dialog.
// this can be used for both deleting and updating note
typedef NoteCallback= void Function(CloudNote note);


class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onTap;
  final NoteCallback onDeleteNote; // becoz on delete logic will
  // be handled in the parent notesview.
  const NotesListView({super.key, required this.notes,
    required this.onDeleteNote, required this.onTap});

// this view should not have any direct connection with note service,
// this should be done through notesView , not leaking information to
// this view directly.
  // this view just display list and delete dialog
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Card(
          color: Color(0xFF404040),// Wrap the ListTile in a Card
          elevation: 2.0, // Optional: adds a shadow
          margin: const EdgeInsets.all(12.0), // Add some space around each card
          child: ListTile(
            title: LimitedBox(
              maxWidth: double.infinity,
              child: RichText(
                text: parseDeltaJsonToTextSpan(note.text),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                // this will return true/false
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete,
                color: Colors.white,),
            ),
            onTap: () {
              onTap(note);
            },
          ),
        );
      },
    );
  }
}
