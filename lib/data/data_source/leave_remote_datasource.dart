import 'package:audavis_time_management/domain/entities/leave_entry_entity.dart';
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

  double _roundToHalf(double v) => (v * 2).round() / 2.0;

  Future<void> _applyTakenVacationsDeltaDays({
    required Transaction tx,
    required String colleagueId,
    required double deltaDays,
  }) async {
    if (deltaDays == 0) return;

    final colleagueRef = _colleagues.doc(colleagueId);
    final cSnap = await tx.get(colleagueRef);
    if (!cSnap.exists) throw Exception('Colleague not found: $colleagueId');

    final c = cSnap.data() as Map<String, dynamic>;

    final double totalVacDays =
        (c['totalVacations'] as num?)?.toDouble() ?? 0.0;
    final double currentTakenDays =
        (c['takenVacations'] as num?)?.toDouble() ?? 0.0;

    final double nextTakenDays = _roundToHalf(
      currentTakenDays + deltaDays,
    ).clamp(0.0, totalVacDays);

    tx.update(colleagueRef, {
      'takenVacations': nextTakenDays,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  double _leaveDays(Map<String, dynamic> data) {
    if (data['type']?.toString() != 'Vacation') return 0.0;

    final start = (data['start'] as Timestamp).toDate();
    final end = (data['end'] as Timestamp).toDate();

    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    final int daysInclusive = e.difference(s).inDays + 1;

    final dayTypeStr = (data['dayType'] ?? '').toString().toLowerCase();
    final isHalfDay = dayTypeStr.contains('half');

    final double perDay = isHalfDay ? 0.5 : 1.0;
    return daysInclusive * perDay;
  }

  Future<void> create(Map<String, dynamic> data) async {
    final leaveRef = _col.doc();
    final employeeId = data['employeeId'] as String?;
    if (employeeId == null || employeeId.isEmpty) {
      throw Exception('employeeId missing in leave data');
    }

    try {
      final deltaDays = _leaveDays(data);

      await firestore.runTransaction((tx) async {
        if (deltaDays > 0) {
          await _applyTakenVacationsDeltaDays(
            tx: tx,
            colleagueId: employeeId,
            deltaDays: deltaDays,
          );
        }

        tx.set(leaveRef, {
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on Exception catch (e) {
      // handle/log if you want
    }
  }

  Future<void> updateLeave(String leaveId, Map<String, dynamic> patch) async {
    final leaveRef = _col.doc(leaveId);

    await firestore.runTransaction((tx) async {
      final oldSnap = await tx.get(leaveRef);
      if (!oldSnap.exists) throw Exception('Leave not found: $leaveId');

      final old = oldSnap.data() as Map<String, dynamic>;

      final oldEmployeeId = old['employeeId'] as String;
      final newEmployeeId = (patch['employeeId'] as String?) ?? oldEmployeeId;

      final oldDays = _leaveDays(old);
      final newDays = _leaveDays({...old, ...patch});

      if (oldEmployeeId == newEmployeeId) {
        final delta = newDays - oldDays;
        await _applyTakenVacationsDeltaDays(
          tx: tx,
          colleagueId: oldEmployeeId,
          deltaDays: delta,
        );
      } else {
        // remove from old colleague
        await _applyTakenVacationsDeltaDays(
          tx: tx,
          colleagueId: oldEmployeeId,
          deltaDays: -oldDays,
        );
        // add to new colleague
        await _applyTakenVacationsDeltaDays(
          tx: tx,
          colleagueId: newEmployeeId,
          deltaDays: newDays,
        );
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

      final deltaDays = _leaveDays(l);

      if (deltaDays > 0) {
        await _applyTakenVacationsDeltaDays(
          tx: tx,
          colleagueId: employeeId,
          deltaDays: -deltaDays,
        );
      }

      tx.delete(leaveRef);
    });
  }
}
