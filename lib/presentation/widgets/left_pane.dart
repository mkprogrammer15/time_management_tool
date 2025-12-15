import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:flutter/material.dart';

class ColleagueListTile extends StatelessWidget {
  final ColleagueEntity colleague;
  final bool selected;
  final VoidCallback onTap;

  const ColleagueListTile({
    super.key,
    required this.colleague,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected
            ? Theme.of(context).colorScheme.primaryContainer.withAlpha(25)
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: colleague.avatarUrl != null
                  ? NetworkImage(colleague.avatarUrl!)
                  : null,
              child: colleague.avatarUrl == null
                  ? Text(
                      _initials(colleague.name),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        colleague.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' Gesamt: ${colleague.totalVacations}/ Verbleiben: ${colleague.restVacations}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    colleague.team,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return "?";
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts[0].characters.first + parts[1].characters.first)
        .toUpperCase();
  }
}
