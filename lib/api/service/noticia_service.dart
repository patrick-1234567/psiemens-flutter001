import 'package:psiemens/api/service/base_service.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/domain/noticia.dart';

class NoticiaService extends BaseService {
  /// Obtiene todas las noticias desde la API
  Future<List<Noticia>> obtenerNoticias() async {
    final List<dynamic> noticiasJson = await get<List<dynamic>>(
      ApiConstantes.noticiasEndpoint,
      errorMessage: NoticiaConstantes.mensajeError,
    );

    return noticiasJson
        .map<Noticia>(
          (json) => NoticiaMapper.fromMap(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Crea una nueva noticia en la API
  Future<Noticia> crearNoticia(Noticia noticia) async {
    final response = await post(
      ApiConstantes.noticiasEndpoint,
      data: noticia.toMap(),
      errorMessage: NoticiaConstantes.errorCreated,
    );
    return NoticiaMapper.fromMap(response);
  }

  /// Edita una noticia existente en la API
  Future<Noticia> editarNoticia(Noticia noticia) async {
    final url = '${ApiConstantes.noticiasEndpoint}/${noticia.id}';
    final response = await put(
      url,
      data: noticia.toMap(),
      errorMessage: NoticiaConstantes.errorUpdated,
    );
    return NoticiaMapper.fromMap(response);
  }

  /// Elimina una noticia existente en la API
  Future<void> eliminarNoticia(String id) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$id';
    await delete(url, errorMessage: NoticiaConstantes.errorDelete);
  }

  /// Verifica si una noticia existe en la API
  Future<void> verificarNoticiaExiste(String noticiaId) async {
    await get(
      '${ApiConstantes.noticiasEndpoint}?noticiaId=$noticiaId',
      errorMessage: NoticiaConstantes.errorVerificarNoticiaExiste,
    );
  }

  /// Incrementa el contador de reportes de una noticia
  Future<Map<String, dynamic>> incrementarContadorReportes(
    String noticiaId,
    int valor,
  ) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$noticiaId';

    // Usamos PATCH para actualizar parcialmente solo el contador de reportes
    final response = await patch(
      url,
      data: {'contadorReportes': valor},
      errorMessage: NoticiaConstantes.errorActualizarContadorReportes,
    );

    return response as Map<String, dynamic>;
  }

  /// Incrementa el contador de reportes de una noticia
  Future<Map<String, dynamic>> incrementarContadorComentarios(
    String noticiaId,
    int valor,
  ) async {
    final url = '${ApiConstantes.noticiasEndpoint}/$noticiaId';

    // Usamos PATCH para actualizar parcialmente solo el contador de reportes
    final response = await patch(
      url,
      data: {'contadorComentarios': valor},
      errorMessage: NoticiaConstantes.errorActualizarContadorComentarios,
    );

    return response as Map<String, dynamic>;
  }
}
