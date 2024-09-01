import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/bloc/task_block.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/controllers/add_edit_task_controller.dart';
import 'package:task_management_app/utils/common_function.dart';

@immutable
class AddEditTaskScreen extends StatelessWidget {
  AddEditTaskScreen({super.key});

  final AddEditTaskController controller = Get.put(AddEditTaskController());

  void _openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.task?.date != null
          ? DateTime.fromMillisecondsSinceEpoch(controller.task!.date!)
          : null,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (picked != null) {
      controller.dateInMillis.value = picked.millisecondsSinceEpoch;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openDatePicker,
            icon: const Icon(Icons.access_time_rounded),
          ),
        ],
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
            Obx(
              () => controller.dateInMillis.value == null
                  ? const SizedBox()
                  : Text(
                      "Due Date: ${CommonFunction.getFormattedDateFromTimeInMillis(controller.dateInMillis.value)}",
                      style: const TextStyle(fontSize: 16),
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
