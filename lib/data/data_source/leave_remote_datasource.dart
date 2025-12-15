import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRemoteDataSource {
  LeaveRemoteDataSource();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      firestore.collection('leaveRequests');

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAll() {
    return _col.orderBy('start', descending: true).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAll() {
    return _col.orderBy('start', descending: true).get();
  }

  Future<void> create(Map<String, dynamic> data) async {
    final doc = _col.doc();
    await doc.set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStatus(String leaveId, Map<String, dynamic> patch) async {
    await _col.doc(leaveId).update({
      ...patch,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String leaveId) async {
    await _col.doc(leaveId).delete();
  }
}
