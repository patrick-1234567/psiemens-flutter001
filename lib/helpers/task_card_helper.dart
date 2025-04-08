import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../components/card.dart'; // Importa el CustomCard

class TaskCardHelper {
  static Widget buildTaskCard(Task task) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white,
      child: ListTile(
        leading: Icon(
          task.type == 'urgente' ? Icons.warning : Icons.task,
          color: task.type == 'urgente' ? Colors.red : Colors.blue,
        ),
        title: Text(task.title),
        subtitle: Text('${AppConstants.TASK_TYPE_LABEL}${task.type}'),
      ),
    );
  }
}