/// screens/categoria_screen.dart
import 'package:flutter/material.dart';
import 'package:psiemens/domain/categoria.dart'; // Asegúrate que la ruta sea correcta
import 'package:psiemens/api/service/categoria_service.dart'; // Asegúrate que la ruta sea correcta
import 'package:psiemens/data/categoria_repository.dart';
import 'package:psiemens/helpers/categoria_dialogs.dart'; // Necesario para instanciar el servicio directamente (si no usas DI)

class CategoriaScreen extends StatefulWidget {
  const CategoriaScreen({super.key});

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  // --- State Variables ---
  late Future<List<Categoria>> _categoriasFuture;
  // Asume que obtienes el servicio de alguna manera (Inyección de Dependencias es lo ideal)
  // Ejemplo simple (NO recomendado para producción sin DI):
  late final CategoriaService _categoriaService =
      CategoriaService(CategoriaRepository());
  // Ejemplo con GetIt (si lo tienes configurado):
  // final CategoriaService _categoriaService = GetIt.instance<CategoriaService>();

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  /// Carga las categorías usando el servicio.
  void _loadCategorias() {
    // Asigna el Future directamente a la variable de estado
    _categoriasFuture = _categoriaService.obtenerCategorias();
  }

  /// Refresca la lista de categorías.
  void _refreshCategorias() {
    setState(() {
      // Vuelve a llamar al servicio para obtener los datos más recientes
      _categoriasFuture = _categoriaService.obtenerCategorias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], 
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Colors.blue,
        actions: [
          // Botón para refrescar manualmente
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCategorias,
            tooltip: 'Refrescar',
          ),
        ],
      ),
      body: FutureBuilder<List<Categoria>>(
        future: _categoriasFuture,
        builder: (context, snapshot) {
          // --- Caso: Cargando ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- Caso: Error ---
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error al cargar categorías: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refreshCategorias,
                      child: const Text('Intentar de nuevo'),
                    )
                  ],
                ),
              ),
            );
          }
          // --- Caso: Sin datos ---
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay categorías disponibles.'),
            );
          }
          // --- Caso: Datos cargados ---
          else {
            final categorias = snapshot.data!;
            return ListView.builder(
  itemCount: categorias.length,
  itemBuilder: (context, index) {
    final categoria = categorias[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: _buildCategoryImage(categoria.imagenUrl), // Widget para la imagen
        title: Text(
          categoria.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          categoria.descripcion ?? 'Sin descripción', // Manejo de null
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Editar categoría',
              onPressed: () {
                CategoriaDialogs.editarCategoria(
                  context: context,
                  categoria: categoria,
                  categoriaService: _categoriaService,
                  onSuccess: _refreshCategorias,
                ); // Llama al método para editar
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Eliminar categoría',
              onPressed: () {
                CategoriaDialogs.eliminarCategoria(
                  context: context,
                  categoria: categoria,
                  categoriaService: _categoriaService,
                  onSuccess: _refreshCategorias,
                ); // Llama al método para eliminar
              },
            ),
          ],
        ),
      ),
    );
  },
);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        CategoriaDialogs.agregarCategoria(
          context: context,
          categoriaService: _categoriaService,
          onSuccess: _refreshCategorias,
        ); // Llama al método para agregar una categoría
       }, // Llama al método para agregar una categoría
      child: const Icon(Icons.add),
      tooltip: 'Agregar categoría',
    ),
  );
}

  /// Construye el widget de imagen para la categoría.
  Widget _buildCategoryImage(String? imageUrl) {
    // Si no hay URL o está vacía, muestra un icono placeholder
    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar( // Usar CircleAvatar para un aspecto uniforme
        radius: 25, // Ajusta el tamaño según necesites
        backgroundColor: Colors.grey, // Color de fondo para el placeholder
        child: Icon(Icons.category, color: Colors.white), // Icono genérico
      );
    }

    // Intenta cargar la imagen desde la red
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200], // Fondo mientras carga o si falla
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) {
        // Manejo opcional si la imagen no carga (ya tiene un fondo gris)
        debugPrint("Error cargando imagen: $exception");
      },
    );
  }
}
