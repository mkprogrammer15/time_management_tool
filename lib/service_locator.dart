import 'package:audavis_time_management/data/data_source/colleague_remote_datasource.dart';
import 'package:audavis_time_management/data/data_source/holiday_remote_datasource.dart';
import 'package:audavis_time_management/data/data_source/leave_remote_datasource.dart';
import 'package:audavis_time_management/data/repositories/colleague_repository_impl.dart';
import 'package:audavis_time_management/data/repositories/holiday_repository_impl.dart';
import 'package:audavis_time_management/data/repositories/leave_repository_impl.dart';
import 'package:audavis_time_management/domain/repositories/colleague_repository.dart';
import 'package:audavis_time_management/domain/repositories/holiday_repository.dart';
import 'package:audavis_time_management/domain/repositories/leave_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.I;

Future<void> initSharedServices() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<LeaveRepository>(
      () => LeaveRepositoryImpl(leaveRemoteDataSource: sl()),
    )
    ..registerLazySingleton<ColleagueRepository>(
      () => ColleagueRepositoryImpl(colleagueRemoteDataSource: sl()),
    )
    ..registerLazySingleton<HolidayRepository>(
      () => HolidayRepositoryImpl(holidayRemoteDataSource: sl()),
    )
    ..registerLazySingleton(HolidayRemoteDataSource.new)
    ..registerLazySingleton(LeaveRemoteDataSource.new)
    ..registerLazySingleton(ColleagueRemoteDataSource.new)
    ..registerSingleton<SharedPreferences>(prefs);
}
