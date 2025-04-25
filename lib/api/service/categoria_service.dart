/// services/categoria_service.dart
import 'package:psiemens/data/categoria_repository.dart'; // Importa tu repositorio
import 'package:psiemens/domain/categoria.dart'; // Importa tu entidad Categoria
import 'package:flutter/foundation.dart'; // Para debugPrint

class CategoriaService {
  // Inyecta la dependencia del repositorio
  final CategoriaRepository _categoriaRepository;

  // Constructor que recibe la instancia del repositorio
  CategoriaService(this._categoriaRepository);

  /// Obtiene la lista completa de categorías desde el repositorio.
  Future<List<Categoria>> obtenerCategorias() async {
    try {
      // Llama al método del repositorio para obtener los datos
      final categorias = await _categoriaRepository.getCategorias();
      return categorias;
    } catch (e) {
      // Puedes añadir lógica de logging o manejo de errores específico del servicio aquí
      debugPrint('Error en CategoriaService al obtener categorías: $e');
      // Relanza la excepción para que la capa superior (UI, BLoC) pueda manejarla
      rethrow;
    }
  }

  Future<void> crearNuevaCategoria(Map<String, dynamic> categoriaData) async {
    try {
      // Llama al método del repositorio para crear la categoría
      await _categoriaRepository.crearCategoria(categoriaData);
      debugPrint('Categoría creada exitosamente.');
    } catch (e) {
      debugPrint('Error en CategoriaService al crear categoría: $e');
      rethrow;
    }
  }

  Future<void> actualizarCategoria(String id, Map<String, dynamic> categoriaData) async {
    try {
      // Llama al método del repositorio para editar la categoría
      await _categoriaRepository.editarCategoria(id, categoriaData);
      debugPrint('Categoría con ID $id actualizada exitosamente.');
    } catch (e) {
      debugPrint('Error en CategoriaService al actualizar categoría $id: $e');
      rethrow;
    }
  }

  Future<void> borrarCategoria(String id) async {
    try {
      // Llama al método del repositorio para eliminar la categoría
      await _categoriaRepository.eliminarCategoria(id);
      debugPrint('Categoría con ID $id eliminada exitosamente.');
    } catch (e) {
      debugPrint('Error en CategoriaService al eliminar categoría $id: $e');
      rethrow;
    }
  }
}
