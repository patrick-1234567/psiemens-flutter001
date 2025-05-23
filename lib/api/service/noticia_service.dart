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
}
