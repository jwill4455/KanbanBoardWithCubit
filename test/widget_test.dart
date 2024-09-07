import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board_with_cubit/domain/usecases/get_tasks_use_case.dart';
import 'package:kanban_board_with_cubit/domain/usecases/remove_task_use_case.dart';
import 'package:kanban_board_with_cubit/domain/usecases/update_task_use_case.dart';
import 'package:kanban_board_with_cubit/main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board_with_cubit/domain/usecases/move_task_usecase.dart';
import 'package:kanban_board_with_cubit/domain/usecases/add_task_usecase.dart';
import 'package:kanban_board_with_cubit/domain/usecases/get_task_history_usecase.dart';
import 'package:kanban_board_with_cubit/domain/usecases/track_time_usecase.dart';
import 'package:kanban_board_with_cubit/presentation/cubits/kanban_cubit.dart';
import 'package:kanban_board_with_cubit/presentation/cubits/timer_cubit.dart';
import 'package:kanban_board_with_cubit/presentation/cubits/history_cubit.dart';

class MockMoveTaskUseCase extends Mock implements MoveTaskUseCase {}
class MockGetTasksUseCase extends Mock implements GetTasksUseCase {}
class MockAddTaskUseCase extends Mock implements AddTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockRemoveTaskUseCase extends Mock implements RemoveTaskUseCase {}
class MockGetTaskHistoryUseCase extends Mock implements GetTaskHistoryUseCase {}
class MockTrackTimeUseCase extends Mock implements TrackTimeUseCase {}

void main() {
  late MockMoveTaskUseCase moveTaskUseCase;
  late MockGetTasksUseCase getTasksUseCase;
  late MockAddTaskUseCase addTaskUseCase;
  late MockUpdateTaskUseCase updateTaskUseCase;
  late MockRemoveTaskUseCase removeTaskUseCase;
  late MockGetTaskHistoryUseCase getTaskHistoryUseCase;
  late MockTrackTimeUseCase trackTimeUseCase;

  setUp(() {
    moveTaskUseCase = MockMoveTaskUseCase();
    getTasksUseCase = MockGetTasksUseCase();
    addTaskUseCase = MockAddTaskUseCase();
    updateTaskUseCase = MockUpdateTaskUseCase();
    removeTaskUseCase = MockRemoveTaskUseCase();
    getTaskHistoryUseCase = MockGetTaskHistoryUseCase();
    trackTimeUseCase = MockTrackTimeUseCase();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    when(() => getTasksUseCase.execute()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => KanbanCubit(
              moveTaskUseCase,
              getTasksUseCase,
              addTaskUseCase,
              updateTaskUseCase,
              removeTaskUseCase,
            ),
          ),
          BlocProvider(
            create: (_) => TimerCubit(trackTimeUseCase),
          ),
          BlocProvider(
            create: (_) => HistoryCubit(getTaskHistoryUseCase),
          ),
        ],
        child: MyApp(
          moveTaskUseCase: moveTaskUseCase,
          getTasksUseCase: getTasksUseCase,
          addTaskUseCase: addTaskUseCase,
          updateTaskUseCase: updateTaskUseCase,
          removeTaskUseCase: removeTaskUseCase,
          getTaskHistoryUseCase: getTaskHistoryUseCase,
          trackTimeUseCase: trackTimeUseCase,
        ),
      ),
    );

    // Verify that the counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
