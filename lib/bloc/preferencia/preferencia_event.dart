import 'package:equatable/equatable.dart';

abstract class PreferenciasEvent extends Equatable {
  const PreferenciasEvent();

  @override
  List<Object?> get props => [];
}

class CargarPreferencias extends PreferenciasEvent {
  const CargarPreferencias();
}

class CambiarCategoria extends PreferenciasEvent {
  final String categoria;
  final bool seleccionada;

  const CambiarCategoria({
    required this.categoria,
    required this.seleccionada,
  });

  @override
  List<Object> get props => [categoria, seleccionada];
}

class CambiarMostrarFavoritos extends PreferenciasEvent {
  final bool mostrarFavoritos;

  const CambiarMostrarFavoritos({required this.mostrarFavoritos});

  @override
  List<Object> get props => [mostrarFavoritos];
}

class BuscarPorPalabraClave extends PreferenciasEvent {
  final String? palabraClave;

  const BuscarPorPalabraClave({this.palabraClave});

  @override
  List<Object?> get props => [palabraClave];
}

class FiltrarPorFecha extends PreferenciasEvent {
  final DateTime? fechaDesde;
  final DateTime? fechaHasta;

  const FiltrarPorFecha({
    this.fechaDesde,
    this.fechaHasta,
  });

  @override
  List<Object?> get props => [fechaDesde, fechaHasta];
}

class CambiarOrdenamiento extends PreferenciasEvent {
  final String ordenarPor;
  final bool ascendente;

  const CambiarOrdenamiento({
    required this.ordenarPor,
    required this.ascendente,
  });

  @override
  List<Object> get props => [ordenarPor, ascendente];
}

class ReiniciarFiltros extends PreferenciasEvent {
  const ReiniciarFiltros();
}