import 'package:flutter/material.dart';
import 'package:psiemens/api/service/noticia_service.dart';

class EliminarNoticiaPopup {
  static Future<void> mostrarPopup({
    required BuildContext context,
    required String noticiaId,
    required VoidCallback onNoticiaEliminada,
  }) async {
    final NoticiaService noticiaService = NoticiaService();

    Future<void> eliminarNoticia() async {
      try {
        await noticiaService.eliminarNoticia(noticiaId);

        // Muestra un mensaje de éxito
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Noticia eliminada exitosamente')),
        );

        // Llama al callback para actualizar la lista de noticias
        onNoticiaEliminada();

        // Cierra el popup
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // Muestra un mensaje de error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la noticia: $e')),
        );
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Noticia'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar esta noticia? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: eliminarNoticia,
              child: const Text('Eliminar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Botón de color rojo
              ),
            ),
          ],
        );
      },
    );
  }
}