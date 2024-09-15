// habbit_state.dart
abstract class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoadSuccess extends HabitState {
  final List<Map<String, dynamic>> habits;
  final double completionPercentage;

  HabitLoadSuccess(this.habits, this.completionPercentage);
}

// Define other states similarly
