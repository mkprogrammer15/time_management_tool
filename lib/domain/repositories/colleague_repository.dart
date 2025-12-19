import 'dart:typed_data';

import 'package:audavis_time_management/domain/entities/colleague_entity.dart';

abstract interface class ColleagueRepository {
  Stream<List<ColleagueEntity>> watchAll();

  Future<void> create(ColleagueEntity colleague);
  Future<void> update(ColleagueEntity colleague);
  Future<void> delete(String id);
  Future<String> uploadAvatar({
    required String colleagueId,
    required Uint8List bytes,
    required String fileName,
  });
}
