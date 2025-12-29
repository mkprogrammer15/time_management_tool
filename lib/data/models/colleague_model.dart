import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// DTO
class ColleagueDto extends ColleagueEntity {
  const ColleagueDto({
    required super.id,
    required super.name,
    required super.team,
    required super.role,
    super.avatarUrl,
    super.totalVacations,
    super.takenVacations,
    super.active,
  });

  factory ColleagueDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};

    return ColleagueDto(
      role: data['role'] as String? ?? 'employee',
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      team: (data['team'] as String?) ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      totalVacations: (data['totalVacations'] as num?)?.toDouble() ?? 0,
      takenVacations: (data['takenVacations'] as num?)?.toDouble() ?? 0,
      active: (data['active'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'team': team,
    'avatarUrl': avatarUrl,
    'totalVacations': totalVacations,
    'takenVacations': takenVacations,
    'active': active,
    'role': role,
  };

  static ColleagueDto fromEntity(ColleagueEntity e) => ColleagueDto(
    role: e.role,
    id: e.id,
    name: e.name,
    team: e.team,
    avatarUrl: e.avatarUrl,
    totalVacations: e.totalVacations,
    takenVacations: e.takenVacations,
    active: e.active,
  );
}
