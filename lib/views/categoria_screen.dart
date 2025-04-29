import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/categorias/categorias_bloc.dart';
import 'package:psiemens/components/categoria_dialogs.dart';

class CategoriaScreen extends StatelessWidget {
  const CategoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CategoriasBloc>().add(RefrescarCategoriasEvent());
            },
            tooltip: 'Refrescar',
          ),
        ],
      ),
      body: BlocBuilder<CategoriasBloc, CategoriasState>(
        builder: (context, state) {
          if (state is CategoriasCargando) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error al cargar categorías: ${state.mensaje}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CategoriasBloc>().add(CargarCategoriasEvent());
                      },
                      child: const Text('Intentar de nuevo'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CategoriasVacias) {
            return const Center(
              child: Text('No hay categorías disponibles.'),
            );
          } else if (state is CategoriasCargadas) {
            final categorias = state.categorias;
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: _buildCategoryImage(categoria.imagenUrl),
                    title: Text(
                      categoria.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      categoria.descripcion ?? 'Sin descripción',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Editar categoría',
                          onPressed: () {
                            final categoriaRepository = context.read<CategoriasBloc>().categoriaRepository;
                            CategoriaDialogs.editarCategoria(
                              context: context,
                              categoria: categoria,
                              categoriaRepository: categoriaRepository,
                              onSuccess: () {
                                context.read<CategoriasBloc>().add(RefrescarCategoriasEvent());
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar categoría',
                          onPressed: () {
                            final categoriaRepository = context.read<CategoriasBloc>().categoriaRepository;
                            CategoriaDialogs.eliminarCategoria(
                              context: context,
                              categoria: categoria,
                              categoriaService: categoriaRepository,
                              onSuccess: () {
                                context.read<CategoriasBloc>().add(RefrescarCategoriasEvent());
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final categoriaRepository = context.read<CategoriasBloc>().categoriaRepository;
          CategoriaDialogs.agregarCategoria(
            context: context,
            categoriaService: categoriaRepository,
            onSuccess: () {
              context.read<CategoriasBloc>().add(RefrescarCategoriasEvent());
            },
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Agregar categoría',
      ),
    );
  }

  Widget _buildCategoryImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey,
        child: Icon(Icons.category, color: Colors.white),
      );
    }

    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200],
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint("Error cargando imagen: $exception");
      },
    );
  }
}