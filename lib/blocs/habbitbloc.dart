// habbit_bloc.dart
import 'package:bloc/bloc.dart';

import 'package:butterfly/blocs/habbitevent.dart';
import 'package:butterfly/blocs/habbitstate.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  List<Map<String, dynamic>> _habits = [];
  double _completionPercentage = 0;

  HabitBloc() : super(HabitInitial()) {
    on<AddHabitEvent>((event, emit) {
      _addHabit(event.name, event.type);
      emit(HabitLoadSuccess(_habits, _completionPercentage));
    });

    on<UpdateHabitCompletionEvent>((event, emit) {
      _updateHabitCompletion(event.index, event.isCompleted);
      emit(HabitLoadSuccess(_habits, _completionPercentage));
    });

    on<DeleteHabitEvent>((event, emit) {
      _deleteHabit(event.index);
      emit(HabitLoadSuccess(_habits, _completionPercentage));
    });
  }

  void _addHabit(String name, String type) {
    _habits.add({'name': name, 'type': type, 'isCompleted': false});
    _updateCompletionPercentage();
  }

  void _updateHabitCompletion(int index, bool isCompleted) {
    _habits[index]['isCompleted'] = isCompleted;
    _updateCompletionPercentage();
  }

  void _deleteHabit(int index) {
    _habits.removeAt(index);
    _updateCompletionPercentage();
  }

  void _updateCompletionPercentage() {
    if (_habits.isNotEmpty) {
      double habitCompletionPercentage = 100 / _habits.length;
      _completionPercentage = _habits
          .where((h) => h['isCompleted'] == true)
          .length *
          habitCompletionPercentage;
    } else {
      _completionPercentage = 0;
    }
  }
}
