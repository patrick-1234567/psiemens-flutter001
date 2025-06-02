import 'package:psiemens/api/service/noticia_service.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/data/base_repository.dart';
import 'package:psiemens/data/comentario_repository.dart';
import 'package:psiemens/data/reporte_repository.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:watch_it/watch_it.dart';

/// Repositorio para gestionar operaciones relacionadas con las noticias.
/// Extiende BaseRepository para aprovechar la gestión de errores estandarizada.
class NoticiaRepository extends BaseRepository<Noticia> {
  final NoticiaService _noticiaService = di<NoticiaService>();
  final reporteRepo = di<ReporteRepository>();
  final _comentarioRepositorio = di<ComentarioRepository>();

  @override
  void validarEntidad(Noticia noticia) {
    validarNoVacio(noticia.titulo, ValidacionConstantes.tituloNoticia);
    validarNoVacio(
      noticia.descripcion,
      ValidacionConstantes.descripcionNoticia,
    );
    validarNoVacio(noticia.fuente, ValidacionConstantes.fuenteNoticia);

    // Validación adicional para la fecha usando el método genérico
    validarFechaNoFutura(
      noticia.publicadaEl,
      ValidacionConstantes.fechaNoticia,
    );
  }

  /// Obtiene todas las noticias desde el repositorio
  Future<List<Noticia>> obtenerNoticias() async {
    return manejarExcepcion(
      () => _noticiaService.obtenerNoticias(),
      mensajeError: NoticiaConstantes.mensajeError,
    );
  }

  /// Crea una nueva noticia
  Future<Noticia> crearNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.crearNoticia(noticia);
    }, mensajeError: NoticiaConstantes.errorCreated);
  }

  /// Edita una noticia existente
  Future<Noticia> editarNoticia(Noticia noticia) async {
    return manejarExcepcion(() {
      validarEntidad(noticia);
      return _noticiaService.editarNoticia(noticia);
    }, mensajeError: NoticiaConstantes.errorUpdated);
  }

  /// Elimina una noticia y sus reportes asociados
  Future<void> eliminarNoticia(String id) async {
    return manejarExcepcion(() async {
      validarId(id);
      await reporteRepo.eliminarReportesPorNoticia(id);
      await _comentarioRepositorio.eliminarComentariosPorNoticia(id);
      await _noticiaService.eliminarNoticia(id);
    }, mensajeError: NoticiaConstantes.errorDelete);
  }

  /// Incrementa el contador de reportes de una noticia y devuelve solo los campos actualizados
  Future<Map<String, dynamic>> incrementarContadorReportes(
    String noticiaId,
    int valor,
  ) async {
    return manejarExcepcion(() {
      validarId(noticiaId);
      return _noticiaService.incrementarContadorReportes(noticiaId, valor);
    }, mensajeError: NoticiaConstantes.errorActualizarContadorReportes);
  }

  /// Incrementa el contador de comentarios de una noticia y devuelve solo los campos actualizados
  Future<Map<String, dynamic>> incrementarContadorComentarios(
    String noticiaId,
    int valor,
  ) async {
    return manejarExcepcion(() {
      validarId(noticiaId);
      return _noticiaService.incrementarContadorComentarios(noticiaId, valor);
    }, mensajeError: NoticiaConstantes.errorActualizarContadorComentarios);
  }
}
