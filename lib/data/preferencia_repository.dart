import 'package:flutter/foundation.dart';
import 'package:psiemens/api/service/preferencia_service.dart';
import 'package:psiemens/domain/preferencia.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:psiemens/data/base_repository.dart';

class PreferenciaRepository extends BaseRepository<Preferencia> {
  final PreferenciaService _preferenciaService = PreferenciaService();
  
  @override
  PreferenciaService get service => _preferenciaService;

  // Caché de preferencias para minimizar llamadas a la API
  Preferencia? _cachedPreferencias;

  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API usando la clase base
      _cachedPreferencias ??= await obtenerDatos(
        fetchFunction: () => _preferenciaService.getPreferencias().then((preferencia) => [preferencia]),
        cacheKey: 'preferencias',
      ).then((preferencias) => preferencias.isNotEmpty ? preferencias.first : Preferencia.empty());

      return _cachedPreferencias!.categoriasSeleccionadas;
    } catch (e) {
      debugPrint('Error al obtener categorías seleccionadas: $e');
      // En caso de error desconocido, devolver lista vacía para no romper la UI
      return [];
    }
  }
  /// Guarda las categorías seleccionadas para filtrar las noticias
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      // Si no hay caché o es la primera vez, obtener de la API
      _cachedPreferencias ??= await obtenerDatos(
        fetchFunction: () => _preferenciaService.getPreferencias().then((preferencia) => [preferencia]),
        cacheKey: 'preferencias',
      ).then((preferencias) => preferencias.isNotEmpty ? preferencias.first : Preferencia.empty());

      // Actualizar el objeto en caché
      _cachedPreferencias = Preferencia(categoriasSeleccionadas: categoriaIds);

      // Guardar en la API usando la operación de la clase base
      await ejecutarOperacion(
        operation: () => _preferenciaService.guardarPreferencias(_cachedPreferencias!),
        errorMessage: 'Error al guardar preferencias.',
      );
      
      // Invalidar caché
      limpiarCache();
    } catch (e) {
      debugPrint('Error al guardar categorías seleccionadas: $e');
      throw ApiException('Error al guardar preferencias: $e');
    }
  }
  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    validarNoVacio(categoriaId, 'ID de categoría');
    
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      if (!categorias.contains(categoriaId)) {
        categorias.add(categoriaId);
        await guardarCategoriasSeleccionadas(categorias);
      }
    } catch (e) {
      debugPrint('Error al agregar categoría: $e');
      throw ApiException('Error al agregar categoría: $e');
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    validarNoVacio(categoriaId, 'ID de categoría');
    
    try {
      final categorias = await obtenerCategoriasSeleccionadas();
      categorias.remove(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);
    } catch (e) {
      debugPrint('Error al eliminar categoría: $e');
      throw ApiException('Error al eliminar categoría: $e');
    }
  }
  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    try {
      await guardarCategoriasSeleccionadas([]);

      // Limpiar también la caché
      _cachedPreferencias = Preferencia.empty();
      limpiarCache();
    } catch (e) {
      debugPrint('Error al limpiar filtros: $e');
      throw ApiException('Error al limpiar filtros: $e');
    }
  }

  /// Limpia la caché para forzar una recarga desde la API
  @override
  void limpiarCache() {
    _cachedPreferencias = null;
    super.limpiarCache();
  }
}
