import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/tarea/tarea_event.dart';
import 'package:psiemens/bloc/tarea/tarea_state.dart';
import 'package:psiemens/data/task_repository.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class TareaBloc extends Bloc<TareaEvent, TareaState> {
  final TareasRepository _tareaRepository;

  TareaBloc() : _tareaRepository = di<TareasRepository>(), super(TareaInitial()) {
    on<LoadTareasEvent>(_onLoadTareas);
    on<CreateTareaEvent>(_onCreateTarea);
    on<UpdateTareaEvent>(_onUpdateTarea);
    on<DeleteTareaEvent>(_onDeleteTarea);
    on<CompletarTareaEvent>(_onCompletarTarea);
  }

  Future<void> _onLoadTareas(
    LoadTareasEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());
    try {
      final tareas = await _tareaRepository.obtenerTareas(
        forzarRecarga: event.forzarRecarga,
      );
      emit(TareaLoaded(tareas: tareas, lastUpdated: DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(TareaError(e));
      }
    }
  }

  Future<void> _onCreateTarea(
    CreateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());
    try {
      await _tareaRepository.agregarTarea(event.tarea);
      final tareas = await _tareaRepository.obtenerTareas();
      emit(TareaCreated(tareas, TipoOperacionTarea.crear, 'Tarea creada correctamente'));
    } catch (e) {
      emit(TareaError(e is ApiException ? e : ApiException(e.toString())));
    }
  }

  Future<void> _onUpdateTarea(
    UpdateTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());
    try {
      await _tareaRepository.actualizarTarea(event.tarea);
      final tareas = await _tareaRepository.obtenerTareas();
      emit(TareaUpdated(tareas, TipoOperacionTarea.editar, 'Tarea actualizada correctamente'));
    } catch (e) {
      emit(TareaError(e is ApiException ? e : ApiException(e.toString())));
    }
  }

  Future<void> _onDeleteTarea(
    DeleteTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    emit(TareaLoading());
    try {
      await _tareaRepository.eliminarTarea(event.id);
      final tareas = await _tareaRepository.obtenerTareas();
      emit(TareaDeleted(tareas, TipoOperacionTarea.eliminar, 'Tarea eliminada correctamente'));
    } catch (e) {
      emit(TareaError(e is ApiException ? e : ApiException(e.toString())));
    }
  }

  Future<void> _onCompletarTarea(
    CompletarTareaEvent event,
    Emitter<TareaState> emit,
  ) async {
    try {
      final tareaActualizada = event.tarea.copyWith(completada: event.completada);
      final tareaFinal = await _tareaRepository.actualizarTarea(tareaActualizada);
      emit(TareaCompletada(tareaFinal, event.completada));
      // Opcional: recargar la lista de tareas
      final tareas = await _tareaRepository.obtenerTareas();
      emit(TareaLoaded(tareas: tareas, lastUpdated: DateTime.now()));
    } catch (e) {
      emit(TareaError(e is ApiException ? e : ApiException(e.toString())));
    }
  }
}
