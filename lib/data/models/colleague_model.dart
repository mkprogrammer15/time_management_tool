import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// DTO
class ColleagueModel extends ColleagueEntity {
  final String id;

  const ColleagueModel({
    required this.id,
    required super.name,
    required super.team,
    super.avatarUrl,
  });

  factory ColleagueModel.fromJson(Map<String, dynamic> json, String id) {
    return ColleagueModel(
      id: id,
      name: json['name'] as String,
      team: json['team'] as String,
      avatarUrl: json['avatarUrl'] as String?,
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
