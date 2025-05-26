import 'package:psiemens/api/service/task_service.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/data/base_repository.dart';
import 'package:psiemens/domain/task.dart';
import 'package:psiemens/domain/task_cache_prefs.dart';
import 'package:psiemens/helpers/secure_storage_service.dart';
import 'package:psiemens/helpers/shared_preferences_service.dart';
import 'package:watch_it/watch_it.dart';

class TareasRepository extends BaseRepository<Tarea> {
  final TareaService _tareaService;
  final SecureStorageService _secureStorage;
  final SharedPreferencesService _sharedPreferences;

  TareasRepository({
    TareaService? tareaService,
    SecureStorageService? secureStorage,
    SharedPreferencesService? sharedPreferences,
  }) : _tareaService = tareaService ?? di<TareaService>(),
       _secureStorage = secureStorage ?? di<SecureStorageService>(),
       _sharedPreferences = sharedPreferences ?? di<SharedPreferencesService>() {
    _initUsuarioAutenticado();
  }

  // Definimos una clave constante para almacenar/recuperar las tareas en caché
  static const String _tareasCacheKey = 'tareas_cache_prefs';
  String? _usuarioAutenticado;

  // Funciones auxiliares para mapear objetos
  TareaCachePrefs _fromJson(Map<String, dynamic> json) =>
      TareaCachePrefsMapper.fromMap(json);
  Map<String, dynamic> _toJson(TareaCachePrefs cache) => cache.toMap();

  Future<String> get usuarioAutenticado async {
    if (_usuarioAutenticado == null) {
      _usuarioAutenticado = await _secureStorage.getUserEmail();
      if (_usuarioAutenticado == null) {
        throw Exception('Usuario no autenticado');
      }
    }
    return _usuarioAutenticado!;
  }

  //Trae el usuario autenticado desde el secure storage
  Future<void> _initUsuarioAutenticado() async {
    try {
      await usuarioAutenticado; // Esto inicializará el usuario
    } catch (e) {
      // Manejar el error si es necesario
    }
  }

  /// Valida los campos de la entidad Tarea
  @override
  void validarEntidad(Tarea tarea) {
    validarNoVacio(tarea.titulo, AppConstants.tituloTarea);
    //agregar validaciones que correspondan
  }

  /// Obtiene el contenido de la caché actual
  Future<TareaCachePrefs?> _obtenerCache({
    TareaCachePrefs? defaultValue,
  }) async {
    return _sharedPreferences.getObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      fromJson: _fromJson,
      defaultValue: defaultValue,
    );
  }

  /// Guarda una lista de tareas en la caché
  Future<bool> _guardarEnCache(List<Tarea> tareas) async {
    return _sharedPreferences.saveObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      value: TareaCachePrefs(usuario: _usuarioAutenticado!, misTareas: tareas),
      toJson: _toJson,
    );
  }

  /// Actualiza la caché usando una función de transformación
  ///
  /// [updateFn]: Función que recibe la caché actual y retorna una nueva versión
  /// La caché siempre debe existir cuando se llama a este método, ya que se inicializa en obtenerTareas
  Future<bool> _actualizarCache(
    TareaCachePrefs Function(TareaCachePrefs cache) updateFn,
  ) async {
    return _sharedPreferences.updateObject<TareaCachePrefs>(
      key: _tareasCacheKey,
      updateFn:
          (current) => updateFn(current!), // Asumimos que current nunca es nulo
      fromJson: _fromJson,
      toJson: _toJson,
    );
  }

  /// Obtiene todas las tareas del usuario desde la API
  Future<List<Tarea>> obtenerTareasUsuario(String usuario) async {
    List<Tarea> tareasUsuario = await manejarExcepcion(
      () => _tareaService.obtenerTareasUsuario(usuario),
      mensajeError: AppConstants.mensajeError,
    );
    return tareasUsuario;
  }

  /// Obtiene todas las tareas con estrategia cache-first
  Future<List<Tarea>> obtenerTareas({bool forzarRecarga = false}) async {
    return manejarExcepcion(() async {
      List<Tarea> tareas = [];

      // Obtenemos el objeto desde SharedPreferences con un valor por defecto
      TareaCachePrefs? tareasCache = await _obtenerCache(
        defaultValue: TareaCachePrefs(
          usuario: _usuarioAutenticado!,
          misTareas: tareas,
        ),
      );

      // Si no coincide el usuario actual con el de la caché, invalidamos la caché
      if (_usuarioAutenticado != tareasCache?.usuario) {
        await _sharedPreferences.remove(_tareasCacheKey);
        tareasCache = null;
      }

      // Si se fuerza la recarga, ignoramos la caché
      // Si no esta forzada la recarga y tenemos datos en caché, los usamos
      if (forzarRecarga != true && tareasCache != null) {
        tareas = tareasCache.misTareas;
      } else {
        // Si no hay caché, cargamos desde la API
        tareas = await obtenerTareasUsuario(_usuarioAutenticado!);
        await _guardarEnCache(tareas);
      }
      return tareas;
    }, mensajeError: AppConstants.mensajeError);
  }

  /// Agrega una nueva tarea y actualiza la caché
  Future<Tarea> agregarTarea(Tarea tarea) async {
    return manejarExcepcion(() async {
      validarEntidad(tarea);

      // Verificamos si ya tiene email, de lo contrario lo obtenemos
      final tareaConEmail =
          (tarea.usuario.isEmpty)
              ? tarea.copyWith(usuario: _usuarioAutenticado!)
              : tarea;

      // Enviamos la tarea a la API
      final nuevaTarea = await _tareaService.crearTarea(
        tareaConEmail,
      ); // Actualizamos la caché usando el método auxiliar
      await _actualizarCache(
        (cache) => cache.copyWith(misTareas: [...cache.misTareas, nuevaTarea]),
      );
      return nuevaTarea;
    }, mensajeError: AppConstants.errorCrear);
  }

  /// Elimina una tarea y actualiza la caché
  Future<void> eliminarTarea(String tareaId) async {
    return manejarExcepcion(() async {
      validarId(tareaId);
      await _tareaService.eliminarTarea(
        tareaId,
      ); // Actualizamos la caché en un solo paso usando el método auxiliar
      await _actualizarCache((cache) {
        // Filtramos la tarea eliminada
        final tareasFiltradas =
            cache.misTareas.where((t) => t.id != tareaId).toList();

        // Creamos una nueva instancia con la lista filtrada
        return cache.copyWith(misTareas: tareasFiltradas);
      });
    }, mensajeError: AppConstants.errorEliminar);
  }

  /// Actualiza una tarea existente y la caché
  Future<Tarea> actualizarTarea(Tarea tarea) async {
    return manejarExcepcion(() async {
      validarId(tarea.id);
      validarEntidad(tarea);

      // Enviamos la tarea a la API
      final tareaActualizada = await _tareaService.actualizarTarea(
        tarea,
      ); // Actualizamos la caché en un solo paso usando el método auxiliar
      await _actualizarCache((cache) {
        // Creamos una nueva lista reemplazando la tarea actualizada
        final nuevasTareas =
            cache.misTareas.map((t) {
              return t.id == tarea.id ? tareaActualizada : t;
            }).toList();

        // Creamos una nueva instancia con la lista actualizada
        return cache.copyWith(misTareas: nuevasTareas);
      });
      return tareaActualizada;
    }, mensajeError: AppConstants.errorActualizar);
  }
}
