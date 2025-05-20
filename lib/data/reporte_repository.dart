import 'package:psiemens/api/service/reporte_service.dart';
import 'package:psiemens/domain/reporte.dart';
import 'package:psiemens/data/base_repository.dart';
import 'package:flutter/foundation.dart';

class ReporteRepository extends BaseRepository<Reporte> {
  final ReporteService _reporteService = ReporteService();
  
  @override
  ReporteService get service => _reporteService;

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    return obtenerDatos(
      fetchFunction: () => _reporteService.getReportes(),
      cacheKey: 'reportes',
    );
  }

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    validarNoVacio(noticiaId, 'ID de la noticia');
    
    try {
      final reporte = await _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      );
      // Invalidar caché tras crear un reporte
      limpiarCache();
      return reporte;
    } catch (e) {
      debugPrint('Error al crear reporte: $e');
      return null;
    }
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    validarNoVacio(noticiaId, 'ID de la noticia');
    
    return obtenerDatos(
      fetchFunction: () => _reporteService.getReportesPorNoticia(noticiaId),
      cacheKey: 'reportes_noticia_$noticiaId',
    );
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) async {
    validarNoVacio(reporteId, 'ID del reporte');
    
    await ejecutarOperacion(
      operation: () => _reporteService.eliminarReporte(reporteId),
      errorMessage: 'Error al eliminar reporte.',
    );
  }
}