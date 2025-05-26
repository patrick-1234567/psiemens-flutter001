import 'package:dart_mappable/dart_mappable.dart';
import 'package:psiemens/domain/task.dart';

part 'task_cache_prefs.mapper.dart';

@MappableClass()
class TareaCachePrefs with TareaCachePrefsMappable {
  final String usuario;
  final List<Tarea> misTareas;

  const TareaCachePrefs({
    required this.usuario,
    required this.misTareas,
  });
}