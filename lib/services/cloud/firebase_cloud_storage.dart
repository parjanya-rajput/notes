import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter/services/cloud/cloud_service_exceptions.dart';
import 'package:first_flutter/services/cloud/cloud_storage_constants.dart';

import 'cloud_note.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e){
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({required String documentId, required String text,}) async {
    try{
      await notes.doc(documentId).update({textFieldName:text});
    } catch(e){
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> getAllNotes({required String ownerUserId}) {
    return notes.snapshots().map((event) =>
        event.docs
            .map((doc) => CloudNote.fromSnapshot(doc))
            .where((note) => note.ownerUserId == ownerUserId));
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) =>
            value.docs.map(
                  (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
      );
    } catch (e) {
      throw CouldNotGetAllNotes;
    }
  }

  void createNote({
    required String ownerUserId,
  }) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  static final FirebaseCloudStorage _shared =
  FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
