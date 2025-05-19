import 'dart:async';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:psiemens/domain/noticia.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:psiemens/api/service/base_service.dart';

class NoticiaService extends BaseService {
  NoticiaService() : super();

  /// Obtiene todas las noticias de la API
  Future<List<Noticia>> getNoticias() async {
    try {
      final data = await get('/noticias', requireAuthToken: false);
      
      // Verificamos que la respuesta sea una lista
      if (data is List) {
        final List<dynamic> noticiasJson = data;
        debugPrint('📊 Procesando ${noticiasJson.length} noticias');
        
        return noticiasJson.map((json) {
          try {
            // Usar el método seguro para deserializar
            return Noticia.fromMapSafe(json);
          } catch (e) {
            debugPrint('❌ Error al deserializar noticia: $e');
            debugPrint('Datos problemáticos: $json');
            // Retornar null y luego filtrar los nulos
            return null;
          }
        }).where((noticia) => noticia != null).cast<Noticia>().toList();
      } else {
        debugPrint('❌ La respuesta no es una lista: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Edita una noticia en la API
  Future<void> editarNoticia(String id, Noticia noticia) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }
      
      debugPrint('🔄 Editando noticia con ID: $id');
      
      // Usar el método toMap() manual que definimos en la clase Noticia
      Map<String, dynamic> noticiaJson = noticia.toMap();
      debugPrint('📤 Datos a enviar: $noticiaJson');
    
      await put(
        '/noticias/$id',
        data: noticiaJson,
        requireAuthToken: true,
      );
      
      debugPrint('✅ Noticia editada correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en editarNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en editarNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Crea una nueva noticia en la API
  Future<void> crearNoticia(Noticia noticia) async {
    try {
      debugPrint('➕ Creando nueva noticia');
      
      // Usar el método toMap() manual que definimos en la clase Noticia
      Map<String, dynamic> noticiaJson = noticia.toMap();
      debugPrint('📤 Datos a enviar: $noticiaJson');
      
      await post(
        '/noticias',
        data: noticiaJson,
        requireAuthToken: true,
      );
      
      debugPrint('✅ Noticia creada con éxito');
    } on DioException catch (e) {
      debugPrint('❌ DioException en crearNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en crearNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }

  /// Elimina una noticia de la API
  Future<void> eliminarNoticia(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }
      
      debugPrint('🗑️ Eliminando noticia con ID: $id');
      
      await delete('/noticias/$id', requireAuthToken: true);

      debugPrint('✅ Noticia eliminada correctamente');
    } on DioException catch (e) {
      debugPrint('❌ DioException en eliminarNoticia: ${e.toString()}');
      handleError(e);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en eliminarNoticia: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  
  /// Obtiene una noticia por su ID
  Future<Noticia?> getNoticiaPorId(String id) async {
    try {
      // Validar que el ID no sea nulo o vacío
      if (id.isEmpty) {
        throw ApiException('ID de noticia inválido', statusCode: 400);
      }
      
      final data = await get('/noticias/$id', requireAuthToken: false);
      
      if (data is Map<String, dynamic>) {
        try {
          // Usar el método seguro para deserializar
          return Noticia.fromMapSafe(data);
        } catch (e) {
          debugPrint('❌ Error al deserializar noticia: $e');
          debugPrint('Datos problemáticos: $data');
          return null;
        }
      } else {
        debugPrint('❌ La respuesta no es un objeto: $data');
        throw ApiException('Formato de respuesta inválido');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException en getNoticiaPorId: ${e.toString()}');
      handleError(e);
      return null;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      debugPrint('❌ Error inesperado en getNoticiaPorId: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
}