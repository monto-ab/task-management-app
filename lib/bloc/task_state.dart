import 'package:task_management_app/models/task.dart';

class TaskState {
  final List<Task> listOfTasks;
  late Task? openedTask;

  TaskState({required this.listOfTasks, this.openedTask});

  TaskState copyWith({required List<Task>? tasks, Task? openedTask}) {
    return TaskState(
        listOfTasks: tasks ?? listOfTasks,
        openedTask: openedTask ?? this.openedTask);
  }
}
