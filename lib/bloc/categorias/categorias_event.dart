part of 'categorias_bloc.dart';

sealed class CategoriasEvent extends Equatable {
  const CategoriasEvent();

  @override
  List<Object> get props => [];
}

/// Evento para cargar las categorías
class CargarCategoriasEvent extends CategoriasEvent {}

/// Evento para refrescar las categorías
class RefrescarCategoriasEvent extends CategoriasEvent {}