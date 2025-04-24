import 'package:psiemens/data/noticia_repository.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:psiemens/constants.dart';

class NoticiaService {
  final NoticiaRepository _repository = NoticiaRepository();

  /// Obtiene cotizaciones paginadas con validaciones
  Future<List<Noticia>> getPaginatedNoticia({
    required int pageNumber,
    int pageSize = NoticiaConstantes.tamanoPagina,
  }) async {
    if (pageNumber < 1) {
      throw Exception(NoticiaConstantes.mensajeError);
    }
    if (pageSize <= 0) {
      throw Exception(NoticiaConstantes.mensajeError);
    }

    final noticia = await _repository.getNoticiasPaginadas(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    for (final noticia in noticia) {
      // Formatear la fecha de publicación
      if (noticia.titulo.isEmpty ||
          noticia.descripcion.isEmpty ||
          noticia.fuente.isEmpty) {
        throw Exception(
          '${NoticiaConstantes.mensajeError} Los campos título, descripción y fuente no pueden estar vacíos.',
        );
      }
    }
    return noticia;
  }


  Future<void> crearNoticia({
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
  }) async {
    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
    };

    await _repository.crearNoticia(noticia);
  }

  Future<void> eliminarNoticia(String id) async {
    if (id.isEmpty) {
      throw Exception(
        '${NoticiaConstantes.mensajeError} El ID de la noticia no puede estar vacío.',
      );
    }

    await _repository.eliminarNoticia(id);
  }

  Future<void> editarNoticia({
    required String id,
    required String titulo,
    required String descripcion,
    required String fuente,
    required String publicadaEl,
    required String urlImagen,
  }) async {
    if (id.isEmpty) {
      throw Exception('El ID de la noticia no puede estar vacío.');
    }

    if (titulo.isEmpty || descripcion.isEmpty || fuente.isEmpty) {
      throw Exception(
        'Los campos título, descripción y fuente no pueden estar vacíos.',
      );
    }

    final noticia = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl,
      'urlImagen': urlImagen,
    };

    await _repository.editarNoticia(id, noticia);
  }
  
}
