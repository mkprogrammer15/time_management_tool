class HolidayModel {
  final String id;
  final DateTime date;
  final String title;
  final bool isCompanyHoliday;
  final String? locationId;

  const HolidayModel({
    required this.id,
    required this.date,
    required this.title,
    this.isCompanyHoliday = true,
    this.locationId,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json, String id) {
    final ts = json['date'];
    final date = (ts is DateTime) ? ts : (ts as dynamic).toDate() as DateTime;

    return HolidayModel(
      id: id,
      date: DateTime(date.year, date.month, date.day),
      title: (json['title'] ?? '') as String,
      isCompanyHoliday: (json['isCompanyHoliday'] ?? true) as bool,
      locationId: json['locationId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': DateTime(date.year, date.month, date.day),
    'title': title,
    'isCompanyHoliday': isCompanyHoliday,
    'locationId': locationId,
  };
}
