import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/bloc/task_state.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/repository/task_repository.dart';

class TaskBloc extends Cubit<TaskState> {
  final TaskRepository _taskRepository;
  List<Task> _listOfTasks = [];
  String value = '';

  TaskBloc(this._taskRepository) : super(TaskState(listOfTasks: [])) {
    _fetchListOfTasks();
  }

  Future<void> _fetchListOfTasks({Task? setOpenedTask}) async {
    // get all the tasks from the database
    // sort the tasks based on the isCompleted field

    final List<Task> tasks = await _taskRepository.getTasks();

    if (setOpenedTask != null) {
      state.openedTask = setOpenedTask;
    } else if (tasks.isNotEmpty) {
      state.openedTask = tasks.last;
    }

    tasks.sort((a, b) => a.isCompleted == false ? -1 : 1);
    _listOfTasks = tasks;
    emit(TaskState(
        listOfTasks: _getListOfTasks(), openedTask: state.openedTask));
  }

  Future<void> addTask(
      {required String title, required String description}) async {
    // insert the task into the database
    await _taskRepository.insertTask(title: title, description: description);

    _fetchListOfTasks();
  }

  Future<void> updateTask(Task task) async {
    // update the task in the database
    await _taskRepository.updateTask(task);
    _fetchListOfTasks(setOpenedTask: task);
  }

  Future<void> deleteTask(Task task) async {
    // delete the task from the database
    await _taskRepository.deleteTask(task.id);

    _fetchListOfTasks();
  }

  void toggleTask(Task task) {
    // toggle the isCompleted field of the task
    updateTask(task.copyWith(isCompleted: !task.isCompleted));
  }

  void openTask(Task task) {
    state.openedTask = task;
  }

  void setSearch(String value) {
    this.value = value.trim();
    emit(TaskState(
        listOfTasks: _getListOfTasks(), openedTask: state.openedTask));
  }

  List<Task> _getListOfTasks() {
    if (value.trim().isNotEmpty) {
      // filter the tasks based on the value
      final List<Task> tasks = _listOfTasks
          .where((task) =>
              task.title.toLowerCase().contains(value.toLowerCase()) ||
              task.description.toLowerCase().contains(value.toLowerCase()))
          .toList();
      return tasks;
    }
    return _listOfTasks;
  }
}
