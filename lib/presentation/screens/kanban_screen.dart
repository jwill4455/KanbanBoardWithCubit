import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board_with_cubit/presentation/screens/task_details_screen.dart';
import '../../utils/enums/kanban_state_status.dart';
import '../cubits/history_cubit.dart';
import '../cubits/kanban_cubit.dart';
import '../cubits/kanban_state.dart';
import '../widgets/kanban_board.dart';
import 'history_screen.dart';

class KanbanScreen extends StatefulWidget {
  const KanbanScreen({super.key});

  @override
  KanbanScreenState createState() => KanbanScreenState();
}

class KanbanScreenState extends State<KanbanScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: BlocBuilder<KanbanCubit, KanbanState>(
          builder: (context, state) {
            if (state.status == KanbanStateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == KanbanStateStatus.failure) {
              return const Center(child: Text('Failed to load tasks'));
            }

            return KanbanBoard(tasks: state.tasks);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskDetailsScreen(),
              ),
            );
          } else if (index == 1) {
            context.read<HistoryCubit>().loadTaskHistory();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'View History',
          ),
        ],
      ),
    );
  }
}

