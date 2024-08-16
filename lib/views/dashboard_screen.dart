import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_management_app/bloc/task_block.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/views/add_edit_task_screen.dart';

@immutable
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget getPillButton({required Function() onPressed, required Widget icon}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: icon,
      ),
    );
  }

  AccordionSection getTile(
      {required BuildContext context, required Task task}) {
    bool open = context.watch<TaskBloc>().state.openedTask?.id == task.id;

    return AccordionSection(
      headerPadding: const EdgeInsets.symmetric(horizontal: 10),
      onOpenSection: () => context.read<TaskBloc>().openTask(task),
      isOpen: open,
      leftIcon: Icon(
        task.isCompleted ? Icons.check_circle : Icons.circle,
        color: task.isCompleted ? Colors.green[500] : Colors.grey[200],
      ),
      accordionId: "${task.id}",
      // headerBackgroundColor: Theme.of(context).primaryColor,
      contentBackgroundColor: Theme.of(context).primaryColor,
      // contentBorderColor: Theme.of(context).primaryColor,
      // headerBorderColor: Theme.of(context).dividerColor,
      key: Key("${task.id}"),
      header: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 5),
            Text(
              task.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getPillButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle_outline
                    : Icons.check_circle,
                color: task.isCompleted ? Colors.grey[500] : Colors.green[500],
              ),
              onPressed: () => context.read<TaskBloc>().toggleTask(task)),
          const SizedBox(width: 10),
          getPillButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red[600],
              ),
              onPressed: () => context.read<TaskBloc>().deleteTask(task)),
          const SizedBox(width: 10),
          getPillButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blue[600],
              ),
              onPressed: () =>
                  Get.to(() => AddEditTaskScreen(), arguments: task)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listOfTasks = context.watch<TaskBloc>().state.listOfTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskManager"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                context.read<TaskBloc>().setSearch(value);
              },
              decoration: const InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          listOfTasks.isEmpty
              ? const Center(child: Text("No tasks found"))
              : Expanded(
                  child: Accordion(
                      scaleWhenAnimating: true,
                      paddingListTop: 5,
                      paddingListBottom: 5,
                      children: listOfTasks
                          .map((task) => getTile(context: context, task: task))
                          .toList()),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEditTaskScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
