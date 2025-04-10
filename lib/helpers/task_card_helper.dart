import 'package:flutter/material.dart';
import 'package:psiemens/views/sports_card_screen.dart';
import '../domain/task.dart';
import '../constants.dart';
import '../components/card.dart'; // Importa el CustomCard
import '../helpers/common_widgets_helper.dart'; // Importa CommonWidgetsHelper

class TaskCardHelper {
  static Widget buildTaskCard(BuildContext context, Task task, List<Task> tasks, VoidCallback onEdit) {
    return GestureDetector(
      onTap: () {
        // Navega directamente a la pantalla de las Sport Cards al tocar la tarjeta
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SportsCardSwipeScreen(
              tasks: tasks,
              initialIndex: tasks.indexOf(task),
            ),
          ),
        );
      },
      child: CustomCard(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: CommonWidgetsHelper.buildRoundedBorder().borderRadius!,
        backgroundColor: Colors.white,
        child: ListTile(
          leading: Icon(
            task.type == 'urgente' ? Icons.warning : Icons.task,
            color: task.type == 'urgente' ? Colors.red : Colors.blue,
          ),
          title: CommonWidgetsHelper.buildBoldTitle(task.title),
          subtitle: CommonWidgetsHelper.buildInfoLines(
            '${AppConstants.TASK_TYPE_LABEL}${task.type}', // Muestra el tipo
            task.steps.isNotEmpty ? '${AppConstants.PASO_TITULO}${task.steps.first}' : 'Sin pasos',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit, // Llama al callback de edición
          ),
        ),
      ),
    );
  }

  static Widget buildSportsCard(Task task, int index) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: CommonWidgetsHelper.buildRoundedBorder().borderRadius!,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
          child: ClipRRect(
            borderRadius: CommonWidgetsHelper.buildRoundedBorder().borderRadius!,
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
                CommonWidgetsHelper.buildBoldTitle(task.title),
                CommonWidgetsHelper.buildSpacing(), // Reemplaza SizedBox
                Text(
                  AppConstants.PASO_TITULO,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CommonWidgetsHelper.buildSpacing(), // Reemplaza SizedBox
                ...task.steps.map((step) => Text(
                      '- $step',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )),
                CommonWidgetsHelper.buildSpacing(), // Reemplaza SizedBox
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

