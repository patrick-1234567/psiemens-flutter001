import 'package:flutter/material.dart';
import '../constants.dart';

class CommonWidgetsHelper {
  // Método para construir un título en negrita con tamaño 20
  static Widget buildBoldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Método para construir líneas de información (hasta 3 líneas)
  static Widget buildInfoLines(String line1, [String? line2, String? line3]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line1, style: const TextStyle(fontSize: 14, color: Colors.black)),
        if (line2 != null)
          Text(line2, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        if (line3 != null)
          Text(line3, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // Método para construir un pie de página en negrita
  static Widget buildBoldFooter(String footer) {
    return Text(
      footer,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  // Método para construir un SizedBox con altura 8
  static Widget buildSpacing() {
    return const SizedBox(height: 8);
  }

  // Método para construir un borde redondeado
  static BoxDecoration buildRoundedBorder() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  // Método para construir un diseño básico de tarea con ListTile
  static Widget buildTaskTile(String title, String type, String firstStep) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: buildBoldTitle(title),
      subtitle: buildInfoLines(
        '${AppConstants.TASK_TYPE_LABEL}$type',
        '${AppConstants.PASO_TITULO}$firstStep',
      ),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}