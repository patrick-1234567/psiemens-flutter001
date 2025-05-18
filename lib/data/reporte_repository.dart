import 'package:psiemens/api/service/reporte_service.dart';
import 'package:psiemens/domain/reporte.dart';
import 'package:psiemens/exceptions/api_exception.dart';

class ReporteRepository {
  final ReporteService _reporteService = ReporteService();

  // Obtener todos los reportes
  Future<List<Reporte>> obtenerReportes() async {
    try {
      return await _reporteService.getReportes();
    } on ApiException catch (e) {
      throw Exception('Error al obtener reportes: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener reportes: ${e.toString()}');
    }
  }

  // Crear un nuevo reporte
  Future<Reporte?> crearReporte({
    required String noticiaId,
    required MotivoReporte motivo,
  }) async {
    try {
      return await _reporteService.crearReporte(
        noticiaId: noticiaId,
        motivo: motivo,
      );
    } on ApiException catch (e) {
      throw Exception('Error al crear reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error al crear reporte: ${e.toString()}');
    }
  }

  // Obtener reportes por id de noticia
  Future<List<Reporte>> obtenerReportesPorNoticia(String noticiaId) async {
    try {
      return await _reporteService.getReportesPorNoticia(noticiaId);
    } on ApiException catch (e) {
      throw Exception('Error al obtener reportes por noticia: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener reportes por noticia: ${e.toString()}');
    }
  }

  // Eliminar un reporte
  Future<void> eliminarReporte(String reporteId) async {
    try {
      await _reporteService.eliminarReporte(reporteId);
    } on ApiException catch (e) {
      throw Exception('Error al eliminar reporte: ${e.message}');
    } catch (e) {
      throw Exception('Error al eliminar reporte: ${e.toString()}');
    }
  }
}