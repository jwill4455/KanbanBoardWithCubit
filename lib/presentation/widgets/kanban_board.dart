import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../domain/entities/task.dart';
import '../../utils/enums/task_status.dart';
import '../cubits/kanban_cubit.dart';
import '../cubits/timer_cubit.dart';
import 'task_card.dart';

class KanbanBoard extends StatelessWidget {
  final List<Task> tasks;

  const KanbanBoard({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildColumn(context, 'To Do', TaskStatus.toDo, tasks),
          buildColumn(context, 'In Progress', TaskStatus.inProgress, tasks),
          buildColumn(context, 'Done', TaskStatus.done, tasks),
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, String title, TaskStatus status, List<Task> tasks) {
    final filteredTasks = tasks.where((task) => task.status == status).toList();
    final PageController pageController = PageController();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.275,
      width: MediaQuery.of(context).size.width,
      child: DragTarget<Task>(
        onAcceptWithDetails: (DragTargetDetails<Task> details) {
          final task = details.data;
          if (task.status == TaskStatus.inProgress && status != TaskStatus.inProgress) {
            if (task.startedAt != null) {
              context.read<TimerCubit>().stopTimer(task);
            }
          }
          context.read<KanbanCubit>().moveTask(task, status);
        },
        builder: (context, candidateData, rejectedData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return LongPressDraggable<Task>(
                      data: task,
                      delay: const Duration(milliseconds: 300),
                      feedback: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: TaskCard(task: task),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TaskCard(task: task),
                        ),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TaskCard(task: task),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: filteredTasks.length > 1
                      ? SmoothPageIndicator(
                    controller: pageController,
                    count: filteredTasks.length,
                    effect: const WormEffect(
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      spacing: 8.0,
                      activeDotColor: Colors.blue,
                      dotColor: Colors.grey,
                    ),
                  )
                      : const SizedBox(height: 10),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
