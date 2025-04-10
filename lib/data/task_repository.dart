import '../domain/task.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      title: 'Tarea 1',
      type: "urgente",
      deadline: DateTime(2025, 4, 10),
      description: 'Descripción de la tarea 1',
    ),
    Task(
      title: 'Tarea 2',
      deadline: DateTime.now().add(Duration(days: 2)),
      description: 'Descripción de la tarea 2',
    ),
    Task(
      title: 'Tarea 3',
      type: "urgente",
      deadline: DateTime.now().add(Duration(days: 3)),
      description: 'Descripción de la tarea 3',
    ),
    Task(
      title: 'Tarea 4',
      deadline: DateTime.now().add(Duration(days: 4)),
      description: 'Descripción de la tarea 4',
    ),
    Task(
      title: 'Tarea 5',
      type: "urgente",
      deadline: DateTime.now().add(Duration(days: 5)),
      description: 'Descripción de la tarea 5',
    ),
    Task(
      title: 'Tarea 6',
      deadline: DateTime.now().add(Duration(days: 10)),
      description: 'Descripción de la tarea 6',
    ),
    Task(
      title: 'Tarea 7',
      type: "urgente",
      deadline: DateTime.now().add(Duration(days: 14)),
      description: 'Descripción de la tarea 7',
    ),
  ];

  // Obtener todas las tareas
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula un retraso de 2 segundos
    return _tasks;
  }

  // Simula un retraso al agregar una nueva tarea
  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula un retraso de 1 segundo
    _tasks.add(task);
  }

  // Simula un retraso al actualizar una tarea existente
  Future<void> updateTask(int index, Task updatedTask) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula un retraso de 1 segundo
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
    }
  }

  // Simula un retraso al eliminar una tarea
  Future<void> deleteTask(int index) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula un retraso de 1 segundo
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    }
  }
  Future<List<Task>> loadMoreTasks(int count, int startIndex) async {
  await Future.delayed(const Duration(seconds: 2)); // Simula un retraso
  return List.generate(
    count,
    (index) => Task(
      title: 'Tarea ${startIndex + index + 1}',
      type: index % 2 == 0 ? 'normal' : 'urgente',
      deadline: DateTime.now().add(Duration(days: index + 1)),
      description: 'Descripción de la tarea ${startIndex + index + 1}',
    ),
  );
}


}