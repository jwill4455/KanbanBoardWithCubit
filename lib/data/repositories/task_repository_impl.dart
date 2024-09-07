import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';
import '../datasources/local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getAllTasks() async {
    final taskModels = await localDataSource.getAllTasks();
    return taskModels.map((taskModel) => taskModel.toDomain()).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await localDataSource.addTask(TaskModel.fromDomain(task));
  }

  @override
  Future<void> updateTask(Task task) async {
    await localDataSource.updateTask(TaskModel.fromDomain(task));
  }

  @override
  Future<void> removeTask(int taskId) async {
    await localDataSource.removeTask(taskId);
  }
}
