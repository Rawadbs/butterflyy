import 'package:flutter/material.dart';

class AddHabitDialog extends StatefulWidget {
  final Function(String, String, String) onAddHabit;

  const AddHabitDialog({super.key, required this.onAddHabit});

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _habitNameController = TextEditingController();
  String _habitType = 'صحية'; // القيمة الافتراضية لنوع العادة
  String _habitTime = 'الفجر'; // القيمة الافتراضية لوقت العادة

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
              controller: _habitNameController,
              decoration: const InputDecoration(
                labelText: 'اسم العادة',
                labelStyle: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'تصنيف العادة',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _habitType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _habitType = newValue!;
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
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'وقت العادة',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _habitTime,
                    onChanged: (String? newValue) {
                      setState(() {
                        _habitTime = newValue!;
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
                    items: <String>[
                      'الفجر',
                      'الظهر',
                      'العصر',
                      'المغرب',
                      'العشاء'
                    ].map<DropdownMenuItem<String>>((String value) {
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_habitNameController.text.isNotEmpty) {
                  widget.onAddHabit(
                    _habitNameController.text,
                    _habitType,
                    _habitTime,
                  );
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff525357),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                minimumSize: const Size(double.infinity, 35),
              ),
              child: const Text(
                'حفظ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
