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
import 'package:psiemens/helpers/task_card_helper.dart';
import 'package:psiemens/views/task_detail_screen.dart';

class TareaScreen extends StatelessWidget {
  const TareaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Limpiar cualquier SnackBar existente al entrar a esta pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!SnackBarManager().isConnectivitySnackBarShowing) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider<TareaBloc>(
          create: (context) => TareaBloc()..add(LoadTareasEvent()),
        ),
        BlocProvider<TareaContadorBloc>(
          create: (context) => TareaContadorBloc(),
        ),
      ],
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
          // Notificar a TareaContadorBloc si fue marcado o desmarcado
          if (state.tarea.completada) {
            context.read<TareaContadorBloc>().add(IncrementarContador());
            SnackBarHelper.mostrarExito(context, mensaje: '¡Tarea marcada como completada!');
          } else {
            context.read<TareaContadorBloc>().add(DecrementarContador());
            SnackBarHelper.mostrarInfo(context, mensaje: 'Tarea marcada como pendiente.');
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
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor: Colors.grey[200],
            body: Column(
              children: [
                // Progreso de tareas completadas
                BlocBuilder<TareaContadorBloc, TareaContadorState>(
                  builder: (context, contadorState) {
                    final total = (state is TareaLoaded) ? state.tareas.length : 0;
                    final completadas = contadorState.completadas;
                    final porcentaje = (total > 0) ? completadas / total : 0.0;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: porcentaje,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('$completadas/$total'),
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
              style: const TextStyle(color: Colors.red),
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
        child:
            state.tareas.isEmpty
                ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const Center(
                        child: Text(TareasConstantes.listaVacia),
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.tareas.length,
                  itemBuilder: (context, index) {
                    final tarea = state.tareas[index];
                    return Dismissible(
                      key: Key(tarea.id.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
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
                      },
                      onDismissed: (_) {
                        context.read<TareaBloc>().add(
                          DeleteTareaEvent(tarea.id!),
                        );
                      },
                      child: construirTarjetaDeportiva(
                        tarea,
                        tarea.id!,
                        () => _mostrarModalEditarTarea(context, tarea),
                        onCompletadaChanged: (checked) {
                          context.read<TareaBloc>().add(
                            CompletarTareaEvent(
                              tarea.copyWith(completada: checked ?? false),
                              checked ?? false,
                            ),
                          );
                        },
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
      builder:
          (dialogContext) => AddTaskModal(
            taskToEdit: tarea,
            onTaskAdded: (Tarea tareaEditada) {
              context.read<TareaBloc>().add(UpdateTareaEvent(tareaEditada));
            },
          ),
    );
  }

  void _mostrarModalAgregarTarea(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AddTaskModal(
            onTaskAdded: (Tarea nuevaTarea) {
              context.read<TareaBloc>().add(CreateTareaEvent(nuevaTarea));
            },
          ),
    );
  }
}
