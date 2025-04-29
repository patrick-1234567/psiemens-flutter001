part of 'categorias_bloc.dart';

sealed class CategoriasState extends Equatable {
  const CategoriasState();

  @override
  List<Object> get props => [];
}

/// Estado inicial de las categorías
final class CategoriasInitial extends CategoriasState {}

/// Estado cuando las categorías están cargándose
final class CategoriasCargando extends CategoriasState {}

/// Estado cuando las categorías se cargaron correctamente
final class CategoriasCargadas extends CategoriasState {
  final List<Categoria> categorias;

  const CategoriasCargadas(this.categorias);

  @override
  List<Object> get props => [categorias];
}

/// Estado cuando no hay categorías disponibles
final class CategoriasVacias extends CategoriasState {}

/// Estado cuando ocurre un error al cargar las categorías
final class CategoriasError extends CategoriasState {
  final String mensaje;

  const CategoriasError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}