class ColleagueEntity {
  final String id;
  final String name;
  final String team;
  final String? avatarUrl;
  final double totalVacations;
  final double takenVacations;
  final bool active;
  final String role;

  const ColleagueEntity({
    required this.id,
    required this.name,
    required this.team,
    required this.role,
    this.avatarUrl,
    this.totalVacations = 0,
    this.takenVacations = 0,
    this.active = true,
  });

  double get restVacations =>
      (totalVacations - takenVacations).clamp(0.0, totalVacations);

  ColleagueEntity copyWith({
    String? id,
    String? name,
    String? team,
    String? role,
    String? avatarUrl,
    double? totalVacations,
    double? takenVacations,
    bool? active,
  }) {
    return ColleagueEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      team: team ?? this.team,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalVacations: totalVacations ?? this.totalVacations,
      takenVacations: takenVacations ?? this.takenVacations,
      active: active ?? this.active,
    );
  }
}
