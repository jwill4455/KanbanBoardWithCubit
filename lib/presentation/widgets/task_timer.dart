import 'package:flutter/material.dart';
import 'dart:async';
import '../../domain/entities/task.dart';

class TaskTimer extends StatefulWidget {
  final Task task;

  const TaskTimer({super.key, required this.task});

  @override
  TaskTimerState createState() => TaskTimerState();
}

class TaskTimerState extends State<TaskTimer> {
  late Timer _timerInstance;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (widget.task.startedAt != null) {
      _elapsedTime = DateTime.now().difference(widget.task.startedAt!);
    }

    _timerInstance = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (widget.task.startedAt != null) {
          _elapsedTime = DateTime.now().difference(widget.task.startedAt!);
        }
      });
    });
  }

  @override
  void dispose() {
    _timerInstance.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _elapsedTime.inHours;
    final minutes = _elapsedTime.inMinutes % 60;
    final seconds = _elapsedTime.inSeconds % 60;

    return Text(
      '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: const TextStyle(color: Colors.red),
    );
  }
}
