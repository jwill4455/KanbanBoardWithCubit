import '../repositories/task_repository.dart';
import '../entities/task.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<Task>> execute() async {
    return await repository.getAllTasks();
  }
}
