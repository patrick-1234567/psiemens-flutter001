import 'package:dart_mappable/dart_mappable.dart';
import 'package:psiemens/domain/task.dart';

part 'task_cache_prefs.mapper.dart';

/// TareaCachePrefs almacena la lista de tareas (cada una con el campo 'completada') para un usuario.
@MappableClass()
class TareaCachePrefs with TareaCachePrefsMappable {
  final String usuario;
  final List<Tarea> misTareas; // Cada Tarea ahora tiene el campo 'completada'

  const TareaCachePrefs({
    required this.usuario,
    required this.misTareas,
  });
}