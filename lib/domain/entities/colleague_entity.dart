abstract class ColleagueEntity {
  final String name;
  final String team;
  final String? avatarUrl;
  const ColleagueEntity({
    required this.name,
    required this.team,
    this.avatarUrl,
  });
}
