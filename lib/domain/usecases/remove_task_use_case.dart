import '../repositories/task_repository.dart';

class RemoveTaskUseCase {
  final TaskRepository repository;

  RemoveTaskUseCase(this.repository);

  Future<void> execute(int taskId) async {
    await repository.removeTask(taskId);
  }
}