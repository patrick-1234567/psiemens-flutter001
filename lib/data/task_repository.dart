import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      title: 'Tarea 1',
      type: "urgente",
      fechaLimite: DateTime.now().add(Duration(days: 3)), // Fecha límite en 3 días
    ),
    Task(
      title: 'Tarea 2',
      fechaLimite: DateTime.now().add(Duration(days: 5)), // Fecha límite en 5 días
    ),
    Task(
      title: 'Tarea 3',
      type: "urgente",
      fechaLimite: DateTime.now().add(Duration(days: 7)), // Fecha límite en 7 días
    ),
    Task(
      title: 'Tarea 4',
      fechaLimite: DateTime.now().add(Duration(days: 10)), // Fecha límite en 10 días
    ),
    Task(
      title: 'Tarea 5',
      type: "urgente",
      fechaLimite: DateTime.now().add(Duration(days: 14)), // Fecha límite en 14 días
    ),
    Task(
      title: 'Tarea 6',
      type: "urgente",
      fechaLimite: DateTime.now().add(Duration(days: 7)), // Fecha límite en 7 días
    ),
    Task(
      title: 'Tarea 7',
      fechaLimite: DateTime.now().add(Duration(days: 10)), // Fecha límite en 10 días
    ),
    Task(
      title: 'Tarea 8',
      type: "urgente",
      fechaLimite: DateTime.now().add(Duration(days: 14)), // Fecha límite en 14 días
    ),
  ];

  // Obtener todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }

  // Agregar una nueva tarea
  void addTask(Task task) {
    _tasks.add(task);
  }

  // Actualizar una tarea existente
  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
    }
  }

  // Eliminar una tarea
  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    }
  }
}