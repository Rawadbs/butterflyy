import 'package:butterfly/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:butterfly/blocs/habbitstate.dart';

class DetailBars extends StatelessWidget {
  final HabitLoaded state;

  const DetailBars({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final habitTypes = {
      'صحية': 0.0,
      'شخصية': 0.0,
      'دينية': 0.0,
      'مالية': 0.0,
    };

    final habitCounts = {
      'صحية': 0,
      'شخصية': 0,
      'دينية': 0,
      'مالية': 0,
    };

    // حساب عدد العادات لكل نوع
    for (var habit in state.habits) {
      final type = habit['type'] ?? 'غير محدد';
      habitCounts[type] = (habitCounts[type] ?? 0) + 1;
      if (habit['isCompleted'] ?? false) {
        habitTypes[type] =
            (habitTypes[type] ?? 0) + 100.0; // نسبة 100% لكل عادة مكتملة
      }
    }

    final totalHabits = habitCounts.values.fold(0, (sum, count) => sum + count);

    return Column(
      children: habitTypes.entries.map((entry) {
        final type = entry.key;
        final totalCompletion = entry.value;
        final typeCount = habitCounts[type] ?? 0;
        final percentage =
            totalHabits > 0 ? (totalCompletion / (typeCount * 100)) * 100 : 0;

        // تأكد من أن النسبة المئوية غير NaN
        final validPercentage = percentage.isNaN ? 0.0 : percentage;
        final validWidth = 300 * (validPercentage / 100);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: 300,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xffecf1f4), // اللون الخلفي للبار
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: validWidth,
                height: 24,
                decoration: BoxDecoration(
                  color:
                      getColorForType(type), // لون البار بناءً على نوع العادة
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${validPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
