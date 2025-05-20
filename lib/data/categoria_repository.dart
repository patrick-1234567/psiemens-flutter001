import 'package:psiemens/api/service/categoria_service.dart';
import 'package:psiemens/domain/categoria.dart';
import 'package:psiemens/data/base_repository.dart';
import 'package:flutter/foundation.dart';

class CategoriaRepository extends BaseRepository<Categoria> {
  // Servicio para acceder a los datos de categorías
  final CategoriaService _categoriaService = CategoriaService();
  
  @override
  CategoriaService get service => _categoriaService;

  /// Obtiene la lista completa de categorías con caché y manejo de errores.
  Future<List<Categoria>> obtenerCategorias() async {
    return obtenerDatos(
      fetchFunction: () => _categoriaService.getCategorias(),
      cacheKey: 'categorias',
    );
  }

  /// Crea una nueva categoría
  Future<void> crearCategoria(Map<String, dynamic> categoriaData) async {
    await ejecutarOperacion(
      operation: () => _categoriaService.crearCategoria(categoriaData),
      errorMessage: 'Error al crear categoría.',
    );
    debugPrint('Categoría creada exitosamente.');
  }

  /// Actualiza una categoría existente
  Future<void> actualizarCategoria(String id, Map<String, dynamic> categoriaData) async {
    validarNoVacio(id, 'ID de la categoría');
    
    await ejecutarOperacion(
      operation: () => _categoriaService.editarCategoria(id, categoriaData),
      errorMessage: 'Error al actualizar categoría.',
    );
    debugPrint('Categoría con ID $id actualizada exitosamente.');
  }

  /// Elimina una categoría
  Future<void> eliminarCategoria(String id) async {
    validarNoVacio(id, 'ID de la categoría');
    
    await ejecutarOperacion(
      operation: () => _categoriaService.eliminarCategoria(id),
      errorMessage: 'Error al eliminar categoría.',
    );
    debugPrint('Categoría con ID $id eliminada exitosamente.');
  }
}