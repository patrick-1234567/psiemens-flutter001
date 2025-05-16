import 'package:shared_preferences/shared_preferences.dart';
import 'package:psiemens/api/service/preferencia_service.dart';
import 'package:psiemens/domain/preferencia.dart';

/// Repositorio para gestionar las preferencias del usuario
/// Combina almacenamiento local (SharedPreferences) con servicio remoto
class PreferenciaRepository {
  static const String _keyCategoriasSeleccionadas = 'categorias_seleccionadas';
  final PreferenciaService _preferenciaService;
  
  PreferenciaRepository({PreferenciaService? preferenciaService})
      : _preferenciaService = preferenciaService ?? PreferenciaService();
  
  /// Obtiene las categorías seleccionadas para filtrar las noticias
  Future<List<String>> obtenerCategoriasSeleccionadas() async {
    try {
      // Primero intentamos obtener las preferencias del servicio
      final preferencias = await _preferenciaService.getPreferencias();
      final categoriasRemote = preferencias['categoriasSeleccionadas'] as List<dynamic>?;
      
      if (categoriasRemote != null) {
        // Convertir de List<dynamic> a List<String>
        final categoriasString = categoriasRemote.map((e) => e.toString()).toList();
        // También actualizamos las preferencias locales para mantener sincronía
        _guardarCategoriasSeleccionadasLocal(categoriasString);
        return categoriasString;
      }
    } catch (e) {
      // Si falla, caemos en la versión local
    }
    
    // Si no pudimos obtener del servicio o no había datos, usamos local
    return _obtenerCategoriasSeleccionadasLocal();
  }
  
  /// Obtiene las categorías seleccionadas desde el almacenamiento local
  Future<List<String>> _obtenerCategoriasSeleccionadasLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCategoriasSeleccionadas) ?? [];
  }
  
  /// Guarda las categorías seleccionadas en el almacenamiento local
  Future<void> _guardarCategoriasSeleccionadasLocal(List<String> categoriaIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCategoriasSeleccionadas, categoriaIds);
  }

  /// Guarda las categorías seleccionadas para filtrar las noticias
  /// Intenta guardar tanto en el servicio remoto como localmente
  Future<void> guardarCategoriasSeleccionadas(List<String> categoriaIds) async {
    try {
      // Guardamos en el servicio remoto
      await _preferenciaService.savePreferencias({
        'categoriasSeleccionadas': categoriaIds
      });
    } catch (e) {
      // Si falla, al menos guardamos localmente
    }
    
    // Siempre guardamos localmente como respaldo
    await _guardarCategoriasSeleccionadasLocal(categoriaIds);
  }

  /// Añade una categoría a las categorías seleccionadas
  Future<void> agregarCategoriaFiltro(String categoriaId) async {
    final categorias = await obtenerCategoriasSeleccionadas();
    if (!categorias.contains(categoriaId)) {
      categorias.add(categoriaId);
      await guardarCategoriasSeleccionadas(categorias);
    }
  }

  /// Elimina una categoría de las categorías seleccionadas
  Future<void> eliminarCategoriaFiltro(String categoriaId) async {
    final categorias = await obtenerCategoriasSeleccionadas();
    categorias.remove(categoriaId);
    await guardarCategoriasSeleccionadas(categorias);
  }

  /// Limpia todas las categorías seleccionadas
  Future<void> limpiarFiltrosCategorias() async {
    await guardarCategoriasSeleccionadas([]);
  }
  
  /// Obtiene todas las preferencias del usuario
  Future<Map<String, dynamic>> obtenerPreferencias() async {
    return await _preferenciaService.getPreferencias();
  }
  
  /// Guarda todas las preferencias del usuario
  Future<bool> guardarPreferencias(Map<String, dynamic> preferencias) async {
    return await _preferenciaService.savePreferencias(preferencias);
  }
}