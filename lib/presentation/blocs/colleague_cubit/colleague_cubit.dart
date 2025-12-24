import 'dart:async';

import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/domain/repositories/colleague_repository.dart';
import 'package:bloc/bloc.dart';

part 'colleague_state.dart';

/// BLOC for managing colleagues data
class ColleaguesCubit extends Cubit<ColleaguesState> {
  ColleaguesCubit({required this.colleagueRepository})
    : super(ColleaguesInitial());

  final ColleagueRepository colleagueRepository;
  StreamSubscription? _sub;

  void startWatching() {
    emit(ColleaguesLoading());
    _sub?.cancel();
    _sub = colleagueRepository.watchAll().listen(
      (list) => emit(ColleaguesLoaded(colleagues: list)),
      onError: (e) => emit(ColleaguesError(e.toString())),
    );
  }

  Future<void> updateColleague(ColleagueEntity colleague) async {
    try {
      await colleagueRepository.update(colleague);
    } catch (e) {
      emit(ColleaguesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
