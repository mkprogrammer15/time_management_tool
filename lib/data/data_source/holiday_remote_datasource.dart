import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HolidayRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection("holidays");

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  HolidayModel _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    final rawDate = data['date'];
    final date = rawDate is Timestamp
        ? rawDate.toDate()
        : (rawDate as DateTime);

    return HolidayModel(
      id: doc.id,
      date: _dateOnly(date),
      title: (data['title'] as String?) ?? '',
      locationId: data['locationId'] as String?,
    );
  }

  Stream<List<HolidayModel>> watchAll() {
    return _col
        .orderBy('date')
        .snapshots()
        .map((s) => s.docs.map(_fromDoc).toList());
  }

  Future<List<HolidayModel>> loadAll() async {
    final snap = await _col.orderBy('date').get();
    return snap.docs.map(_fromDoc).toList();
  }

  Stream<List<HolidayModel>> watchHolidaysInRange({
    required DateTime fromInclusive,
    required DateTime toInclusive,
  }) {
    final from = Timestamp.fromDate(_dateOnly(fromInclusive));
    final to = Timestamp.fromDate(_dateOnly(toInclusive));

    return _col
        .where("date", isGreaterThanOrEqualTo: from)
        .where("date", isLessThanOrEqualTo: to)
        .orderBy("date")
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => HolidayModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<List<HolidayModel>> getHolidaysInRange({
    required DateTime fromInclusive,
    required DateTime toInclusive,
  }) async {
    final from = Timestamp.fromDate(_dateOnly(fromInclusive));
    final to = Timestamp.fromDate(_dateOnly(toInclusive));

    final snap = await _col
        .where("date", isGreaterThanOrEqualTo: from)
        .where("date", isLessThanOrEqualTo: to)
        .orderBy("date")
        .get();

    return snap.docs
        .map((doc) => HolidayModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<String> createHoliday(HolidayModel holiday) async {
    final doc = await _col.add(holiday.toJson());
    return doc.id;
  }

  Future<void> updateHoliday(HolidayModel holiday) {
    return _col.doc(holiday.id).update(holiday.toJson());
  }

  Future<void> deleteHoliday(String id) {
    return _col.doc(id).delete();
  }
}
