import 'package:isar/isar.dart';
import '../../domain/entities/task.dart';
import '../../utils/enums/task_status.dart';

part 'task_model.g.dart';

@Collection()
class TaskModel {
  Id? id;
  final String title;
  final String description;

  @enumerated
  final TaskStatus status;

  final DateTime createdAt;
  DateTime? completedAt;
  DateTime? startedAt;
  int? totalTime;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.status = TaskStatus.toDo,
    required this.createdAt,
    this.completedAt,
    this.startedAt,
    this.totalTime,
  });

  factory TaskModel.fromDomain(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      createdAt: task.createdAt,
      completedAt: task.completedAt,
      startedAt: task.startedAt,
      totalTime: task.totalTime?.inMilliseconds,
    );
  }

  Task toDomain() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: status,
      createdAt: createdAt,
      completedAt: completedAt,
      startedAt: startedAt,
      totalTime: totalTime != null ? Duration(milliseconds: totalTime!) : null,
    );
  }
}
