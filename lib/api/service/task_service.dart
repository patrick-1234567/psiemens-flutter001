import '../../data/task_repository.dart';
import '../../domain/task.dart';

class TaskService {
  final TaskRepository _taskRepository;

  TaskService(this._taskRepository);

  // Obtener todas las tareas
  List<Task> getAllTasks() {
    final tasks = _taskRepository.getTasks();
    print('Operación: Obtener todas las tareas');
    print('Tareas: ${tasks.map((task) => task.title).toList()}');
    return tasks;
  }

  // Crear una nueva tarea
  void createTask(String title, {String type = 'normal'}) {
    final fechaLimite = DateTime.now().add(Duration(days: 7)); // Fecha límite en 7 días
    final newTask = Task(title: title, type: type, fechaLimite: fechaLimite);
    _taskRepository.addTask(newTask);
    print('Operación: Crear tarea');
    print('Tarea creada: ${newTask.title}, Tipo: ${newTask.type}, Fecha Límite: ${newTask.fechaLimite}');
  }

  // Actualizar una tarea existente
  void updateTask(int index, String newTitle, {String? newType}) {
    final tasks = _taskRepository.getTasks();
    if (index >= 0 && index < tasks.length) {
      final updatedTask = Task(
        title: newTitle,
        type: newType ?? tasks[index].type,
        fechaLimite: tasks[index].fechaLimite, // Mantener la fecha límite existente
      );
      _taskRepository.updateTask(index, updatedTask);
      print('Operación: Actualizar tarea');
      print('Tarea actualizada: ${updatedTask.title}, Tipo: ${updatedTask.type}, Fecha Límite: ${updatedTask.fechaLimite}');
    } else {
      print('Error: Índice fuera de rango al intentar actualizar la tarea.');
    }
  }

  // Eliminar una tarea
  void deleteTask(int index) {
    final tasks = _taskRepository.getTasks();
    if (index >= 0 && index < tasks.length) {
      final deletedTask = tasks[index];
      _taskRepository.deleteTask(index);
      print('Operación: Eliminar tarea');
      print('Tarea eliminada: ${deletedTask.title}, Tipo: ${deletedTask.type}');
    } else {
      print('Error: Índice fuera de rango al intentar eliminar la tarea.');
    }
  }

  List<String> obtenerPasos(String titulo) {
    print('Operación: Obtener pasos para la tarea "$titulo"');
    return [
      'Paso 1: Planificar $titulo',
      'Paso 2: Ejecutar $titulo',
      'Paso 3: Revisar $titulo',
    ];
  }
}