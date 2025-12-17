part of 'holiday_cubit.dart';

sealed class HolidayState {
  const HolidayState();
}

class HolidayLoading extends HolidayState {
  const HolidayLoading();
}

class HolidayLoaded extends HolidayState {
  final List<HolidayModel> holidays;
  const HolidayLoaded(this.holidays);
}

class HolidayError extends HolidayState {
  final Object error;
  final StackTrace? stackTrace;
  const HolidayError(this.error, [this.stackTrace]);
}
