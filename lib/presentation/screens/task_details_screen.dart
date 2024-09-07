import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../utils/enums/kanban_state_status.dart';
import '../../utils/enums/task_status.dart';
import '../cubits/kanban_cubit.dart';
import '../cubits/kanban_state.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task? task;

  const TaskDetailsScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');

    return Scaffold(
      appBar: AppBar(title: Text(task == null ? 'Add Task' : 'Edit Task')),
      body: BlocConsumer<KanbanCubit, KanbanState>(
        listener: (context, state) {
          if (state.status == KanbanStateStatus.success) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                state.status == KanbanStateStatus.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    final taskToSave = Task(
                      id: task?.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      status: task?.status ?? TaskStatus.toDo,
                      createdAt: task?.createdAt ?? DateTime.now(),
                    );

                    if (task == null) {
                      context.read<KanbanCubit>().addTask(taskToSave);
                    } else {
                      context.read<KanbanCubit>().updateTask(taskToSave);
                    }
                  },
                  child: Text(task == null ? 'Create Task' : 'Update Task'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



