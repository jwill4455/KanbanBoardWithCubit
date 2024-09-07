import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_board_with_cubit/domain/entities/task.dart';
import 'package:kanban_board_with_cubit/domain/usecases/track_time_usecase.dart';
import 'package:kanban_board_with_cubit/presentation/cubits/timer_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackTimeUseCase extends Mock implements TrackTimeUseCase {}

void main() {
  late TimerCubit timerCubit;
  late MockTrackTimeUseCase mockTrackTimeUseCase;
  late Task task;

  setUp(() {
    mockTrackTimeUseCase = MockTrackTimeUseCase();
    timerCubit = TimerCubit(mockTrackTimeUseCase);

    task = Task(
      id: 1,
      title: 'Test Task',
      description: 'This is a test task',
      createdAt: DateTime.now(),
    );

    registerFallbackValue(Task(
      id: 1,
      title: 'Fallback Task',
      description: 'Fallback description',
      createdAt: DateTime.now(),
    ));
  });

  tearDown(() {
    timerCubit.close();
  });

  blocTest<TimerCubit, List<Task>>(
    'emits updated task with startedAt when startTimer is called',
    build: () => timerCubit,
    seed: () => [task],
    act: (cubit) {
      when(() => mockTrackTimeUseCase.startTracking(any()))
          .thenAnswer((_) async {});

      cubit.startTimer(
          task);
    },
    expect: () => [
      [isA<Task>().having((t) => t.startedAt, 'startedAt', isNotNull)]
    ],
    verify: (_) {
      verify(() => mockTrackTimeUseCase.startTracking(task)).called(1);
    },
  );
}
