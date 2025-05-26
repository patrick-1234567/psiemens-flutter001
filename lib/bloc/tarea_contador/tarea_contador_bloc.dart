import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/tarea_contador/tarea_contador_event.dart';
import 'package:psiemens/bloc/tarea_contador/tarea_contador_state.dart';

class TareaContadorBloc extends Bloc<TareaContadorEvent, TareaContadorState> {
  TareaContadorBloc() : super(const TareaContadorState(completadas: 0)) {
    on<IncrementarContador>((event, emit) {
      emit(state.copyWith(completadas: state.completadas + 1));
    });
    on<DecrementarContador>((event, emit) {
      emit(state.copyWith(completadas: state.completadas > 0 ? state.completadas - 1 : 0));
    });
    on<SetTotalTareas>((event, emit) {
      emit(state.copyWith(completadas: event.total));
    });
  }
}
