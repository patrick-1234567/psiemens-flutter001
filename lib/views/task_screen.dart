import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/tarea/tarea_bloc.dart';
import 'package:psiemens/bloc/tarea/tarea_event.dart';
import 'package:psiemens/bloc/tarea/tarea_state.dart';
import 'package:psiemens/bloc/tarea_contador/tarea_contador_bloc.dart';
import 'package:psiemens/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:psiemens/bloc/tarea_contador/tarea_contador_state.dart';
import 'package:psiemens/components/add_task_modal.dart';
import 'package:psiemens/components/last_updated_header.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/domain/task.dart';
import 'package:psiemens/helpers/dialog_helper.dart';
import 'package:psiemens/helpers/snackbar_helper.dart';
import 'package:psiemens/helpers/snackbar_manager.dart';
import 'package:psiemens/theme/theme.dart';
import 'package:psiemens/views/task_detail_screen.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    return BlocProvider<TareaBloc>(
      create: (context) => TareaBloc()..add(LoadTareasEvent()),
      child: const _TareaScreenContent(),
    );
  }
}

class _TareaScreenContent extends StatelessWidget {
  const _TareaScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TareaBloc, TareaState>(
      listener: (context, state) {
        if (state is TareaError) {
          SnackBarHelper.manejarError(context, state.error);
        } else if (state is TareaOperationSuccess) {
          SnackBarHelper.mostrarExito(context, mensaje: state.mensaje);
          context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
        } else if (state is TareaLoaded && state.tareas.isEmpty) {
          SnackBarHelper.mostrarInfo(
            context,
            mensaje: TareasConstantes.listaVacia,
          );
        } else if (state is TareaCompletada) {
          if (state.tarea.completada) {
            context.read<TareaContadorBloc>().add(IncrementarContador());
            SnackBarHelper.mostrarExito(
                context, mensaje: '¡Tarea marcada como completada!');
          } else {
            context.read<TareaContadorBloc>().add(DecrementarContador());
            SnackBarHelper.mostrarInfo(
                context, mensaje: 'Tarea marcada como pendiente.');
          }
        }
      },
      child: BlocBuilder<TareaBloc, TareaState>(
        builder: (context, state) {
          DateTime? lastUpdated;
          if (state is TareaLoaded) {
            lastUpdated = state.lastUpdated;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state is TareaLoaded
                    ? '${TareasConstantes.tituloAppBar} - Total: ${state.tareas.length}'
                    : TareasConstantes.tituloAppBar,
                style: const TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor: AppColors.surface,
            body: Column(
              children: [
                BlocBuilder<TareaContadorBloc, TareaContadorState>(
                  builder: (context, contadorState) {
                    final total =
                        (state is TareaLoaded) ? state.tareas.length : 0;
                    final completadas = contadorState.completadas;
                    final porcentaje =
                        (total > 0) ? completadas / total : 0.0;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: porcentaje,
                                  minHeight: 8,
                                  backgroundColor: AppColors.gray04,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$completadas/$total',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                LastUpdatedHeader(lastUpdated: lastUpdated),
                Expanded(child: _construirCuerpoTareas(context, state)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _mostrarModalAgregarTarea(context),
              tooltip: 'Agregar Tarea',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _construirCuerpoTareas(BuildContext context, TareaState state) {
    if (state is TareaLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TareaError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error.message,
              style: const TextStyle(color: AppColors.gray07),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<TareaBloc>().add(LoadTareasEvent()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (state is TareaLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1200));
          if (context.mounted) {
            context.read<TareaBloc>().add(LoadTareasEvent(forzarRecarga: true));
          }
        },
        child: state.tareas.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(
                      child: const Text(
                        TareasConstantes.listaVacia,
                        style: TextStyle(color: AppColors.gray07),
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.tareas.length,
                itemBuilder: (context, index) {
                  final tarea = state.tareas[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Dismissible(
                      key: Key(tarea.id.toString()),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        return await DialogHelper.mostrarConfirmacion(
                          context: context,
                          titulo: 'Confirmar eliminación',
                          mensaje:
                              '¿Estás seguro de que deseas eliminar esta tarea?',
                          textoCancelar: 'Cancelar',
                          textoConfirmar: 'Eliminar',
                        );
                      },                      onDismissed: (_) {
                        context
                            .read<TareaBloc>()
                            .add(DeleteTareaEvent(tarea.id!));
                        SnackBarHelper.mostrarExito(
                          context,
                          mensaje: TareasConstantes.tareaEliminada,
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: AppColors.gray04.withOpacity(0.5)),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsScreen(
                                  tareas: state.tareas,
                                  indice: index,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      tarea.tipo == 'urgente'
                                          ? Icons.warning
                                          : Icons.task_alt,
                                      color: tarea.tipo == 'urgente'
                                          ? Colors.red
                                          : AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        tarea.titulo,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          decoration: tarea.completada
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      value: tarea.completada,
                                      onChanged: (checked) {
                                        context.read<TareaBloc>().add(
                                              CompletarTareaEvent(
                                                tarea.copyWith(
                                                    completada:
                                                        checked ?? false),
                                                checked ?? false,
                                              ),
                                            );
                                      },
                                      activeColor: AppColors.primary,
                                    ),
                                  ],
                                ),
                                if (tarea.fechaLimite != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Fecha límite: ${tarea.fechaLimite!.day.toString().padLeft(2, '0')}/'
                                      '${tarea.fechaLimite!.month.toString().padLeft(2, '0')}/'
                                      '${tarea.fechaLimite!.year}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.gray07,
                                      ),
                                    ),
                                  ),
                                if (tarea.descripcion?.isNotEmpty ?? false)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      tarea.descripcion!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.gray07,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: AppColors.gray07),
                                      onPressed: () => _mostrarModalEditarTarea(
                                          context, tarea),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    }
    return const SizedBox.shrink();
  }

  void _mostrarModalEditarTarea(BuildContext context, Tarea tarea) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddTaskModal(
        taskToEdit: tarea,
        onTaskAdded: (Tarea tareaEditada) {
          context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
        },
      ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    // Obtener el estado actual del TareaBloc
    final state = context.read<TareaBloc>().state;

    // Verificar si hay 3 o más tareas
    if (state is TareaLoaded && state.tareas.length >= 3) {
      // Mostrar SnackBar con mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'No se pueden crear más tareas. Elimine una para continuar.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Entendido',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return; // No mostrar el diálogo si ya hay 3 tareas
    }

    // Si hay menos de 3 tareas, mostrar el diálogo para crear
    showDialog(
      context: context,
      builder: (dialogContext) => AddTaskModal(
        onTaskAdded: (Tarea nuevaTarea) {
          context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
        },
      ),
    );
  }
}