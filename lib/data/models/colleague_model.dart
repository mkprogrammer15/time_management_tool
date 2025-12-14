import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// DTO
class ColleagueModel extends ColleagueEntity {
  const ColleagueModel({
    required super.id,
    required super.name,
    required super.team,
    required super.totalVacations,
    super.avatarUrl,
  });

  factory ColleagueModel.fromJson(Map<String, dynamic> json, String id) {
    return ColleagueModel(
      id: json['id'] as String,
      name: json['name'] as String,
      team: json['team'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalVacations: json['totalVacations'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'team': team, 'avatarUrl': avatarUrl};
  }

  factory ColleagueModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ColleagueModel.fromJson(data, doc.id);
  }
}
