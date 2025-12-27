import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/widgets/colleague_widgets/colleague_leaves_widget.dart';
import 'package:flutter/material.dart';

class UserDetailContainer extends StatelessWidget {
  const UserDetailContainer({
    super.key,
    required this.totalVacationsController,
    required this.showDetails,
    required this.selectedColleague,
    required this.isAdmin,
    required this.onSaveVacationsPressed,
  });

  final bool showDetails;
  final ColleagueEntity? selectedColleague;
  final bool isAdmin;
  final TextEditingController totalVacationsController;
  final Future<void> Function(int totalVacations) onSaveVacationsPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: kPadAll16 + const EdgeInsets.symmetric(vertical: 4),
        child: showDetails && selectedColleague != null
            ? Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100.withAlpha(125),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: kPadAll16,
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

                        ColleagueLeavesWidget(
                          colleagueId: selectedColleague!.id,
                        ),
                      ],
                    ),
                  ),
                  if (isAdmin)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 20,
                      child: Container(
                        padding: kPadAll12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(76),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text('Anzahl Urlaubstage ändern'),
                            SizedBox(width: 12),
                            SizedBox(
                              width: 140,
                              child: TextField(
                                controller: totalVacationsController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  hintText: 'Urlaubstage',
                                  isDense: true,
                                ),
                              ),
                            ),
                            Expanded(child: const SizedBox(width: 12)),
                            ElevatedButton(
                              onPressed: () {
                                final text = totalVacationsController.text
                                    .trim();
                                final value = int.tryParse(text) ?? 0;
                                onSaveVacationsPressed(value);
                              },

                              child: const Text('Speichern'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
