class ColleagueEntity {
  final String id;
  final String name;
  final String team;
  final String? avatarUrl;
  final int totalVacations;
  final int takenVacations;
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

  int get restVacationUnits =>
      (totalVacations * 2 - takenVacations).clamp(0, totalVacations * 2);
  double get restVacations => restVacationUnits / 2.0;

  ColleagueEntity copyWith({
    String? id,
    String? name,
    String? team,
    String? role,
    String? avatarUrl,
    int? totalVacations,
    int? takenVacations,
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
