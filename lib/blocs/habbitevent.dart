// lib/bloc/habit_event.dart
abstract class HabitEvent {}

class AddHabitEvent extends HabitEvent {
  final String name;
  final String type;

  AddHabitEvent(this.name, this.type);
}

class UpdateHabitCompletionEvent extends HabitEvent {
  final int index;
  final bool isCompleted;

  UpdateHabitCompletionEvent(this.index, this.isCompleted);
}

class DeleteHabitEvent extends HabitEvent {
  final int index;

  DeleteHabitEvent(this.index);
}

class ChangeColorEvent extends HabitEvent {
  final int index;
  final bool isBlack;

  ChangeColorEvent(this.index, this.isBlack);
}
