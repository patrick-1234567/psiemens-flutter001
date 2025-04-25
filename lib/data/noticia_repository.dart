import 'dart:async';
import 'package:psiemens/domain/categoria.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:psiemens/constants.dart';

class NoticiaRepository {
  final Dio _dioNew = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de conexión
    receiveTimeout: const Duration(seconds:CategoriaConstantes.timeoutSeconds), // Tiempo de recepción
  ));
  final List<Noticia> _allNoticias = [];
  
  Future<List<Noticia>> getNoticias() async {
  try {
    // Realiza la solicitud GET a la API
    final response = await _dioNew.get(ApiConstantes.noticiasUrl);

    // Maneja el código de estado HTTP
    if (response.statusCode == 200) {
      final List<dynamic> noticiasJson = response.data;
      return noticiasJson.map((json) {
        return Noticia(
          id: json['_id'] ?? '',
          titulo: json['titulo'] ?? 'Sin título',
          descripcion: json['descripcion'] ?? 'Sin descripción',
          fuente: json['fuente'] ?? 'Fuente desconocida',
          publicadaEl: DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
          imageUrl: json['urlImagen'] ?? '',
          categoriaId: json['categoriaId'] ?? CategoriaConstantes.defaultCategoriaId,
        );
      }).toList();
    } else {
      throw Exception('Error desconocido: ${response.statusCode}');
    }
  } on DioError catch (e) {
    _handleError(e); // Llama al método centralizado para manejar el error
  } catch (e) {
    // Manejo de otros errores
    throw Exception('Error inesperado: $e');
  }
  // Agrega un throw al final para manejar cualquier caso no cubierto
  throw Exception('Error desconocido: No se pudo obtener noticias');
}


  /// Edita una noticia en la API de CrudCrud
Future<void> editarNoticia(String id, Map<String, dynamic> noticia) async {
  try {
    final url = '${ApiConstantes.noticiasUrl}/$id';
    final response = await _dioNew.put(
      url,
      data: noticia,
    );

    if (response.statusCode != 200) {
      throw Exception('Error desconocido: ${response.statusCode}');
    }
  } on DioError catch (e) {
    _handleError(e); // Llama a la función centralizada para manejar el error
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}

  /// Crea una nueva noticia en la API de CrudCrud
  Future<void> crearNoticia(Map<String, dynamic> noticia) async {
  try {
    final response = await _dioNew.post(
      ApiConstantes.noticiasUrl,
      data: noticia,
    );

    if (response.statusCode != 201) {
      throw Exception('Error desconocido: ${response.statusCode}');
    }
  } on DioError catch (e) {
    _handleError(e); // Llama a la función centralizada para manejar el error
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}

  /// Elimina una noticia de la API de CrudCrud
  Future<void> eliminarNoticia(String id) async {
  try {
    final url = '${ApiConstantes.noticiasUrl}/$id';
    final response = await _dioNew.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error desconocido: ${response.statusCode}');
    }
  } on DioError catch (e) {
    _handleError(e); // Llama a la función centralizada para manejar el error
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}

  /// Devuelve una lista de noticias paginadas
  Future<List<Noticia>> getNoticiasPaginadas({
    required int pageNumber,
    int pageSize = 5,
  }) async {
    // Calcula los índices de inicio y fin para la página solicitada
    final startIndex = (pageNumber - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Si el índice de fin está fuera del rango de la lista actual, genera más noticias
    while (_allNoticias.length < endIndex) {
      final nuevasNoticias =
          await getNoticias(); // Llama al método y espera el resultado

      // Verifica si se obtuvieron nuevas noticias
      if (nuevasNoticias.isEmpty) {
        break; // Sal del bucle si no hay más noticias
      }

      // Agrega solo las noticias que no están ya en la lista
      for (var noticia in nuevasNoticias) {
        if (!_allNoticias.contains(noticia)) {
          _allNoticias.add(noticia);
        }
      }
    }

    // Si el índice inicial está fuera del rango, devuelve una lista vacía
    if (startIndex >= _allNoticias.length) {
      return [];
    }

    // Devuelve la sublista correspondiente a la página solicitada
    return _allNoticias.sublist(
      startIndex,
      endIndex > _allNoticias.length ? _allNoticias.length : endIndex,
    );
  }

  void _handleError(DioError e) {
  if (e.type == DioErrorType.connectionTimeout || e.type == DioErrorType.receiveTimeout) {
    throw Exception(CategoriaConstantes.errorTimeout);
  }

  final statusCode = e.response?.statusCode;
  switch (statusCode) {
    case 400:
      throw Exception(FinanceConstants.errorMessage);
    case 401:
      throw Exception(ErrorConstantes.errorUnauthorized);
    case 404:
      throw Exception(ErrorConstantes.errorNotFound);
    case 500:
      throw Exception(ErrorConstantes.errorServer);
    default:
      throw Exception('Error desconocido: ${statusCode ?? 'Sin código'}');
  }
}
}
