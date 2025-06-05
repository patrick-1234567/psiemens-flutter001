import 'package:flutter/material.dart';
import 'package:psiemens/domain/task.dart';
import 'package:psiemens/theme/theme.dart';

class TaskDetailsScreen extends StatelessWidget {
  final List<Tarea> tareas;
  final int indice;

  const TaskDetailsScreen({super.key, required this.tareas, required this.indice});

  @override
  Widget build(BuildContext context) {
    final Tarea tarea = tareas[indice];
    final String fechaLimiteDato = tarea.fechaLimite != null
        ? '${tarea.fechaLimite!.day.toString().padLeft(2, '0')}/'
          '${tarea.fechaLimite!.month.toString().padLeft(2, '0')}/'
          '${tarea.fechaLimite!.year}'
        : 'Sin fecha límite';

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Evita que el tap se propague al fondo
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! > 0 && indice > 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice - 1,
                        ),
                      ),
                    );
                  } else if (details.primaryVelocity! < 0 && indice < tareas.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          tareas: tareas,
                          indice: indice + 1,
                        ),
                      ),
                    );
                  }
                }
              },
              child: Card(
                margin: const EdgeInsets.all(32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          image: DecorationImage(
                            image: NetworkImage('https://picsum.photos/400/200?random=$indice'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  tarea.tipo == 'urgente' ? Icons.warning : Icons.task_alt,
                                  color: tarea.tipo == 'urgente' ? Colors.red : AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tarea.titulo,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.primary,
                                          decoration: tarea.completada ? TextDecoration.lineThrough : null,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20, color: AppColors.gray07),
                                const SizedBox(width: 8),
                                Text(
                                  fechaLimiteDato,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.gray07,
                                      ),
                                ),
                              ],
                            ),
                            if (tarea.descripcion?.isNotEmpty ?? false) ...[
                              const SizedBox(height: 16),
                              Text(
                                tarea.descripcion!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Estado: ${tarea.completada ? 'Completada' : 'Pendiente'}',
                                  style: TextStyle(
                                    color: tarea.completada ? AppColors.secondary : AppColors.gray07,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}