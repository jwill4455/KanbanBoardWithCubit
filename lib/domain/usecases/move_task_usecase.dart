import '../../utils/enums/task_status.dart';
import '../repositories/task_repository.dart';
import '../entities/task.dart';

class MoveTaskUseCase {
  final TaskRepository repository;

  MoveTaskUseCase(this.repository);

  Future<void> execute(Task task, TaskStatus newStatus) async {
    final updatedTask = task.copyWith(status: newStatus);
    return repository.updateTask(updatedTask);
  }
}
