import 'package:flutter/foundation.dart';

@immutable
abstract class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoaded extends HabitState {
  final List<Map<String, dynamic>> habits;
  final double completionPercentage;

  HabitLoaded({required this.habits, required this.completionPercentage});
}
