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
  @override
  void initState() {
    super.initState();
    context.read<ColleaguesCubit>().startWatching();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text('Mitarbeiter')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ColleaguesCubit, ColleaguesState>(
              builder: (context, state) {
                if (state is ColleaguesLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ColleaguesLoaded) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.colleagues.length,
                          itemBuilder: (context, index) {
                            final colleague = state.colleagues[index];

                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: CustomAvatar(
                                              imageUrl: colleague.avatarUrl,
                                              name: colleague.name,
                                            ),
                                          ),
                                          Text(
                                            colleague.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text('Rolle: ${colleague.role}'),
                                      Text('Team ${colleague.team}'),
                                      Text(
                                        'Urlaubstage gesamt: ${colleague.totalVacations.toString()}',
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
                    ],
                  );
                } else if (state is ColleaguesError) {
                  return Center(
                    child: Text('Fehler beim Laden der Mitarbeiter'),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
