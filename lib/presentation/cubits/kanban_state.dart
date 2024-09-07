import '../../domain/entities/task.dart';
import '../../utils/enums/kanban_state_status.dart';

class KanbanState {
  final List<Task> tasks;
  final KanbanStateStatus status;

  KanbanState({required this.tasks, this.status = KanbanStateStatus.initial});

  KanbanState copyWith({List<Task>? tasks, KanbanStateStatus? status}) {
    return KanbanState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
    );
  }
}
