import 'dart:typed_data';

import 'package:audavis_time_management/data/data_source/colleague_remote_datasource.dart';
import 'package:audavis_time_management/data/models/colleague_model.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/domain/repositories/colleague_repository.dart';

class ColleagueRepositoryImpl implements ColleagueRepository {
  ColleagueRepositoryImpl({required this.colleagueRemoteDataSource});

  final ColleagueRemoteDataSource colleagueRemoteDataSource;

  @override
  Stream<List<ColleagueEntity>> watchAll() {
    return colleagueRemoteDataSource.watchAll().map(
      (snap) => snap.docs.map(ColleagueDto.fromDoc).toList(),
    );
  }

  @override
  Future<List<ColleagueEntity>> fetchAll() async {
    final snap = await colleagueRemoteDataSource.fetchAll();
    return snap.docs.map(ColleagueDto.fromDoc).toList();
  }

  @override
  Future<void> create(ColleagueEntity colleague) {
    final dto = ColleagueDto.fromEntity(colleague);
    return colleagueRemoteDataSource.create(dto.toFirestore());
  }

  @override
  Future<void> update(ColleagueEntity colleague) {
    final dto = ColleagueDto.fromEntity(colleague);
    return colleagueRemoteDataSource.update(dto.id, dto.toFirestore());
  }

  @override
  Future<void> delete(String id) => colleagueRemoteDataSource.delete(id);

  @override
  Future<String> uploadAvatar({
    required String colleagueId,
    required Uint8List bytes,
    required String fileName,
  }) {
    return colleagueRemoteDataSource.uploadAvatar(
      colleagueId: colleagueId,
      bytes: bytes,
      fileName: fileName,
    );
  }
}
