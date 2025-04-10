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
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 8, // Sombra del Card
    shape: RoundedRectangleBorder(
      borderRadius: CommonWidgetsHelper.buildRoundedBorder().borderRadius!, // Usando buildRoundedBorder
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0), // Padding interno de 16 píxeles
      child: Center( // Centra todo el contenido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Asegura que el contenido esté centrado
          children: [
            // Imagen centrada
            Center(
              child: ClipRRect(
                borderRadius: CommonWidgetsHelper.buildRoundedBorder().borderRadius!, // Usando buildRoundedBorder
                child: Image.network(
                  'https://picsum.photos/200/300?random=$index',
                  height: 300, // Altura fija
                  width: 200,  // Ancho fijo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            CommonWidgetsHelper.buildSpacing(), // Espaciado

            // Título
            CommonWidgetsHelper.buildBoldTitle(task.title),

            CommonWidgetsHelper.buildSpacing(), // Espaciado

            // Pasos
            CommonWidgetsHelper.buildInfoLines(
              task.steps.isNotEmpty ? '- ${task.steps[0]}' : 'Sin pasos',
              task.steps.length > 1 ? '- ${task.steps[1]}' : null,
              task.steps.length > 2 ? '- ${task.steps[2]}' : null,
            ),

            CommonWidgetsHelper.buildSpacing(), // Espaciado

            // Fecha límite
            CommonWidgetsHelper.buildBoldFooter(
              '${AppConstants.FECHA_LIMITE}${task.deadline.toLocal()}',
            ),
          ],
        ),
      ),
    ),
  );
}
}

