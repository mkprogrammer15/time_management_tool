import 'package:audavis_time_management/domain/entities/holiday_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Holiday DTO
class HolidayModel extends HolidayEntity {
  const HolidayModel({
    required super.id,
    required super.date,
    required super.title,
    required super.locationId,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json, String id) {
    final rawDate = json['date'];

    final DateTime parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else {
      throw StateError('Invalid date type for HolidayModel');
    }

    return HolidayModel(
      id: id,
      date: DateTime(parsedDate.year, parsedDate.month, parsedDate.day),
      title: (json['title'] as String?) ?? '',
      locationId: json['locationId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final dateOnly = DateTime(date.year, date.month, date.day);

    return {
      'date': Timestamp.fromDate(dateOnly),
      'title': title,
      'locationId': locationId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  HolidayModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    bool? isCompanyHoliday,
    String? locationId,
  }) {
    return HolidayModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      locationId: locationId ?? this.locationId,
    );
  }
}
