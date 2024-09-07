import '../entities/task.dart';
import '../../utils/enums/task_status.dart';
import '../repositories/task_repository.dart';

class GetTaskHistoryUseCase {
  final TaskRepository repository;

  GetTaskHistoryUseCase(this.repository);

  Future<List<Task>> execute() async {
    final allTasks = await repository.getAllTasks();
    return allTasks.where((task) => task.status == TaskStatus.done).toList();
  }
}
