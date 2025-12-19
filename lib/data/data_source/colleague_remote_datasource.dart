import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// CRUD operations of employee data in Firestore.
class ColleagueRemoteDataSource {
  ColleagueRemoteDataSource();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      firestore.collection('colleagues');

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAll() {
    return _col.orderBy('name').snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAll() {
    return _col.orderBy('name').get();
  }

  Future<void> create(Map<String, dynamic> data) async {
    final doc = _col.doc();
    await doc.set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> update(String id, Map<String, dynamic> patch) async {
    await _col.doc(id).update({
      ...patch,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String id) => _col.doc(id).delete();

  Future<String> uploadAvatar({
    required String colleagueId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final ref = storage
        .ref()
        .child('avatars')
        .child(colleagueId)
        .child('avatar.jpg'); // overwrite

    final lower = fileName.toLowerCase();
    final contentType = lower.endsWith('.png')
        ? 'image/png'
        : lower.endsWith('.webp')
        ? 'image/webp'
        : 'image/jpeg';

    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    final url = await ref.getDownloadURL();

    await firestore.collection('colleagues').doc(colleagueId).update({
      'avatarUrl': url,
    });

    return url;
  }
}
