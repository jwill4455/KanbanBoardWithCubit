import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_task_history_usecase.dart';

class HistoryCubit extends Cubit<List<Task>> {
  final GetTaskHistoryUseCase getTaskHistoryUseCase;

  HistoryCubit(this.getTaskHistoryUseCase) : super([]) {
    loadTaskHistory();
  }

  void loadTaskHistory() async {
    final tasks = await getTaskHistoryUseCase.execute();
    emit(tasks);
  }
}
