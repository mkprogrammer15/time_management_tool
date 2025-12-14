abstract class ColleagueEntity {
  final String id;
  final String name;
  final String team;
  final String? avatarUrl;
  final int? totalVacations;
  const ColleagueEntity({
    required this.id,
    required this.name,
    required this.team,
    required this.totalVacations,
    this.avatarUrl,
  });
}
