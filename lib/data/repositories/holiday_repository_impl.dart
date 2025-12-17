import 'package:audavis_time_management/data/data_source/holiday_remote_datasource.dart';
import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/domain/repositories/holiday_repository.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  final HolidayRemoteDataSource holidayRemoteDataSource;

  HolidayRepositoryImpl({required this.holidayRemoteDataSource});

  DateTime _monthStart(DateTime d) => DateTime(d.year, d.month, 1);
  DateTime _monthEnd(DateTime d) => DateTime(d.year, d.month + 1, 0);

  @override
  Stream<List<HolidayModel>> watchMonth(DateTime anyDayInMonth) {
    return holidayRemoteDataSource.watchHolidaysInRange(
      fromInclusive: _monthStart(anyDayInMonth),
      toInclusive: _monthEnd(anyDayInMonth),
    );
  }

  @override
  Future<List<HolidayModel>> loadMonth(DateTime anyDayInMonth) {
    return holidayRemoteDataSource.getHolidaysInRange(
      fromInclusive: _monthStart(anyDayInMonth),
      toInclusive: _monthEnd(anyDayInMonth),
    );
  }

  @override
  Future<String> create(HolidayModel holiday) =>
      holidayRemoteDataSource.createHoliday(holiday);

  @override
  Future<void> update(HolidayModel holiday) =>
      holidayRemoteDataSource.updateHoliday(holiday);

  @override
  Future<void> remove(String id) => holidayRemoteDataSource.deleteHoliday(id);

  @override
  Future<List<HolidayModel>> loadAll() async {
    final holidayList = await holidayRemoteDataSource.loadAll();
    return holidayList;
  }

  @override
  Stream<List<HolidayModel>> watchAll() {
    return holidayRemoteDataSource.watchAll();
  }
}
