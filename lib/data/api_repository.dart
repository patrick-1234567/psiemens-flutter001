
import 'package:psiemens/data/base_repository.dart';

/// Repositorio para operaciones API básicas
class ApiRepository extends BaseRepository<dynamic> {
  @override
  void validarEntidad(dynamic entidad) {
    // Este repositorio no tiene una entidad específica para validar
  }
  
  /// Obtiene una lista de pasos para una tarea
  Future<List<String>> obtenerPasos(String titulo, DateTime fechaLimite, int n) async {
    return manejarExcepcion(() async {
      // Validar los parámetros de entrada
      validarNoVacio(titulo, 'título de la tarea');
      
      // Validar que la fecha no esté en el pasado
      if (fechaLimite.isBefore(DateTime.now())) {
        throw ArgumentError('La fecha límite no puede estar en el pasado');
      }
      
      // Formatear la fecha manualmente
      final int numeroDePasos = n.clamp(4, 10);
      final String fechaFormateada =
          '${fechaLimite.day.toString().padLeft(2, '0')}/${fechaLimite.month.toString().padLeft(2, '0')}/${fechaLimite.year}';
          
      // Generar pasos personalizados con la fecha límite
      return Future.value(List.generate(
        numeroDePasos,
        (index) => 'Paso ${index + 1}: Acción antes del $fechaFormateada',
      ));
    }, mensajeError: 'Error al generar pasos para la tarea');
  }
}

