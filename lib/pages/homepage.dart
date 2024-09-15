import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:butterfly/widgets/habbitlist.dart';
import 'package:butterfly/widgets/form_habbit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> habits = [];
  double _completionPercentage = 0;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      setState(() {
        habits = List<Map<String, dynamic>>.from(json.decode(habitsJson));
        _updateCompletionPercentage();
      });
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsJson = json.encode(habits);
    await prefs.setString('habits', habitsJson);
    print(
        "Habits Saved: $habitsJson"); // تحقق من أن البيانات تم حفظها بشكل صحيح
  }

  void _addHabit(String name, String type) {
    setState(() {
      habits.add({'name': name, 'type': type, 'isCompleted': false});
      _saveHabits();
    });
  }

  void _updateHabitCompletion(int index, bool isCompleted) {
    setState(() {
      habits[index]['isCompleted'] = isCompleted;
      _saveHabits();
      _updateCompletionPercentage();
    });
  }

  void _updateCompletionPercentage() {
    if (habits.isEmpty) {
      _completionPercentage = 0;
    } else {
      _completionPercentage =
          (habits.where((h) => h['isCompleted'] == true).length /
                  habits.length) *
              100;
    }
  }

  @override
  void dispose() {
    _saveHabits(); // تأكد من أن البيانات يتم حفظها عند إغلاق التطبيق
    super.dispose();
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

  void _showAddHabitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddHabitDialog(
          onAddHabit: (String name, String type) {
            _addHabit(name, type);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.only(left: 150),
              child: Text(
                'اهلا رواد , انجزت اليوم',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffa0a2a8),
                    fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment:
                  Alignment.centerRight, // لجعل البار الأسود يبدأ من اليمين
              children: [
                Container(
                  width: 300,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xffecf1f4),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 300 * (_completionPercentage / 100),
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xff525357),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${_completionPercentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'Cairo'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),
            const Padding(
              padding: EdgeInsets.only(left: 220),
              child: Text(
                'مهام اليوم',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffa0a2a8),
                    fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return Dismissible(
                        key: Key(habit['name']), // يجب أن يكون المفتاح فريدًا
                        direction: DismissDirection
                            .startToEnd, // السحب من اليمين إلى اليسار
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            habits.removeAt(index);
                            _saveHabits(); // تأكد من استدعاء هذه الدالة بعد الحذف

                            // إعادة حساب النسبة المئوية بعد حذف العادة
                            _updateCompletionPercentage();
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${habit['name']} تم حذفها')),
                          );
                        },
                        child: HabitListTile(
                          name: habit['name'] ?? '',
                          type: habit['type'] ?? 'غير محدد',
                          color: _getColorForType(habit['type'] ?? 'غير محدد'),
                          isCompleted: habit['isCompleted'] ?? false,
                          onTap: () => _updateHabitCompletion(
                              index, !(habit['isCompleted'] ?? false)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: Colors.black,
        shape: const CircleBorder(side: BorderSide(width: 20)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
