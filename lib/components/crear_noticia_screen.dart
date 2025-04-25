import 'package:flutter/material.dart';
import 'package:psiemens/api/service/noticia_service.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:psiemens/domain/categoria.dart';
import 'package:psiemens/data/categoria_repository.dart';
import 'package:psiemens/constants.dart';

class CrearNoticiaPopup {
  static Future<void> mostrarPopup(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final NoticiaService noticiaService = NoticiaService();

    // Controladores para los campos del formulario
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController fuenteController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController imagenUrlController = TextEditingController();

    DateTime? fechaSeleccionada;
    String? categoriaSeleccionada;

    List<Categoria> categorias = [];
    try {
      final categoriaRepository = CategoriaRepository();
      categorias = await categoriaRepository.getCategorias();
    } catch (e) {
      // Manejo de errores al cargar categorías
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }

    Future<void> guardarNoticia() async {
      if (formKey.currentState!.validate()) {
        try {
          // Convierte la fecha seleccionada al formato ISO 8601
          final fechaIso8601 = fechaSeleccionada?.toUtc().toIso8601String();
  
          await noticiaService.crearNoticia(
            titulo: tituloController.text,
            descripcion: descripcionController.text,
            fuente: fuenteController.text,
            publicadaEl: fechaIso8601 ?? '',
            urlImagen: imagenUrlController.text,
            categoriaId: categoriaSeleccionada ?? CategoriaConstantes.defaultCategoriaId,
          );

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Noticia creada')),
          );

          // ignore: use_build_context_synchronously
          Navigator.pop(context); // Cierra el popup
        } catch (e) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al crear la noticia: $e')),
          );
        }
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Noticia'),
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
                    readOnly: true, // Hace que el campo sea de solo lectura
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
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: categoriaSeleccionada,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      categoriaSeleccionada = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una categoría';
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
