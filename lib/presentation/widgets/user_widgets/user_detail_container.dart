import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/widgets/colleague_leaves_widget.dart';
import 'package:flutter/material.dart';

class UserDetailContainer extends StatelessWidget {
  const UserDetailContainer({
    super.key,
    required this.showDetails,
    required this.selectedColleague,
  });

  final bool showDetails;
  final ColleagueEntity? selectedColleague;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: kPadAll16,
        child: showDetails && selectedColleague != null
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedColleague!.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Rolle: ${selectedColleague!.role}'),
                    Text('Team: ${selectedColleague!.team}'),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),

                    ColleagueLeavesWidget(colleagueId: selectedColleague!.id),
                  ],
                ),
              )
            : Center(
                child: Text(
                  "Bitte links einen Mitarbeiter auswählen.",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ),
      ),
    );
  }
}
