import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// DTO
class ColleagueDto extends ColleagueEntity {
  const ColleagueDto({
    required super.id,
    required super.name,
    required super.team,
    super.avatarUrl,
    super.totalVacations,
    super.active,
  });

  factory ColleagueDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};

    return ColleagueDto(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      team: (data['team'] as String?) ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      totalVacations: (data['totalVacations'] as num?)?.toInt(),
      active: data['active'] as bool?,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'team': team,
    'avatarUrl': avatarUrl,
    'totalVacations': totalVacations,
    'active': active,
  };

  static ColleagueDto fromEntity(ColleagueEntity e) => ColleagueDto(
    id: e.id,
    name: e.name,
    team: e.team,
    avatarUrl: e.avatarUrl,
    totalVacations: e.totalVacations,
    active: e.active,
  );
}
