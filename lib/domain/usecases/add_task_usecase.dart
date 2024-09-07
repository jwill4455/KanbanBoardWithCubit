import '../repositories/task_repository.dart';
import '../entities/task.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> execute(Task task) async {
    return repository.addTask(task);
  }
}
