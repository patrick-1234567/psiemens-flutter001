import 'package:flutter/material.dart';
import 'package:psiemens/domain/categoria.dart';
import 'package:psiemens/data/categoria_repository.dart';

class CategoriaDialogs {
  static void editarCategoria({
    required BuildContext context,
    required Categoria categoria,
    required CategoriaRepository categoriaRepository,
    required VoidCallback onSuccess,
  }) {
    final TextEditingController nombreController = TextEditingController(text: categoria.nombre);
    final TextEditingController descripcionController = TextEditingController(text: categoria.descripcion);
    final TextEditingController imagenUrlController = TextEditingController(text: categoria.imagenUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Categoría'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(labelText: 'URL de la imagen'),
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
              onPressed: () async {
                try {
                  await categoriaRepository.actualizarCategoria(
                    categoria.id!,
                    {
                      'nombre': nombreController.text,
                      'descripcion': descripcionController.text,
                      'imagenUrl': imagenUrlController.text,
                    },
                  );
                  Navigator.pop(context);
                  onSuccess(); // Llama al callback para refrescar la lista
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Categoría actualizada')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar categoría: $e')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  static void eliminarCategoria({
    required BuildContext context,
    required Categoria categoria,
    required CategoriaRepository categoriaService,
    required VoidCallback onSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Categoría'),
          content: Text('¿Estás seguro de que deseas eliminar la categoría "${categoria.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await categoriaService.borrarCategoria(categoria.id!);
                  Navigator.pop(context);
                  onSuccess(); // Llama al callback para refrescar la lista
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Categoría eliminada')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar categoría: $e')),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  static void agregarCategoria({
    required BuildContext context,
    required CategoriaRepository categoriaService,
    required VoidCallback onSuccess,
  }) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController imagenUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Categoría'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: imagenUrlController,
                    decoration: const InputDecoration(labelText: 'URL de la imagen'),
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
              onPressed: () async {
                try {
                  await categoriaService.crearNuevaCategoria({
                    'nombre': nombreController.text,
                    'descripcion': descripcionController.text,
                    'imagenUrl': imagenUrlController.text,
                  });
                  Navigator.pop(context);
                  onSuccess(); // Llama al callback para refrescar la lista
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Categoría agregada')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al agregar categoría: $e')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}