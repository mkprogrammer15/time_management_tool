import 'package:audavis_time_management/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SeedColorPicker extends StatelessWidget {
  const SeedColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = <Color>[
      Colors.deepPurple,
      Colors.indigo,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.pink,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final c in colors)
          InkWell(
            onTap: () {
              context.read<ThemeCubit>().setSeedColor(c);
              Navigator.of(context).pop();
            },
            child: CircleAvatar(backgroundColor: c, radius: 18),
          ),
      ],
    );
  }
}
