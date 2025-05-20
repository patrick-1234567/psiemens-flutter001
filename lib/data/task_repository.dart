import 'package:psiemens/domain/task.dart';
import 'package:psiemens/data/api_repository.dart'; 
import 'package:psiemens/data/base_repository.dart';
import 'dart:math';
import 'dart:async';

class TaskRepository extends BaseRepository<Task> {
  final ApiRepository apiRepository = ApiRepository();
  final Random random = Random();
  
  @override
  dynamic get service => null; // No hay un servicio real asociado
  
  /// Obtiene tareas con caché incorporado
  Future<List<Task>> getTasks() async {
    return obtenerDatos(
      fetchFunction: () async {
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
      },
      cacheKey: 'tasks',
    );
  }

  /// Obtiene más tareas paginadas con caché por página
  Future<List<Task>> getMoreTasks({int offset = 0, int limit = 5}) async {
    return obtenerDatos(
      fetchFunction: () async {
        await Future.delayed(const Duration(seconds: 2));
        return List.generate(limit, (index) {
          final taskNumber = offset + index + 1;
          final fechaLimite = DateTime.now().add(Duration(days: random.nextInt(5) + 1));
          final numeroDePasos = random.nextInt(5) + 3;
          return Task(
            titulo: 'Tarea $taskNumber',
            tipo: taskNumber % 2 == 0 ? 'normal' : 'urgente',
            descripcion: 'Descripción de la tarea $taskNumber',
            fechaLimite: fechaLimite,
            pasos: apiRepository.obtenerPasos('Tarea $taskNumber', fechaLimite, numeroDePasos), 
          );
        });
      },
      cacheKey: 'tasks_offset_${offset}_limit_$limit',
    );
  }
}