import 'package:psiemens/api/service/base_service.dart';
import 'package:psiemens/domain/preferencia.dart';
import 'package:flutter/foundation.dart';

/// Servicio para gestionar las operaciones relacionadas con preferencias de usuario
/// Utiliza BaseService para las operaciones HTTP y proporciona datos mock
class PreferenciaService {
  final BaseService _baseService;
  
  // Datos mock para las preferencias
  final Map<String, dynamic> _mockPreferencias = {
    "categoriasSeleccionadas": ["Tecnología", "Deportes"],
    "mostrarFavoritos": false,
    "palabraClave": null,
    "fechaDesde": null,
    "fechaHasta": null,
    "ordenarPor": "fecha",
    "ascendente": false,
  };
  
  /// Constructor que inicializa el BaseService
  PreferenciaService({BaseService? baseService}) 
      : _baseService = baseService ?? BaseService();
  
  /// Obtiene las preferencias del usuario
  /// En un entorno real, obtendría las preferencias del servidor
  /// Actualmente devuelve datos simulados
  Future<Map<String, dynamic>> getPreferencias() async {
    try {
      // En un entorno real, se usaría:
      // return await _baseService.get('preferencias');
      
      // Por ahora, simular un retraso y devolver datos mock
      await Future.delayed(const Duration(milliseconds: 300));
      return _mockPreferencias;
    } catch (e) {
      debugPrint('Error al obtener preferencias: $e');
      // En caso de error, devolver preferencias por defecto
      return _mockPreferencias;
    }
  }
  
  /// Guarda las preferencias del usuario
  /// En un entorno real, guardaría las preferencias en el servidor
  /// Actualmente actualiza los datos simulados
  Future<bool> savePreferencias(Map<String, dynamic> preferencias) async {
    try {
      // En un entorno real, se usaría:
      // await _baseService.post('preferencias', data: preferencias);
      
      // Por ahora, simular un retraso y actualizar datos mock
      await Future.delayed(const Duration(milliseconds: 300));
      _mockPreferencias.addAll(preferencias);
      return true;
    } catch (e) {
      debugPrint('Error al guardar preferencias: $e');
      return false;
    }
  }
}
