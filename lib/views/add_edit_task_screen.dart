import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/bloc/task_block.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/controllers/add_edit_task_controller.dart';

@immutable
class AddEditTaskScreen extends StatelessWidget {
  AddEditTaskScreen({super.key});

  final AddEditTaskController controller = Get.put(AddEditTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            autofocus: controller.task == null,
            controller: controller.titleController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Enter Task Title",
            ),
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                autofocus: controller.task != null,
                scrollPhysics: const AlwaysScrollableScrollPhysics(),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Task Description",
                ),
              ),
            ),
            const SizedBox(height: 45),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: OutlinedButton(
              onPressed: () {
                if (controller.task != null) {
                  context.read<TaskBloc>().deleteTask(controller.task!);
                }
                Get.back();
              },
              child: Text(controller.task != null ? "Delete" : "Cancel"),
            )),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => (controller.titleController.text
                            .trim()
                            .isNotEmpty &&
                        controller.descriptionController.text.trim().isNotEmpty)
                    ? controller.saveTask()
                    : null,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
