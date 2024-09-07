import 'package:flutter/material.dart';
import 'package:kanban_board_with_cubit/presentation/widgets/task_timer.dart';
import '../../domain/entities/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/duration_formatter.dart';
import '../../utils/enums/kanban_state_status.dart';
import '../../utils/enums/task_status.dart';
import '../cubits/kanban_cubit.dart';
import '../cubits/kanban_state.dart';
import '../screens/task_details_screen.dart';
import '../cubits/timer_cubit.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  TaskCardState createState() => TaskCardState();
}

class TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<KanbanCubit, KanbanState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(task.description),
                const SizedBox(height: 36.0),
                Row(
                  children: [
                    BlocBuilder<TimerCubit, List<Task>>(
                      builder: (context, taskList) {
                        if (task.startedAt != null &&
                            task.status == TaskStatus.inProgress) {
                          return Row(
                            children: [
                              const Icon(Icons.circle,
                                  color: Colors.red, size: 10),
                              const SizedBox(width: 4),
                              TaskTimer(task: task),
                            ],
                          );
                        } else if (task.totalTime != null) {
                          return Text(
                            'Time spent: ${DurationFormatter.format(task.totalTime!)}',
                            style: const TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.normal),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const Spacer(),
                    if (state.status == KanbanStateStatus.loading)
                      const CircularProgressIndicator()
                    else ...[
                      if (task.status != TaskStatus.done && task.startedAt == null)
                        IconButton(
                          icon: const Icon(Icons.check),
                          color: Colors.green,
                          tooltip: 'Mark as Completed',
                          onPressed: () {
                            context.read<KanbanCubit>().updateTask(
                              task.copyWith(
                                completedAt: DateTime.now(),
                                status: TaskStatus.done,
                              ),
                            );
                          },
                        ),
                      IconButton(
                        icon: task.startedAt == null
                            ? const Icon(Icons.play_arrow)
                            : const Icon(Icons.stop),
                        tooltip: task.startedAt == null
                            ? 'Start Timer'
                            : 'Stop Timer',
                        onPressed: () {
                          final kanbanCubit = context.read<KanbanCubit>();
                          if (task.startedAt == null) {
                            context
                                .read<TimerCubit>()
                                .startTimer(task)
                                .then((_) {
                              if (mounted) {
                                kanbanCubit.updateTask(
                                  task.copyWith(
                                    startedAt: DateTime.now(),
                                    status: TaskStatus.inProgress,
                                  ),
                                );
                              }
                            });
                          } else {
                            context
                                .read<TimerCubit>()
                                .stopTimer(task)
                                .then((_) {
                              if (mounted) {
                                kanbanCubit.updateTask(
                                  task.copyWith(
                                    totalTime: task.startedAt != null
                                        ? (task.totalTime ?? const Duration()) +
                                            DateTime.now()
                                                .difference(task.startedAt!)
                                        : task.totalTime,
                                    startedAt: null,
                                    status: TaskStatus.inProgress,
                                  ),
                                );
                              }
                            });
                          }
                        },
                      ),

                      // Reset Button
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Reset Timer',
                        onPressed: () {
                          final kanbanCubit = context.read<KanbanCubit>();
                          kanbanCubit.updateTask(
                            task.copyWith(
                              totalTime: const Duration(),
                              startedAt: null,
                            ),
                          );
                          context.read<TimerCubit>().resetTimer(task);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Task',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetailsScreen(task: task),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remove Task',
                        onPressed: () {
                          context.read<KanbanCubit>().removeTask(task.id!);
                        },
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
