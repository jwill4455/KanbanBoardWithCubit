import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/track_time_usecase.dart';

class TimerCubit extends Cubit<List<Task>> {
  final TrackTimeUseCase trackTimeUseCase;

  TimerCubit(this.trackTimeUseCase) : super([]);

  Future<void> startTimer(Task task) async {
    task.startedAt = DateTime.now();
    await trackTimeUseCase.startTracking(task);

    final updatedTasks = List<Task>.from(state);
    final taskIndex = updatedTasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      updatedTasks[taskIndex] = task;
    }
    emit(updatedTasks);
  }

  Future<void> stopTimer(Task task) async {
    await trackTimeUseCase.stopTracking(task);
    final updatedTasks = List<Task>.from(state);
    final taskIndex = updatedTasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      updatedTasks[taskIndex] = task;
    }
    emit(updatedTasks);
  }

  Future<void> resetTimer(Task task) async {
    task.totalTime = const Duration();
    task.startedAt = null;
    await trackTimeUseCase.resetTracking(task);
    final updatedTasks = List<Task>.from(state);
    final taskIndex = updatedTasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      updatedTasks[taskIndex] = task;
    }
    emit(updatedTasks);
  }
}
