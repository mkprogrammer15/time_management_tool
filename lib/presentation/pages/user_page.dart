import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/blocs/colleague_cubit/colleague_cubit.dart';
import 'package:audavis_time_management/presentation/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool showDetails = false;
  ColleagueEntity? selectedColleague;

  @override
  void initState() {
    super.initState();
    context.read<ColleaguesCubit>().startWatching();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mitarbeiter')),
      body: BlocBuilder<ColleaguesCubit, ColleaguesState>(
        builder: (context, state) {
          if (state is ColleaguesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ColleaguesError) {
            return const Center(
              child: Text('Fehler beim Laden der Mitarbeiter'),
            );
          }

          if (state is! ColleaguesLoaded) {
            return const SizedBox.shrink();
          }

          return Row(
            children: [
              // LEFT (scrollable list)
              SizedBox(
                width: size.width * 0.32,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.colleagues.length,
                  itemBuilder: (context, index) {
                    final colleague = state.colleagues[index];
                    final isSelected = selectedColleague?.id == colleague.id;

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedColleague = colleague;
                            showDetails =
                                true; // always show details after click
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade50
                                : Colors.white,
                            border: Border.all(
                              width: 1,
                              color: isSelected
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
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
                              Text(
                                'Urlaubstage gesamt: ${colleague.totalVacations}',
                              ),
                              Text(
                                'Urlaubstage genommen: ${colleague.takenVacations / 2}',
                              ),
                              Text(
                                'Urlaubstage verbleiben: ${colleague.restVacations}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // DIVIDER in the middle (full height)
              const VerticalDivider(width: 1, thickness: 1),

              // RIGHT (details)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
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

                              // Put your "all leaves + status" widget/list here
                              const Text(
                                'Details / Leaves will be shown here',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            "Bitte links einen Mitarbeiter auswählen.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
