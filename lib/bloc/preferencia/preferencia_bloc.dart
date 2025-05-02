import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/preferencia/preferencia_event.dart';
import 'package:psiemens/bloc/preferencia/preferencia_state.dart';
import 'package:psiemens/data/preferencia_repository.dart';
import 'package:watch_it/watch_it.dart';


class PreferenciaBloc extends Bloc<PreferenciaEvent, PreferenciaState> {
  final PreferenciaRepository _preferenciasRepository =
      di<PreferenciaRepository>();

  PreferenciaBloc() : super(const PreferenciaState()) {
    on<CargarPreferencias>(_onCargarPreferencias);
    on<CambiarCategoria>(_onCambiarCategoria);
    on<CambiarMostrarFavoritos>(_onCambiarMostrarFavoritos);
    on<SavePreferencias>(_onSavePreferencias);
    on<BuscarPorPalabraClave>(_onBuscarPorPalabraClave);
    on<FiltrarPorFecha>(_onFiltrarPorFecha);
    on<CambiarOrdenamiento>(_onCambiarOrdenamiento);
    on<ReiniciarFiltros>(_onReiniciarFiltros);
    on<PreferenciaError>(_onPreferenciaError); // Handler dedicado para errores
  }
  void _onPreferenciaError(
    PreferenciaError event,
    Emitter<PreferenciaState> emit, // Usamos el emitter del handler
  ) {
    emit(state.copyWith(error: event.message));
  }

  /*Future<void> _onCargarPreferencias(
    CargarPreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      final categorias =
          await _preferenciasRepository.obtenerCategoriasSeleccionadas();
      emit(state.copyWith(categoriasSeleccionadas: categorias));
    } catch (e) {
      add(PreferenciaError('Error al cargar preferencias: ${e.toString()}'));
    }
  }*/
  Future<void> _onCargarPreferencias(
    CargarPreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      final categoriasSeleccionadas = await _preferenciasRepository.obtenerCategoriasSeleccionadas();
      emit(state.copyWith(
        categoriasSeleccionadas: categoriasSeleccionadas,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Error al cargar preferencias: ${e.toString()}'));
    }
  }

  Future<void> _onCambiarCategoria(
    CambiarCategoria event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      if (event.seleccionada) {
        await _preferenciasRepository.agregarCategoriaFiltro(event.categoria);
      } else {
        await _preferenciasRepository.eliminarCategoriaFiltro(event.categoria);
      }

      final categoriasActualizadas =
          await _preferenciasRepository.obtenerCategoriasSeleccionadas();
      emit(
        state.copyWith(
          categoriasSeleccionadas: categoriasActualizadas,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(error: 'Error al modificar categoría: ${e.toString()}'),
      );
    }
  }

  Future<void> _onCambiarMostrarFavoritos(
    CambiarMostrarFavoritos event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      emit(
        state.copyWith(mostrarFavoritos: event.mostrarFavoritos, error: null),
      );
    } catch (e) {
      emit(
        state.copyWith(error: 'Error al actualizar favoritos: ${e.toString()}'),
      );
    }
  }

  Future<void> _onBuscarPorPalabraClave(
    BuscarPorPalabraClave event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      emit(state.copyWith(palabraClave: event.palabraClave, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Error al buscar: ${e.toString()}'));
    }
  }

  Future<void> _onFiltrarPorFecha(
    FiltrarPorFecha event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          fechaDesde: event.fechaDesde,
          fechaHasta: event.fechaHasta,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(error: 'Error al filtrar por fecha: ${e.toString()}'),
      );
    }
  }

  Future<void> _onCambiarOrdenamiento(
    CambiarOrdenamiento event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          ordenarPor: event.ordenarPor,
          ascendente: event.ascendente,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Error al cambiar orden: ${e.toString()}'));
    }
  }

  Future<void> _onReiniciarFiltros(
    ReiniciarFiltros event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      await _preferenciasRepository.limpiarFiltrosCategorias();
      emit(const PreferenciaState().copyWith(error: null));
    } catch (e) {
      emit(
        state.copyWith(error: 'Error al reiniciar filtros: ${e.toString()}'),
      );
    }
  }

  Future<void> _onSavePreferencias(
    SavePreferencias event,
    Emitter<PreferenciaState> emit,
  ) async {
    try {
      await _preferenciasRepository.limpiarFiltrosCategorias();
      for (final categoria in event.categoriasSeleccionadas) {
        await _preferenciasRepository.agregarCategoriaFiltro(categoria);
      }

      final categoriasActualizadas =
          await _preferenciasRepository.obtenerCategoriasSeleccionadas();
      emit(
        state.copyWith(
          categoriasSeleccionadas: categoriasActualizadas,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(error: 'Error al guardar preferencias: ${e.toString()}'),
      );
    }
  }

}
