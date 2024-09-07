import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../../domain/usecases/move_task_usecase.dart';
import '../../domain/usecases/remove_task_use_case.dart';
import '../../domain/usecases/update_task_use_case.dart';
import '../../utils/enums/kanban_state_status.dart';
import '../../utils/enums/task_status.dart';
import 'kanban_state.dart';

class KanbanCubit extends Cubit<KanbanState> {
  final MoveTaskUseCase moveTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final RemoveTaskUseCase removeTaskUseCase;

  KanbanCubit(
      this.moveTaskUseCase,
      this.getTasksUseCase,
      this.addTaskUseCase,
      this.updateTaskUseCase,
      this.removeTaskUseCase,
      ) : super(KanbanState(tasks: [])) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.loading));
    try {
      final tasks = await getTasksUseCase.execute();
      emit(KanbanState(tasks: tasks, status: KanbanStateStatus.success));
    } catch (e) {
      emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.failure));
    }
  }

  Future<void> addTask(Task task) async {
    emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.loading));
    try {
      await addTaskUseCase.execute(task);
      await loadTasks();
    } catch (e) {
      emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.failure));
    }
  }

  Future<void> updateTask(Task task) async {
    emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.loading));
    try {
      final updatedTasks = List<Task>.from(state.tasks);
      final taskIndex = updatedTasks.indexWhere((t) => t.id == task.id);
      if (taskIndex != -1) {
        updatedTasks[taskIndex] = task;
      }
      emit(KanbanState(tasks: updatedTasks, status: KanbanStateStatus.success));
      await updateTaskUseCase.execute(task);
    } catch (e) {
      emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.failure));
    }
  }


  Future<void> removeTask(int taskId) async {
    emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.loading));
    try {
      await removeTaskUseCase.execute(taskId);
      await loadTasks();
    } catch (e) {
      emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.failure));
    }
  }

  Future<void> moveTask(Task task, TaskStatus newStatus) async {
    emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.loading));
    try {
      await moveTaskUseCase.execute(task, newStatus);
      await loadTasks();
    } catch (e) {
      emit(KanbanState(tasks: state.tasks, status: KanbanStateStatus.failure));
    }
  }
}

