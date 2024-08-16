import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/bloc/task_block.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/models/task.dart';

class AddEditTaskController extends GetxController {
  Task? get task => Get.arguments;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    if (task != null) {
      titleController.text = task!.title;
      descriptionController.text = task!.description;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  saveTask() {
    if (task == null) {
      Get.context!.read<TaskBloc>().addTask(
            title: titleController.text,
            description: descriptionController.text,
          );
    } else {
      Get.context!.read<TaskBloc>().updateTask(Task(
          id: task!.id,
          title: titleController.text,
          description: descriptionController.text,
          isCompleted: task!.isCompleted));
    }

    Get.back();
  }
}
