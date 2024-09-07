import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:kanban_board_with_cubit/domain/usecases/get_task_history_usecase.dart';
import 'package:kanban_board_with_cubit/domain/usecases/remove_task_use_case.dart';
import 'package:kanban_board_with_cubit/presentation/cubits/history_cubit.dart';
import 'package:kanban_board_with_cubit/presentation/cubits/kanban_cubit.dart';
import 'package:kanban_board_with_cubit/presentation/cubits/timer_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'data/datasources/local_data_source.dart';
import 'data/models/task_model.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/add_task_usecase.dart';
import 'domain/usecases/get_tasks_use_case.dart';
import 'domain/usecases/move_task_usecase.dart';
import 'domain/usecases/track_time_usecase.dart';
import 'domain/usecases/update_task_use_case.dart';
import 'presentation/screens/kanban_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TaskModelSchema],
    directory: dir.path,
  );

  final localDataSource = LocalDataSource(isar);
  final taskRepository = TaskRepositoryImpl(localDataSource);

  final moveTaskUseCase = MoveTaskUseCase(taskRepository);
  final getTasksUseCase = GetTasksUseCase(taskRepository);
  final addTaskUseCase = AddTaskUseCase(taskRepository);
  final updateTaskUseCase = UpdateTaskUseCase(taskRepository);
  final trackTimeUseCase = TrackTimeUseCase(taskRepository);
  final removeTaskUseCase = RemoveTaskUseCase(taskRepository);
  final getTaskHistoryUseCase = GetTaskHistoryUseCase(taskRepository);

  runApp(MyApp(
    moveTaskUseCase: moveTaskUseCase,
    getTasksUseCase: getTasksUseCase,
    addTaskUseCase: addTaskUseCase,
    updateTaskUseCase: updateTaskUseCase,
    trackTimeUseCase: trackTimeUseCase,
    removeTaskUseCase: removeTaskUseCase,
    getTaskHistoryUseCase: getTaskHistoryUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final MoveTaskUseCase moveTaskUseCase;
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final TrackTimeUseCase trackTimeUseCase;
  final RemoveTaskUseCase removeTaskUseCase;
  final GetTaskHistoryUseCase getTaskHistoryUseCase;

  const MyApp({
    super.key,
    required this.moveTaskUseCase,
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.trackTimeUseCase,
    required this.removeTaskUseCase,
    required this.getTaskHistoryUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => KanbanCubit(
            moveTaskUseCase,
            getTasksUseCase,
            addTaskUseCase,
            updateTaskUseCase,
            removeTaskUseCase,
          ),
        ),
        BlocProvider(
          create: (context) => TimerCubit(
              trackTimeUseCase
          ),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(
              getTaskHistoryUseCase
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task Tracking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const KanbanScreen(),
      ),
    );
  }
}
