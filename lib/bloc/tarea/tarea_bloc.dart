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
     // on<LoadMoreTareasEvent>(_onLoadMoreTareas);
    // on<CreateTareaEvent>(_onCreateTarea);
    // on<UpdateTareaEvent>(_onUpdateTarea);
    // on<DeleteTareaEvent>(_onDeleteTarea);
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

  // Implementar los demás métodos _on... para cada evento
}
