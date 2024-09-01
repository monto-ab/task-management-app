import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/bloc/task_block.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/models/task.dart';

class AddEditTaskController extends GetxController {
  Task? get task => Get.arguments;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  Rx dateInMillis = Rx(null);

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    if (task != null) {
      titleController.text = task!.title;
      descriptionController.text = task!.description;
      dateInMillis = Rx(task!.date);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dateInMillis.close();
    super.onClose();
  }

  saveTask() {
    if (task == null) {
      Get.context!.read<TaskBloc>().addTask(
            title: titleController.text,
            description: descriptionController.text,
            dateInMillis: dateInMillis.value,
          );
    } else {
      Get.context!.read<TaskBloc>().updateTask(Task(
          id: task!.id,
          title: titleController.text,
          description: descriptionController.text,
          isCompleted: task!.isCompleted,
          date: dateInMillis.value));
    }

    Get.back();
  }
}
