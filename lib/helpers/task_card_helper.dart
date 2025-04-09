import 'package:flutter/material.dart';
import 'package:psiemens/views/sports_card_screen.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../components/card.dart'; // Importa el CustomCard

class TaskCardHelper {
  static Widget buildTaskCard(BuildContext context, Task task, List<Task> tasks, VoidCallback onEdit) {
  return GestureDetector( // Detecta el toque en la tarjeta
    child: CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white,
      child: ListTile(
        leading: Icon(
          task.type == 'urgente' ? Icons.warning : Icons.task,
          color: task.type == 'urgente' ? Colors.red : Colors.blue,
        ),
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppConstants.TASK_TYPE_LABEL}${task.type}'),
            Text('Descripción: ${task.description}'),
            Text('Fecha límite: ${task.deadline.toLocal()}'),
            Text('${AppConstants.PASO_TITULO}${task.steps.join(', ')}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit, // Llama al callback de edición
            ),
            IconButton(
              icon: const Icon(Icons.sports, color: Colors.green),
              onPressed: () {
                // Navega directamente a la pantalla de la tarjeta deportiva
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SportsCardSwipeScreen(
                      tasks: tasks, 
                      initialIndex: tasks.indexOf(task)
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

  static Widget buildSportsCard(Task task, int index) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              'https://picsum.photos/200/300?random=$index',
              height: 300, // Altura fija
              width: 200,  // Ancho fijo
              fit: BoxFit.cover,
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(AppConstants.PASO_TITULO,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...task.steps.map((step) => Text(
                    '- $step',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  )),
              const SizedBox(height: 8),
                Text(
                  'Fecha límite: ${task.deadline.toLocal()}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

