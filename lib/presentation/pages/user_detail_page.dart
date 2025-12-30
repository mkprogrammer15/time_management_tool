import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/widgets/colleague_widgets/colleague_leaves_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({required this.colleague, super.key});
  final ColleagueEntity colleague;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('User details'),
      ),
      body: Padding(
        padding: kPadAll16,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [ColleagueLeavesWidget(colleagueId: widget.colleague.id)],
          ),
        ),
      ),
    );
  }
}
