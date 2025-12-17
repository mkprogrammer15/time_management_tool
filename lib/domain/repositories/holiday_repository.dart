import 'package:audavis_time_management/data/models/holiday_model.dart';

abstract class HolidayRepository {
  Stream<List<HolidayModel>> watchMonth(DateTime anyDayInMonth);
  Future<List<HolidayModel>> loadMonth(DateTime anyDayInMonth);

  Future<String> create(HolidayModel holiday);
  Future<void> update(HolidayModel holiday);
  Future<void> remove(String id);
}
