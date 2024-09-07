import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> execute(Task task) async {
    return await repository.updateTask(task);
  }
}
