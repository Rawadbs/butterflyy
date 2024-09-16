import 'package:butterfly/blocs/habbitbloc.dart';
import 'package:butterfly/blocs/habbitevent.dart';
import 'package:butterfly/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingSecond extends StatefulWidget {
  const OnboardingSecond({super.key, required this.userName});
  final String userName;

  @override
  OnboardingSecondState createState() => OnboardingSecondState();
}

class OnboardingSecondState extends State<OnboardingSecond> {
  List<int> selectedItems = [];

  final List<Map<String, String>> items = [
    {'text': 'قراءة القرآن', 'image': 'assets/images/q.png', 'type': 'دينية'},
    {'text': 'المذاكرة', 'image': 'assets/images/3.png', 'type': 'شخصية'},
    {
      'text': 'الخروج من المنزل',
      'image': 'assets/images/h.png',
      'type': 'شخصية'
    },
    {'text': 'قيام الليل', 'image': 'assets/images/1.png', 'type': 'دينية'},
    {'text': 'قراءة الكتب', 'image': 'assets/images/4.png', 'type': 'شخصية'},
    {'text': 'الرياضة', 'image': 'assets/images/2.png', 'type': 'صحية'},
    {'text': 'شرب الماء', 'image': 'assets/images/w.png', 'type': 'صحية'},
    {'text': 'النوم المبكر', 'image': 'assets/images/s.png', 'type': 'صحية'},
  ];
  void _saveSelectedItems() {
    if (selectedItems.length <= 4) {
      final selectedHabits = selectedItems.map((index) {
        final item = items[index];
        return {
          'name': item['text'] ?? '',
          'type': item['type'] ?? '',
          'isCompleted': false, // Adding a default value for 'isCompleted'
        };
      }).toList();

      // Dispatch the AddSelectedHabitsEvent to the HabitBloc
      context
          .read<HabitBloc>()
          .add(AddSelectedHabitsEvent(selectedHabits: selectedHabits));

      // Navigate to the homepage and pass userName
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userName: widget.userName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final isSelected = selectedItems.contains(index);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedItems.remove(index);
                      } else {
                        if (selectedItems.length < 4) {
                          selectedItems.add(index);
                        }
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xff525357)
                            : const Color(0xffEAECF0),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(14),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          items[index]['image']!,
                          height: 80,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          items[index]['text']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 24,
              right: 24,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveSelectedItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff525357),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'حفظ العناصر المختارة',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
