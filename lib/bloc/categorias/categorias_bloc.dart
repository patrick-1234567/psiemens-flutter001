import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:psiemens/data/categoria_repository.dart';
import 'package:psiemens/domain/categoria.dart';

part 'categorias_event.dart';
part 'categorias_state.dart';

class CategoriasBloc extends Bloc<CategoriasEvent, CategoriasState> {
  final CategoriaRepository categoriaRepository;

  CategoriasBloc(this.categoriaRepository) : super(CategoriasInitial()) {
    on<CargarCategoriasEvent>(_onCargarCategorias);
    on<RefrescarCategoriasEvent>(_onRefrescarCategorias);
  }

  /// Maneja el evento de cargar categorías
  Future<void> _onCargarCategorias(
      CargarCategoriasEvent event, Emitter<CategoriasState> emit) async {
    emit(CategoriasCargando());
    try {
      final categorias = await categoriaRepository.obtenerCategorias();
      if (categorias.isEmpty) {
        emit(CategoriasVacias());
      } else {
        emit(CategoriasCargadas(categorias));
      }
    } catch (e) {
      emit(CategoriasError('Error al cargar las categorías: $e'));
    }
  }

  /// Maneja el evento de refrescar categorías
  Future<void> _onRefrescarCategorias(
      RefrescarCategoriasEvent event, Emitter<CategoriasState> emit) async {
    emit(CategoriasCargando());
    try {
      final categorias = await categoriaRepository.obtenerCategorias();
      if (categorias.isEmpty) {
        emit(CategoriasVacias());
      } else {
        emit(CategoriasCargadas(categorias));
      }
    } catch (e) {
      emit(CategoriasError('Error al refrescar las categorías: $e'));
    }
  }
}