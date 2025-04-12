

import 'package:psiemens/data/task_repository.dart';
import 'package:psiemens/domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository;

  TaskService(this._taskRepository);

  // Obtener todas las tareas
  Future<List<Task>> getAllTasks() async {
    final tasks = await _taskRepository.getTasks(); // Llama al método asincrónico
    print('Operación: Obtener todas las tareas');
    print('Tareas: ${tasks.map((task) => task.title).toList()}');
    return tasks;
  }

  // Crear una nueva tarea
  Future<void> createTask(String title, {String type = 'normal', String description = '', required DateTime fechaLimite}) async {
    final pasos = _generateSteps(title, fechaLimite); // Generar pasos para la tarea
    final newTask = Task(
      title: title,
      type: type,
      deadline: fechaLimite, // Asignar la fecha límite
      description: description,
      steps: pasos,
    );
    await _taskRepository.addTask(newTask); // Llama al método asincrónico
    print('Operación: Crear tarea');
    print('Tarea creada: ${newTask.title}, Tipo: ${newTask.type}, Fecha Límite: ${newTask.deadline}, Descripción: ${newTask.description}');
  }

  // Actualizar una tarea existente
  Future<void> updateTask(int index, String newTitle, {String? newType, required DateTime newFechaLimite}) async {
    final tasks = await _taskRepository.getTasks(); // Llama al método asincrónico
    if (index >= 0 && index < tasks.length) {
      final updatedTask = Task(
        title: newTitle,
        type: newType ?? tasks[index].type,
        deadline: newFechaLimite, // Actualizar la fecha límite
        description: tasks[index].description,
        steps: tasks[index].steps,
      );
      await _taskRepository.updateTask(index, updatedTask); // Llama al método asincrónico
      print('Operación: Actualizar tarea');
      print('Tarea actualizada: ${updatedTask.title}, Tipo: ${updatedTask.type}, Fecha Límite: ${updatedTask.deadline}');
    } else {
      print('Error: Índice fuera de rango al intentar actualizar la tarea.');
    }
  }

  // Eliminar una tarea
  Future<void> deleteTask(int index) async {
    await _taskRepository.deleteTask(index); // Llama al método asincrónico
    print('Operación: Eliminar tarea');
  }

  Future<List<Task>> loadMoreTasks(int count, int startIndex) async {
  // Llama al repositorio para cargar más tareas
  return await _taskRepository.loadMoreTasks(count, startIndex);
}

Future<List<Task>> getTasksWithSteps() async {
    final tasks = await _taskRepository.getTasks(); // Obtiene las tareas del repositorio
    return tasks.map((task) {
      final steps = _generateSteps(task.title, task.deadline).take(2).toList(); // Genera pasos simulados
      return Task(
        title: task.title,
        type: task.type,
        deadline: task.deadline,
        description: task.description,
        steps: steps, // Asigna los pasos generados
      );
    }).toList();
  }

Future<List<Task>> getMoreTasksWithSteps(int count, int startIndex) async {
  // Obtiene más tareas del repositorio
  final tasks = await _taskRepository.loadMoreTasks(count, startIndex);
  // Genera pasos para cada tarea
  return tasks.map((task) {
    final steps = _generateSteps(task.title, task.deadline);
    return Task(
      title: task.title,
      type: task.type,
      deadline: task.deadline,
      description: task.description,
      steps: steps, // Asigna los pasos generados
    );
  }).toList();
}

  // Generar pasos para una tarea
  List<String> _generateSteps(String title, DateTime deadline) {
    print('Operación: Obtener pasos para la tarea "$title"');
    return [
      'Paso 1: Analizar el título "$title".',
      'Paso 2: Planificar antes del ${deadline.toLocal()}',
      'Paso 3: Ejecutar las acciones necesarias.',
      'Paso 4: Revisar y validar los resultados.',
    ];
  }
}