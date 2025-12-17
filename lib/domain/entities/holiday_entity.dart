class HolidayEntity {
  final String id;
  final DateTime date;
  final String title;
  final String? locationId;

  const HolidayEntity({
    required this.id,
    required this.date,
    required this.title,
    this.locationId,
  });
}
