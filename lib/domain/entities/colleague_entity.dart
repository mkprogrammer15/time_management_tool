class ColleagueEntity {
  final String id;
  final String name;
  final String team;
  final String? avatarUrl;
  final int totalVacations;
  final int takenVacations;
  final bool active;

  const ColleagueEntity({
    required this.id,
    required this.name,
    required this.team,
    this.avatarUrl,
    this.totalVacations = 0,
    this.takenVacations = 0,
    this.active = true,
  });

  int get restVacationUnits =>
      (totalVacations * 2 - takenVacations).clamp(0, totalVacations * 2);
  double get restVacations => restVacationUnits / 2.0;
}
