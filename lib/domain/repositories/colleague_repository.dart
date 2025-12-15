import 'package:audavis_time_management/domain/entities/colleague_entity.dart';

abstract interface class ColleagueRepository {
  Stream<List<ColleagueEntity>> watchAll();
  Future<List<ColleagueEntity>> fetchAll();

  Future<void> create(ColleagueEntity colleague);
  Future<void> update(ColleagueEntity colleague);
  Future<void> delete(String id);
}
