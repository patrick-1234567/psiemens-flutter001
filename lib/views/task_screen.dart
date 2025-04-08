import 'package:flutter/material.dart';
import 'package:psiemens/domain/task.dart';
import '../constants.dart';
import '../api/service/task_service.dart';
import '../data/task_repository.dart';
import '../helpers/task_card_helper.dart'; // Importa el helper para los Cards

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskService taskService = TaskService(TaskRepository());
  final ScrollController _scrollController = ScrollController();
  List<Task> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tasks = taskService.getAllTasks(); // Carga inicial de tareas
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreTasks();
    }
  }

  void _loadMoreTasks() {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Simula la carga de más tareas
    Future.delayed(const Duration(seconds: 2), () {
      final newTasks = List.generate(
        5,
        (index) => Task(
          title: 'Tarea ${tasks.length + index + 1}',
          type: index % 2 == 0 ? 'normal' : 'urgente',
          fechaLimite: DateTime.now().add(Duration(days: index + 1)),
        ),
      );

      setState(() {
        tasks.addAll(newTasks);
        isLoading = false;
      });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(AppConstants.TITLE_APPBAR), // Usando la constante
      centerTitle: true,
    ),
    backgroundColor: Colors.grey[200],
    body: tasks.isEmpty
        ? Center(
            child: Text(AppConstants.EMPTY_LIST), // Usando la constante
          )
        : ListView.builder(
            controller: _scrollController, // Controlador para el scroll
            itemCount: tasks.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == tasks.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final task = tasks[index];
              return Dismissible(
                key: Key(task.title), // Clave única para cada tarea
                direction: DismissDirection.startToEnd, // Deslizar hacia la izquierda
                onDismissed: (direction) {
                  setState(() {
                    tasks.removeAt(index); // Elimina la tarea de la lista
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarea "${task.title}" eliminada')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: TaskCardHelper.buildTaskCard(task), // Usa el helper para construir el Card
              );
            },
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        _showTaskModal(context);
      },
      child: const Icon(Icons.add),
    ),
  );
}
  

  void _showTaskModal(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController typeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Tipo (opcional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    taskService.createTask(
                      titleController.text,
                      type: typeController.text.isNotEmpty
                          ? typeController.text
                          : 'normal',
                    );
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, ingresa un título')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}