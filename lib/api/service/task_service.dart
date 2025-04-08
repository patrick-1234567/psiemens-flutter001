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
    final newTask = Task(title: title, type: type);
    _taskRepository.addTask(newTask);
    print('Operación: Crear tarea');
    print('Tarea creada: ${newTask.title}, Tipo: ${newTask.type}');
  }

  // Actualizar una tarea existente
  void updateTask(int index, String newTitle, {String? newType}) {
    final tasks = _taskRepository.getTasks();
    if (index >= 0 && index < tasks.length) {
      final updatedTask = Task(
        title: newTitle,
        type: newType ?? tasks[index].type,
      );
      _taskRepository.updateTask(index, updatedTask);
      print('Operación: Actualizar tarea');
      print('Tarea actualizada: ${updatedTask.title}, Tipo: ${updatedTask.type}');
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
}