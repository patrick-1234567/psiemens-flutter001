import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../helpers/task_card_helper.dart';

class SportsCardSwipeScreen extends StatelessWidget {
  final List<Task> tasks;
  final int initialIndex;

  const SportsCardSwipeScreen({
    Key? key,
    required this.tasks,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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