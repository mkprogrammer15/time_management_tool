import 'package:cloud_firestore/cloud_firestore.dart';

/// CRUD operations of leave request data in Firestore.
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

  CollectionReference<Map<String, dynamic>> get _colleagues =>
      firestore.collection('colleagues');

  int _daysInclusive(DateTime s, DateTime e) {
    final start = DateTime(s.year, s.month, s.day);
    final end = DateTime(e.year, e.month, e.day);
    return end.difference(start).inDays + 1;
  }

  int _leaveUnits(Map<String, dynamic> data) {
    if (data['type'] != 'Vacation') return 0;

    final start = (data['start'] as Timestamp).toDate();
    final end = (data['end'] as Timestamp).toDate();

    final dayType = data['dayType'].toString();

    final isHalfDay =
        dayType.contains('Half Day') || // "Half Day"
        dayType.contains('halfday') || // "halfDay"
        dayType.contains('leaveDayType.halfday');

    final perDay = isHalfDay ? 1 : 2; // half=1, full=2
    return _daysInclusive(start, end) * perDay;
  }

  Future<void> create(Map<String, dynamic> data) async {
    final leaveRef = _col.doc();
    final employeeId = data['employeeId'] as String?;
    if (employeeId == null || employeeId.isEmpty) {
      throw Exception('employeeId missing in leave data');
    }
    try {
      final colleagueRef = _colleagues.doc(employeeId);
      final units = _leaveUnits(data);

      await firestore.runTransaction((tx) async {
        if (units > 0) {
          final cSnap = await tx.get(colleagueRef);
          if (!cSnap.exists) {
            throw Exception('Colleague not found: $employeeId');
          }

          final c = cSnap.data() as Map<String, dynamic>;
          final totalVac = (c['totalVacations'] as int?) ?? 0;
          final maxUnits = totalVac * 2;

          final currentTaken = (c['takenVacations'] as int?) ?? 0;
          final newTaken = (currentTaken + units).clamp(0, maxUnits);

          tx.update(colleagueRef, {
            'takenVacations': newTaken,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        tx.set(leaveRef, {
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on Exception catch (e) {}
  }

  Future<void> updateLeave(String leaveId, Map<String, dynamic> patch) async {
    final leaveRef = _col.doc(leaveId);

    await firestore.runTransaction((tx) async {
      final oldSnap = await tx.get(leaveRef);
      if (!oldSnap.exists) throw Exception('Leave not found: $leaveId');

      final old = oldSnap.data() as Map<String, dynamic>;

      final oldEmployeeId = old['employeeId'] as String;
      final newEmployeeId = (patch['employeeId'] as String?) ?? oldEmployeeId;

      final oldUnits = _leaveUnits(old);
      final newUnits = _leaveUnits({...old, ...patch});

      Future<void> applyDelta(String colleagueId, int delta) async {
        if (delta == 0) return;

        final colleagueRef = _colleagues.doc(colleagueId);
        final cSnap = await tx.get(colleagueRef);
        if (!cSnap.exists) throw Exception('Colleague not found: $colleagueId');

        final c = cSnap.data() as Map<String, dynamic>;
        final totalVac = (c['totalVacations'] as int?) ?? 0; // days
        final maxUnits = totalVac * 2;

        final currentTaken = (c['takenVacations'] as int?) ?? 0; // units
        final nextTaken = (currentTaken + delta).clamp(0, maxUnits);

        tx.update(colleagueRef, {
          'takenVacations': nextTaken,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      if (oldEmployeeId == newEmployeeId) {
        await applyDelta(oldEmployeeId, newUnits - oldUnits);
      } else {
        await applyDelta(oldEmployeeId, -oldUnits);
        await applyDelta(newEmployeeId, newUnits);
      }

      tx.update(leaveRef, {
        ...patch,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> delete(String leaveId) async {
    final leaveRef = _col.doc(leaveId);

    await firestore.runTransaction((tx) async {
      final lSnap = await tx.get(leaveRef);
      if (!lSnap.exists) return;

      final l = lSnap.data() as Map<String, dynamic>;

      final employeeId = l['employeeId'] as String?;
      if (employeeId == null || employeeId.isEmpty) {
        tx.delete(leaveRef);
        return;
      }

      final units = _leaveUnits(l);

      if (units > 0) {
        final colleagueRef = _colleagues.doc(employeeId);

        final cSnap = await tx.get(colleagueRef);
        if (!cSnap.exists) throw Exception('Colleague not found: $employeeId');

        final c = cSnap.data() as Map<String, dynamic>;
        final totalVac = (c['totalVacations'] as int?) ?? 0;
        final maxUnits = totalVac * 2;

        final currentTaken = (c['takenVacations'] as int?) ?? 0;
        final newTaken = (currentTaken - units).clamp(0, maxUnits);

        tx.update(colleagueRef, {
          'takenVacations': newTaken,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      tx.delete(leaveRef);
    });
  }
}
