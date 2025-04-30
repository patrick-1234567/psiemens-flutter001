import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/preferencias_repository.dart';
import 'preferencia_event.dart';
import 'preferencia_state.dart';

class PreferenciasBloc extends Bloc<PreferenciasEvent, PreferenciasState> {
  //aqui se cambia
  final PreferenciasRepository _preferenciasRepository;
  
  PreferenciasBloc({required PreferenciasRepository preferenciasRepository}) 
      : _preferenciasRepository = preferenciasRepository,
        super(const PreferenciasState()) {
    on<CargarPreferencias>(_onCargarPreferencias);
    on<CambiarCategoria>(_onCambiarCategoria);
    on<CambiarMostrarFavoritos>(_onCambiarMostrarFavoritos);
    on<BuscarPorPalabraClave>(_onBuscarPorPalabraClave);
    on<FiltrarPorFecha>(_onFiltrarPorFecha);
    on<CambiarOrdenamiento>(_onCambiarOrdenamiento);
    on<ReiniciarFiltros>(_onReiniciarFiltros);
  }

  Future<void> _onCargarPreferencias(
    CargarPreferencias event,
    Emitter<PreferenciasState> emit,
  ) async {
    try {
      final preferencias = await _preferenciasRepository.obtenerPreferencias();
      emit(PreferenciasState(
        categoriasSeleccionadas: preferencias.categoriasSeleccionadas,
        mostrarFavoritos: preferencias.mostrarFavoritos,
        palabraClave: preferencias.palabraClave,
        fechaDesde: preferencias.fechaDesde,
        fechaHasta: preferencias.fechaHasta,
        ordenarPor: preferencias.ordenarPor,
        ascendente: preferencias.ascendente,
      ));
    } catch (_) {
      // Si hay error, mantener estado actual
    }
  }

  void _onCambiarCategoria(
    CambiarCategoria event,
    Emitter<PreferenciasState> emit,
  ) {
    final categorias = List<String>.from(state.categoriasSeleccionadas);
    
    if (event.seleccionada && !categorias.contains(event.categoria)) {
      categorias.add(event.categoria);
    } else if (!event.seleccionada && categorias.contains(event.categoria)) {
      categorias.remove(event.categoria);
    }
    
    final nuevoEstado = state.copyWith(categoriasSeleccionadas: categorias);
    _guardarPreferencias(nuevoEstado);
    emit(nuevoEstado);
  }

  void _onCambiarMostrarFavoritos(
    CambiarMostrarFavoritos event,
    Emitter<PreferenciasState> emit,
  ) {
    final nuevoEstado = state.copyWith(mostrarFavoritos: event.mostrarFavoritos);
    _guardarPreferencias(nuevoEstado);
    emit(nuevoEstado);
  }

  void _onBuscarPorPalabraClave(
    BuscarPorPalabraClave event,
    Emitter<PreferenciasState> emit,
  ) {
    final nuevoEstado = state.copyWith(palabraClave: event.palabraClave);
    _guardarPreferencias(nuevoEstado);
    emit(nuevoEstado);
  }

  void _onFiltrarPorFecha(
    FiltrarPorFecha event,
    Emitter<PreferenciasState> emit,
  ) {
    final nuevoEstado = state.copyWith(
      fechaDesde: event.fechaDesde,
      fechaHasta: event.fechaHasta,
    );
    _guardarPreferencias(nuevoEstado);
    emit(nuevoEstado);
  }

  void _onCambiarOrdenamiento(
    CambiarOrdenamiento event,
    Emitter<PreferenciasState> emit,
  ) {
    final nuevoEstado = state.copyWith(
      ordenarPor: event.ordenarPor,
      ascendente: event.ascendente,
    );
    _guardarPreferencias(nuevoEstado);
    emit(nuevoEstado);
  }

  void _onReiniciarFiltros(
    ReiniciarFiltros event,
    Emitter<PreferenciasState> emit,
  ) {
    const estadoInicial = PreferenciasState();
    _guardarPreferencias(estadoInicial);
    emit(estadoInicial);
  }

  Future<void> _guardarPreferencias(PreferenciasState preferencias) async {
    await _preferenciasRepository.guardarPreferencias(
      categoriasSeleccionadas: preferencias.categoriasSeleccionadas,
      mostrarFavoritos: preferencias.mostrarFavoritos,
      palabraClave: preferencias.palabraClave,
      fechaDesde: preferencias.fechaDesde,
      fechaHasta: preferencias.fechaHasta,
      ordenarPor: preferencias.ordenarPor,
      ascendente: preferencias.ascendente,
    );
  }
}