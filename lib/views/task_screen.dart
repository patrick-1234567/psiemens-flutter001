import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Map<String, dynamic>> _tasks = []; // Lista de tareas con título y fecha
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;

  void _addTask() {
    if (_taskController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _tasks.add({
          'title': _taskController.text,
          'date': _selectedDate,
        }); // Agrega la tarea con título y fecha
      });
      _taskController.clear(); // Limpia el campo de texto
      _selectedDate = null; // Limpia la fecha seleccionada
      Navigator.of(context).pop(); // Cierra el diálogo
    }
  }

  void _editTask(int index) {
    _taskController.text = _tasks[index]['title']; // Prellena el campo con el título existente
    _selectedDate = _tasks[index]['date']; // Prellena la fecha existente
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(hintText: 'Ingrese una tarea'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Seleccione una fecha'
                        : 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo sin guardar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty && _selectedDate != null) {
                  setState(() {
                    _tasks[index] = {
                      'title': _taskController.text,
                      'date': _selectedDate,
                    }; // Actualiza la tarea
                  });
                  _taskController.clear(); // Limpia el campo de texto
                  _selectedDate = null; // Limpia la fecha seleccionada
                  Navigator.of(context).pop(); // Cierra el diálogo
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog() {
    _taskController.clear(); // Limpia el campo antes de agregar una nueva tarea
    _selectedDate = null; // Limpia la fecha seleccionada
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(hintText: 'Ingrese una tarea'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Seleccione una fecha'
                        : 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo sin agregar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: _addTask, // Llama a la función para agregar la tarea
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'No hay tareas. Presione el botón para agregar una.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.check_box_outline_blank),
                  title: Text(_tasks[index]['title']),
                  subtitle: Text(
                    _tasks[index]['date'] != null
                        ? 'Fecha: ${(_tasks[index]['date'] as DateTime).toLocal()}'.split(' ')[0]
                        : 'Sin fecha',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editTask(index), // Llama a la función para editar
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}