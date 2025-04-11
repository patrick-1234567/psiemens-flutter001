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
    _loadInitialTasks(); // Carga inicial de tareas
    _scrollController.addListener(_onScroll);
}

void _loadInitialTasks() async {
  final initialTasks = await taskService.getTasksWithSteps(); // Llama al método asincrónico
  setState(() {
    tasks = initialTasks;
  });
}

void _loadMoreTasks() {
  if (isLoading) return; // Evita llamadas repetidas mientras se está cargando

  setState(() {
    isLoading = true;
  });

  // Llama al servicio para cargar más tareas con pasos
  taskService.getMoreTasksWithSteps(5, tasks.length).then((newTasks) {
    setState(() {
      tasks.addAll(newTasks); // Agrega las nuevas tareas a la lista
      isLoading = false; // Finaliza el estado de carga
    });
  }).catchError((error) {
    setState(() {
      isLoading = false; // Finaliza el estado de carga incluso si hay un error
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar más tareas: $error')),
    );
  });
}

void _onScroll() {
  if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    _loadMoreTasks(); // Llama a _loadMoreTasks cuando se llega al final del scroll
  }
}
@override
void dispose() {
  _scrollController.dispose(); // Limpia el ScrollController
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        '${AppConstants.titleAppbar} - Total: ${tasks.length}', // Muestra el título con el total de tareas
      ),
      centerTitle: true,
    ),
    backgroundColor: Colors.grey[200],
    body: tasks.isEmpty
        ? Center(
            child: Text(AppConstants.emptyList), // Usando la constante
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
                    SnackBar(content: Text(AppConstants.tareaEliminada)),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: TaskCardHelper.buildTaskCard(
                  context,
                  task,
                  tasks,
                  () => _showEditTaskModal(context, index),
                ),
              );
            },
          ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        _showTaskModal(context);
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    ),
  );
}

void _showTaskModal(BuildContext context) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar Tarea'),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
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
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                    }
                  },
                  child: const Text('Seleccionar Fecha'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && selectedDate != null) {
                // Llama a createTask para agregar la tarea
                await taskService.createTask(
                  titleController.text,
                  type: typeController.text.isNotEmpty ? typeController.text : 'normal',
                  description: descriptionController.text,
                  fechaLimite: selectedDate!,
                );

                // Actualiza la lista de tareas
                final updatedTasks = await taskService.getTasksWithSteps();
                setState(() {
                  tasks = updatedTasks;
                });

                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, ingresa un título y selecciona una fecha')),
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

void _showEditTaskModal(BuildContext context, int index) {
  final task = tasks[index];
  final TextEditingController titleController = TextEditingController(text: task.title);
  final TextEditingController typeController = TextEditingController(text: task.type);
  final TextEditingController descriptionController = TextEditingController(text: task.description);
  DateTime? selectedDate = task.deadline; // Inicializa con la fecha existente

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Editar Tarea'),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
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
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(), // Muestra la fecha existente
                      firstDate: DateTime(2000), // Fecha mínima
                      lastDate: DateTime(2100), // Fecha máxima
                    );
                    if (pickedDate != null) {
                      selectedDate = pickedDate; // Actualiza la fecha seleccionada
                    }
                  },
                  child: Text(
                    selectedDate != null
                        ? 'Fecha seleccionada: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Seleccionar Fecha',
                  ),
                ),
              ],
            ),
          ),
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
              if (titleController.text.isNotEmpty && selectedDate != null) {
                setState(() {
                  taskService.updateTask(
                    index,
                    titleController.text,
                    newType: typeController.text.isNotEmpty ? typeController.text : task.type,
                    newFechaLimite: selectedDate!, // Pasar la nueva fecha seleccionada
                  );
                  tasks[index] = Task(
                    title: titleController.text,
                    type: typeController.text.isNotEmpty ? typeController.text : task.type,
                    deadline: selectedDate!,
                    description: descriptionController.text,
                    steps: task.steps,
                  );
                });
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, ingresa un título y selecciona una fecha')),
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