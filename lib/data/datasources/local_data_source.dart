import 'package:isar/isar.dart';
import '../models/task_model.dart';

class LocalDataSource {
  final Isar isar;

  LocalDataSource(this.isar);

  Future<List<TaskModel>> getAllTasks() async {
    return await isar.taskModels.where().findAll();
  }

  Future<void> addTask(TaskModel task) async {
    await isar.writeTxn(() async {
      await isar.taskModels.put(task);
    });
  }

  Future<void> updateTask(TaskModel task) async {
    await isar.writeTxn(() async {
      await isar.taskModels.put(task);
    });
  }

  Future<void> removeTask(int taskId) async {
    await isar.writeTxn(() async {
      await isar.taskModels.delete(taskId);
    });
  }
}
