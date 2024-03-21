// creating a cloud note there should be primary key associated with that note.
// every doc stored inside firestore has to have a primary key.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app_khirman/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote(
      {required this.documentId,
      required this.ownerUserId,
      required this.text});

  // we will create a constructor that gives us the snapshot of cloud notes
// then we are going to create an instance of our cloud note from that.
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
} // data that we will receive from cloud storage
