import 'package:flutter/material.dart';

class AddHabitDialog extends StatefulWidget {
  final Function(String, String) onAddHabit;

  const AddHabitDialog({super.key, required this.onAddHabit});

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  String habitName = '';
  String habitType = 'صحية'; // القيمة الافتراضية لنوع العادة

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'إضافة عادة جديدة',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                habitName = value;
              },
              decoration: const InputDecoration(
                  labelText: 'اسم العادة',
                  labelStyle: TextStyle(fontFamily: 'Cairo')),
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'تصنيف العادة',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontFamily: 'Cairo' // يمكنك تعديل اللون حسب التصميم
                        ),
                  ),
                ),
                Expanded(
                  flex: 2, // يمكن تعديل نسبة التوسع حسب الحاجة
                  child: DropdownButtonFormField<String>(
                    value: habitType,
                    onChanged: (String? newValue) {
                      setState(() {
                        habitType = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    dropdownColor: Colors.white,
                    items: <String>['صحية', 'شخصية', 'دينية', 'مالية']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontFamily: 'Cairo'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: GestureDetector(
                onTap: () {
                  if (habitName.isNotEmpty) {
                    widget.onAddHabit(habitName, habitType);
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Color(0xff525357),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: const Center(
                    child: Text(
                      'حفظ',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
