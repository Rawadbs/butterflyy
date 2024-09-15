abstract class HabitEvent {}

class AddHabitEvent extends HabitEvent {
  final String name;
  final String type;
  final String time;

  AddHabitEvent({required this.name, required this.type, required this.time});
}
class UpdateHabitCompletionEvent extends HabitEvent {
  final int index;
  final bool isCompleted;

  UpdateHabitCompletionEvent({required this.index, required this.isCompleted});
}

class RemoveHabitEvent extends HabitEvent {
  final int index;

  RemoveHabitEvent(this.index);
}

class LoadHabits extends HabitEvent {}
