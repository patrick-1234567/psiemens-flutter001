import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psiemens/bloc/categorias/categorias_event.dart';
import 'package:psiemens/bloc/categorias/categorias_state.dart';
import 'package:psiemens/data/categoria_repository.dart';
import 'package:psiemens/domain/categoria.dart'; // Añadir importación para Categoria
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:watch_it/watch_it.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository _categoriaRepository = di<CategoriaRepository>();

  CategoriaBloc() : super(CategoriaInitial()) {
    on<CategoriaInitEvent>(_onInit);
    on<CategoriaCreateEvent>(_onCreate);
    on<CategoriaUpdateEvent>(_onUpdate);
  }

  Future<void> _onInit(
    CategoriaInitEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    // Siempre emitimos un estado de carga
    emit(CategoriaLoading());

    try {
      // Pasamos el parámetro forzarRecarga al repositorio
      final categorias = await _categoriaRepository.obtenerCategorias(
        forzarRecarga: event.forzarRecarga,
      );
      // Emitir simplemente el estado cargado sin mostrar SnackBar
      if (event.forzarRecarga == true) {
        emit(CategoriaReloaded(categorias, DateTime.now()));
      } else {
        emit(CategoriaLoaded(categorias, _categoriaRepository.lastRefreshed!));
      }
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError(e, TipoOperacion.cargar));
      }
    }
  }

  Future<void> _onCreate(
    CategoriaCreateEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    // Guardar el estado actual para no perder las categorías ya cargadas
    List<Categoria> categoriasActuales = [];
    if (state is CategoriaLoaded) {
      categoriasActuales = [...(state as CategoriaLoaded).categorias];
    }
    emit(CategoriaLoading());
    try {
      final categoriaCreada = await _categoriaRepository.crearCategoria(
        event.categoria,
      );
      //Agrega al final la categoría creada
      final categoriasActualizadas = [...categoriasActuales, categoriaCreada];
      emit(CategoriaCreated(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError(e, TipoOperacion.crear));
      }
    }
  }

  Future<void> _onUpdate(
    CategoriaUpdateEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    List<Categoria> categoriasActuales = [];
    if (state is CategoriaLoaded) {
      categoriasActuales = [...(state as CategoriaLoaded).categorias];
    }
    emit(CategoriaLoading());

    try {
      final categoriaActualizada = await _categoriaRepository
          .actualizarCategoria(event.categoria);

      // Reemplazar la categoría con el mismo ID por la versión actualizada
      final categoriasActualizadas =
          categoriasActuales.map((categoria) {
            // Si encuentra la categoría con el mismo ID, devuelve la versión actualizada
            if (categoria.id == categoriaActualizada.id) {
              return categoriaActualizada;
            }
            // De lo contrario, mantiene la categoría original
            return categoria;
          }).toList();

      emit(CategoriaUpdated(categoriasActualizadas, DateTime.now()));
    } catch (e) {
      if (e is ApiException) {
        emit(CategoriaError(e, TipoOperacion.actualizar));
      }
    }
  }
}
