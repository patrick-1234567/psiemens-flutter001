import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psiemens/api/service/noticia_service.dart';

class NoticiaModal {
  static Future<void> mostrarModal({
    required BuildContext context,
    Map<String, dynamic>? noticia, // Datos de la noticia para editar
    required VoidCallback onSave, // Callback para guardar
  }) async {
    final formKey = GlobalKey<FormState>();
    final NoticiaService noticiaService = NoticiaService();

    // Controladores para los campos del formulario
    final TextEditingController tituloController = TextEditingController(
      text: noticia?['titulo'] ?? '',
    );
    final TextEditingController descripcionController = TextEditingController(
      text: noticia?['descripcion'] ?? '',
    );
    final TextEditingController fuenteController = TextEditingController(
      text: noticia?['fuente'] ?? '',
    );
    final TextEditingController fechaController = TextEditingController(
      text: noticia?['publicadaEl'] ?? '',
    );
    final TextEditingController imagenUrlController = TextEditingController(
      text: noticia?['urlImagen'] ?? '',
    );

    DateTime? fechaSeleccionada =
        noticia != null
            ? DateTime.tryParse(noticia['publicadaEl'] ?? '')
            : null;

    Future<void> guardarNoticia() async {
      if (formKey.currentState!.validate()) {
        try {
          // Convierte la fecha seleccionada al formato ISO 8601
          final fechaIso8601 = fechaSeleccionada?.toUtc().toIso8601String();

          if (noticia == null) {
            // Crear nueva noticia
            await noticiaService.crearNoticia(
              titulo: tituloController.text,
              descripcion: descripcionController.text,
              fuente: fuenteController.text,
              publicadaEl: fechaIso8601 ?? '',
              urlImagen: imagenUrlController.text,
            );
          } else {
            // Editar noticia existente
            await noticiaService.editarNoticia(
              id: noticia['_id'],
              titulo: tituloController.text,
              descripcion: descripcionController.text,
              fuente: fuenteController.text,
              publicadaEl: fechaIso8601 ?? '',
              urlImagen: imagenUrlController.text,
            );
          }

          // Muestra un mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                noticia == null
                    ? 'Noticia creada exitosamente'
                    : 'Noticia editada exitosamente',
              ),
            ),
          );

          // Llama al callback para actualizar la lista de noticias
          onSave();

          // Cierra el modal
          Navigator.pop(context);
        } catch (e) {
          // Muestra un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la noticia: $e')),
          );
        }
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(noticia == null ? 'Crear Noticia' : 'Editar Noticia'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: fuenteController,
                    decoration: const InputDecoration(labelText: 'Fuente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una fuente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: fechaController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de publicación (YYYY-MM-DD)',
                      hintText: 'Seleccionar Fecha',
                    ),
                    onTap: () async {
                      DateTime? nuevaFecha = await showDatePicker(
                        context: context,
                        initialDate: fechaSeleccionada ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (nuevaFecha != null) {
                        fechaSeleccionada = nuevaFecha;
                        fechaController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(nuevaFecha); // Formatea la fecha
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una fecha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de la imagen',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una URL de imagen';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: guardarNoticia,
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}