import 'dart:convert';
import 'package:butterfly/blocs/habbitevent.dart';
import 'package:butterfly/blocs/habbitstate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitInitial()) {
    on<AddHabitEvent>(_onAddHabit);
    on<UpdateHabitCompletionEvent>(_onUpdateHabitCompletion);
    on<RemoveHabitEvent>(_onRemoveHabit);
    on<LoadHabits>(_onLoadHabits);
    on<AddSelectedHabitsEvent>(_onAddSelectedHabits);
    add(LoadHabits()); // Ensure habits are loaded initially
  }

  Future<void> _onAddHabit(
      AddHabitEvent event, Emitter<HabitState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    final List<Map<String, dynamic>> habits = habitsJson != null
        ? List<Map<String, dynamic>>.from(json.decode(habitsJson))
        : [];

    habits.add({
      'name': event.name,
      'type': event.type,
      'time': event.time, // إضافة الوقت
      'isCompleted': false,
    });

    await prefs.setString('habits', json.encode(habits));
    add(LoadHabits()); // Trigger reload
  }

  Future<void> _onUpdateHabitCompletion(
      UpdateHabitCompletionEvent event, Emitter<HabitState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    print('Stored habits: ${prefs.getString('habits')}');

    final String? habitsJson = prefs.getString('habits');
    final List<Map<String, dynamic>> habits = habitsJson != null
        ? List<Map<String, dynamic>>.from(json.decode(habitsJson))
        : [];
    habits[event.index]['isCompleted'] = event.isCompleted;
    await prefs.setString('habits', json.encode(habits));
    add(LoadHabits()); // Trigger reload
  }

  Future<void> _onRemoveHabit(
      RemoveHabitEvent event, Emitter<HabitState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    final List<Map<String, dynamic>> habits = habitsJson != null
        ? List<Map<String, dynamic>>.from(json.decode(habitsJson))
        : [];
    habits.removeAt(event.index);
    await prefs.setString('habits', json.encode(habits));
    add(LoadHabits()); // Trigger reload
  }

  Future<void> _onLoadHabits(LoadHabits event, Emitter<HabitState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    final List<Map<String, dynamic>> habits = habitsJson != null
        ? List<Map<String, dynamic>>.from(json.decode(habitsJson))
        : [];
    final double completionPercentage = _calculateCompletionPercentage(habits);
    emit(HabitLoaded(
      habits: habits,
      completionPercentage: completionPercentage,
    ));
    print('Emitted HabitLoaded with habits: $habits');
  }

  double _calculateCompletionPercentage(List<Map<String, dynamic>> habits) {
    if (habits.isEmpty) return 0;
    final completedCount = habits.where((h) => h['isCompleted'] == true).length;
    return (completedCount / habits.length) * 100;
  }

  // Handler for AddSelectedHabitsEvent
  Future<void> _onAddSelectedHabits(
      AddSelectedHabitsEvent event, Emitter<HabitState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    final List<Map<String, dynamic>> existingHabits = habitsJson != null
        ? List<Map<String, dynamic>>.from(json.decode(habitsJson))
        : [];

    // Add selected habits from the event
    existingHabits.addAll(event.selectedHabits);

    // Save the updated habits to shared preferences
    await prefs.setString('habits', json.encode(existingHabits));

    // Emit the updated state
    emit(HabitLoaded(
      habits: existingHabits,
      completionPercentage: _calculateCompletionPercentage(existingHabits),
    ));
  }
}
