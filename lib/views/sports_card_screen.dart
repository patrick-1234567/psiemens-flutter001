import 'package:flutter/material.dart';
import 'package:psiemens/domain/task.dart';
import 'package:psiemens/helpers/task_card_helper.dart';

class SportsCardSwipeScreen extends StatelessWidget {
  final List<Task> tasks;
  final int initialIndex;

  const SportsCardSwipeScreen({
    super.key,
    required this.tasks,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Cards'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Ícono de retroceso
          onPressed: () {
            Navigator.pop(context); // Navega hacia atrás
          },
        ),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Center(
            child: TaskCardHelper.buildSportsCard(task, index),
          );
        },
      ),
    );
  }
}