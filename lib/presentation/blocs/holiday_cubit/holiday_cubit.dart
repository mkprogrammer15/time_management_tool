import 'dart:async';
import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/domain/repositories/holiday_repository.dart';
import 'package:bloc/bloc.dart';

part 'holiday_state.dart';

/// Bloc for managing holidays
class HolidayCubit extends Cubit<HolidayState> {
  final HolidayRepository holidayRepository;
  StreamSubscription<List<HolidayModel>>? _sub;

  HolidayCubit({required this.holidayRepository})
    : super(const HolidayLoading());

  void watchAll() {
    emit(const HolidayLoading());
    _sub?.cancel();

    _sub = holidayRepository.watchAll().listen(
      (holidays) => emit(HolidayLoaded(holidays)),
      onError: (e, st) => emit(HolidayError(e, st)),
    );
  }

  /// Einmalig laden: alle Feiertage
  Future<void> loadAll() async {
    emit(const HolidayLoading());
    try {
      final holidays = await holidayRepository.loadAll();
      emit(HolidayLoaded(holidays));
    } catch (e, st) {
      emit(HolidayError(e, st));
    }
  }

  /// Live-Updates: Monat beobachten
  void watchMonth(DateTime anyDayInMonth) {
    emit(const HolidayLoading());
    _sub?.cancel();

    _sub = holidayRepository
        .watchMonth(anyDayInMonth)
        .listen(
          (holidays) => emit(HolidayLoaded(holidays)),
          onError: (e, st) => emit(HolidayError(e, st)),
        );
  }

  /// Einmalig laden: Monat
  Future<void> loadMonth(DateTime anyDayInMonth) async {
    emit(const HolidayLoading());
    try {
      final holidays = await holidayRepository.loadMonth(anyDayInMonth);
      emit(HolidayLoaded(holidays));
    } catch (e, st) {
      emit(HolidayError(e, st));
    }
  }

  /// CRUD
  Future<String?> create(HolidayModel holiday) async {
    try {
      return await holidayRepository.create(holiday);
      // wenn watchMonth aktiv ist, kommt Update automatisch rein
    } catch (e, st) {
      emit(HolidayError(e, st));
      return null;
    }
  }

  Future<void> update(HolidayModel holiday) async {
    try {
      await holidayRepository.update(holiday);
    } catch (e, st) {
      emit(HolidayError(e, st));
    }
  }

  Future<void> remove(String id) async {
    try {
      await holidayRepository.remove(id);
    } catch (e, st) {
      emit(HolidayError(e, st));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
