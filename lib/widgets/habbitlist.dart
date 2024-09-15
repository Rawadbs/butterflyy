import 'package:butterfly/blocs/habbitbloc.dart';
import 'package:butterfly/blocs/habbitevent.dart';
import 'package:butterfly/blocs/habbitstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HabitListTile extends StatelessWidget {
  final int index;
  final String name;
  final String type;
  final Color color;
  final bool isCompleted;

  const HabitListTile({
    super.key,
    required this.index,
    required this.name,
    required this.type,
    required this.color,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state is HabitLoaded) {
          final habit = state.habits[index];
          final backgroundColor =
              habit['isCompleted'] ? color : Colors.transparent;
          final borderColor = habit['isCompleted'] ? color : color;

          return ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: backgroundColor,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 2),
                  ),
                ),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              context.read<HabitBloc>().add(
                    UpdateHabitCompletionEvent(
                      index: index,
                      isCompleted: !isCompleted,
                    ),
                  );
            },
            onLongPress: () {
              context.read<HabitBloc>().add(
                    UpdateHabitCompletionEvent(
                      index: index,
                      isCompleted: !isCompleted,
                    ),
                  );
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
