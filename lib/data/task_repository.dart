import 'package:psiemens/domain/task.dart';
import 'package:psiemens/data/api_repository.dart'; 
import 'package:psiemens/data/base_repository.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'dart:math';
import 'dart:async';

class TaskRepository extends CacheableRepository<Task> {
  final ApiRepository apiRepository = ApiRepository();
  final Random random = Random();
  
  // Caché por páginas para evitar recargar tareas ya obtenidas
  final Map<String, List<Task>> _tareasPaginadas = {};
  
  @override
  void validarEntidad(Task task) {
    validarNoVacio(task.titulo, 'título de la tarea');
    validarNoVacio(task.descripcion, 'descripción de la tarea');
    validarNoVacio(task.tipo, 'tipo de la tarea');
    
    // Validar que la fecha límite no esté en el pasado
    if (task.fechaLimite.isBefore(DateTime.now())) {
      throw ApiException('La fecha límite no puede estar en el pasado', statusCode: 400);
    }
  }
  
  @override
  Future<List<Task>> cargarDatos() async {
    // Simular delay de carga de datos
    await Future.delayed(const Duration(seconds: 2));
    
    return [
      Task(
        titulo: 'Tarea 1',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 1',
        fechaLimite: DateTime(2025, 4, 10),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 2',
        tipo: 'normal',
        descripcion: 'Descripción de la tarea 2',
        fechaLimite: DateTime.now().add(Duration(days: random.nextInt(5) + 1)),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 3',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 3',
        fechaLimite: DateTime.now().add(Duration(days: random.nextInt(5) + 1)),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 4',
        tipo: 'normal',
        descripcion: 'Descripción de la tarea 4',
        fechaLimite: DateTime.now().add(Duration(days: random.nextInt(5) + 1)),
        pasos: [],
      ),
      Task(
        titulo: 'Tarea 5',
        tipo: 'urgente',
        descripcion: 'Descripción de la tarea 5',
        fechaLimite: DateTime.now().add(Duration(days: random.nextInt(5) + 1)),
        pasos: [],
      ),
    ];
  }
  
  /// Obtiene tareas con caché incorporado
  Future<List<Task>> getTasks() async {
    return obtenerDatos();
  }
  /// Obtiene más tareas paginadas con caché por página
  Future<List<Task>> getMoreTasks({int offset = 0, int limit = 5}) async {
    return manejarExcepcion(() async {
      final cacheKey = 'tasks_offset_${offset}_limit_$limit';
      
      // Si ya tenemos la caché para esta página, la usamos
      if (_tareasPaginadas.containsKey(cacheKey)) {
        return _tareasPaginadas[cacheKey]!;
      }

      // Simular delay de carga de datos
      await Future.delayed(const Duration(seconds: 2));
      
      final List<Task> tasks = [];
      
      for (int i = 0; i < limit; i++) {
        final taskNumber = offset + i + 1;
        final fechaLimite = DateTime.now().add(Duration(days: random.nextInt(5) + 1));
        final numeroDePasos = random.nextInt(5) + 3;
        
        // Obtener los pasos de manera asíncrona
        final pasos = await apiRepository.obtenerPasos(
          'Tarea $taskNumber', 
          fechaLimite, 
          numeroDePasos
        );
        
        tasks.add(Task(
          titulo: 'Tarea $taskNumber',
          tipo: taskNumber % 2 == 0 ? 'normal' : 'urgente',
          descripcion: 'Descripción de la tarea $taskNumber',
          fechaLimite: fechaLimite,
          pasos: pasos, 
        ));
      }
      
      // Almacenamos en la caché por página
      _tareasPaginadas[cacheKey] = tasks;
      
      return tasks;
    }, mensajeError: 'Error al obtener más tareas');
  }
  
  /// Invalida toda la caché de tareas
  @override
  void invalidarCache() {
    super.invalidarCache();
    _tareasPaginadas.clear();
  }
}