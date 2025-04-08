import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(title: 'Tarea 1', type: "urgente"),
    Task(title: 'Tarea 2'),
    Task(title: 'Tarea 3', type: "urgente"),
    Task(title: 'Tarea 4'),
    Task(title: 'Tarea 5', type: "urgente"),
  ];

  // Obtener todas las tareas
  List<Task> getTasks() {
    return _tasks;
  }

  // Agregar una nueva tarea
  void addTask(Task task) {
    final type = _tasks.length % 2 == 0 ? 'normal' : 'urgente';
    final newTask = Task(title: task.title, type: type);
    _tasks.add(newTask);
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