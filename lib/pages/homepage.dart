import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:butterfly/blocs/habbitbloc.dart';
import 'package:butterfly/blocs/habbitevent.dart';
import 'package:butterfly/blocs/habbitstate.dart';
import 'package:butterfly/widgets/form_habbit.dart';
import 'package:butterfly/widgets/habbitlist.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(left: 150),
                child: Text(
                  'اهلا ${widget.userName}, انجزت اليوم',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xffa0a2a8),
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<HabitBloc, HabitState>(
                builder: (context, state) {
                  if (state is HabitLoaded) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _showDetails
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: const Color(0xff525357),
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showDetails = !_showDetails;
                                });
                              },
                            ),
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  width: 300,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffecf1f4),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width:
                                      300 * (state.completionPercentage / 100),
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff525357),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '${state.completionPercentage.toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_showDetails) _buildDetailBars(state),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 44),
              const Padding(
                padding: EdgeInsets.only(left: 220),
                child: Text(
                  'مهام اليوم',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffa0a2a8),
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              'عادات شائعة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff525357),
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<HabitBloc, HabitState>(
                          builder: (context, state) {
                            if (state is HabitLoaded) {
                              // تصفية العادات بناءً على النوع
                              final commonHabits = state.habits.where((habit) {
                                return habit['type'] == 'شخصية' ||
                                    habit['type'] == 'دينية' ||
                                    habit['type'] == 'صحية';
                              }).toList();

                              // عرض العادات بعد التصفية
                              return Padding(
                                padding: const EdgeInsets.only(right: 35),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: commonHabits.length,
                                  itemBuilder: (context, index) {
                                    final habit = commonHabits[index];
                                    return Dismissible(
                                      key: Key(habit['name']),
                                      direction: DismissDirection.startToEnd,
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      onDismissed: (direction) {
                                        context.read<HabitBloc>().add(
                                            RemoveHabitEvent(
                                                state.habits.indexOf(habit)));
                                      },
                                      child: HabitListTile(
                                        index: state.habits.indexOf(habit),
                                        name: habit['name'] ?? '',
                                        type: habit['type'] ?? 'غير محدد',
                                        color: _getColorForType(
                                            habit['type'] ?? 'غير محدد'),
                                        isCompleted:
                                            habit['isCompleted'] ?? false,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                    BlocBuilder<HabitBloc, HabitState>(
                      builder: (context, state) {
                        if (state is HabitLoaded) {
                          final groupedHabits =
                              <String, List<Map<String, dynamic>>>{
                            'الفجر': [],
                            'الظهر': [],
                            'العصر': [],
                            'المغرب': [],
                            'العشاء': [],
                          };

                          for (var habit in state.habits) {
                            final time = habit['time'] ?? 'الفجر';
                            if (!groupedHabits.containsKey(time)) {
                              groupedHabits[time] = [];
                            }
                            groupedHabits[time]?.add(habit);
                          }

                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              children: groupedHabits.entries.map((entry) {
                                final time = entry.key;
                                final habits = entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 40),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50),
                                      child: Text(
                                        time,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff525357),
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 35),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: habits.length,
                                        itemBuilder: (context, index) {
                                          final habit = habits[index];
                                          return Dismissible(
                                            key: Key(habit['name']),
                                            direction:
                                                DismissDirection.startToEnd,
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              child: const Icon(Icons.delete,
                                                  color: Colors.white),
                                            ),
                                            onDismissed: (direction) {
                                              context.read<HabitBloc>().add(
                                                  RemoveHabitEvent(state.habits
                                                      .indexOf(habit)));
                                            },
                                            child: HabitListTile(
                                              index:
                                                  state.habits.indexOf(habit),
                                              name: habit['name'] ?? '',
                                              type: habit['type'] ?? 'غير محدد',
                                              color: _getColorForType(
                                                  habit['type'] ?? 'غير محدد'),
                                              isCompleted:
                                                  habit['isCompleted'] ?? false,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 16), // مسافة بين الحافة والزر
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddHabitDialog(
                      onAddHabit: (String name, String type, String time) {
                        context.read<HabitBloc>().add(
                            AddHabitEvent(name: name, type: type, time: time));
                      },
                    );
                  },
                );
              },
              backgroundColor: const Color(0xff525357),
              shape: const CircleBorder(
                side: BorderSide(width: 0),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16), // مسافة بين الزر وحافة الشاشة
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBars(HabitLoaded state) {
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
                      _getColorForType(type), // لون البار بناءً على نوع العادة
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

  Color _getColorForType(String type) {
    switch (type) {
      case 'صحية':
        return const Color(0xffFF8762);
      case 'شخصية':
        return const Color(0xff4B4DED);
      case 'دينية':
        return const Color(0xff986CF5);
      case 'مالية':
        return const Color(0xff31D097);
      default:
        return Colors.grey;
    }
  }
}
