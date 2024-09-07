import 'package:isar/isar.dart';
import 'package:kanban_board_with_cubit/utils/enums/task_status.dart';

class Task {
  final Id? id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  DateTime? completedAt;
  DateTime? startedAt;
  Duration? totalTime;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.status = TaskStatus.toDo,
    required this.createdAt,
    this.completedAt,
    this.startedAt,
    this.totalTime,
  });

  Task copyWith({
    Id? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? startedAt,
    Duration? totalTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      startedAt: startedAt ?? this.startedAt,
      totalTime: totalTime ?? this.totalTime,
    );
  }
}