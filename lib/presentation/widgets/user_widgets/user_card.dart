import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/widgets/avatar_widgets/custom_avatar.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.isSelected,
    required this.colleague,
  });

  final bool isSelected;
  final ColleagueEntity colleague;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        border: Border.all(
          width: 1,
          color: isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: kPadAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: kPadOnlyR8,
                child: CustomAvatar(
                  imageUrl: colleague.avatarUrl,
                  name: colleague.name,
                ),
              ),
              Expanded(
                child: Text(
                  colleague.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Rolle: ${colleague.role}'),
          Text('Team: ${colleague.team}'),
          Text('Urlaubstage gesamt: ${colleague.totalVacations}'),
          Text('Urlaubstage genommen: ${colleague.takenVacations / 2}'),
          Text('Urlaubstage verbleiben: ${colleague.restVacations}'),
        ],
      ),
    );
  }
}
