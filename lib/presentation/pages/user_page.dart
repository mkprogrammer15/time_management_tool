import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/blocs/colleague_cubit/colleague_cubit.dart';
import 'package:audavis_time_management/presentation/widgets/user_widgets/user_card.dart';
import 'package:audavis_time_management/presentation/widgets/user_widgets/user_detail_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page which represents the list of all colleagues and their details.
class UserPage extends StatefulWidget {
  const UserPage({required this.isAdmin, super.key});
  final bool isAdmin;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool showDetails = false;
  ColleagueEntity? selectedColleague;
  final TextEditingController totalVacationsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ColleaguesCubit>().startWatching();
  }

  @override
  void dispose() {
    totalVacationsController.dispose();
    super.dispose();
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
                  padding: kPadSymV8,
                  itemCount: state.colleagues.length,
                  itemBuilder: (context, index) {
                    final colleague = state.colleagues[index];
                    final isSelected = selectedColleague?.id == colleague.id;
                    return Padding(
                      padding: kPadAll12,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedColleague = colleague;
                            showDetails = true;
                          });
                        },
                        child: UserCard(
                          isSelected: isSelected,
                          colleague: colleague,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const VerticalDivider(width: 1, thickness: 1),

              // RIGHT (details)
              UserDetailContainer(
                totalVacationsController: totalVacationsController,
                isAdmin: widget.isAdmin,
                showDetails: showDetails,
                selectedColleague: selectedColleague,
              ),
            ],
          );
        },
      ),
    );
  }
}
