import '../entities/task.dart';
import '../repositories/task_repository.dart';

class TrackTimeUseCase {
  final TaskRepository repository;

  TrackTimeUseCase(this.repository);

  Future<void> startTracking(Task task) async {
    task.startedAt = DateTime.now();
    await repository.updateTask(task);
  }

  Future<void> stopTracking(Task task) async {
    if (task.startedAt != null) {
      final totalTime = DateTime.now().difference(task.startedAt!);
      task.totalTime = (task.totalTime ?? const Duration()) + totalTime;
      task.startedAt = null;
      await repository.updateTask(task);
    }
  }

  Future<void> resetTracking(Task task) async {
    task.totalTime = const Duration();
    task.startedAt = null;
    await repository.updateTask(task);
  }
}

