import 'package:dio/dio.dart';
import 'package:psiemens/domain/categoria.dart';
import 'package:psiemens/constants.dart';

class CategoriaRepository {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de conexión
    receiveTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds), // Tiempo de recepción
  ));

  /// Manejo centralizado de errores
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

  /// Obtiene todas las categorías desde la API
  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get(ApiConstantes.categoriaUrl);

      if (response.statusCode == 200) {
        final List<dynamic> categoriasJson = response.data;
        return categoriasJson.map((json) => Categoria.fromJson(json)).toList();
      } else {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioError catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
    throw Exception('Error desconocido: No se pudo obtener las categorías');
  }

  /// Crea una nueva categoría en la API
  Future<void> crearCategoria(Map<String, dynamic> categoria) async {
    try {
      final response = await _dio.post(
        ApiConstantes.categoriaUrl,
        data: categoria,
      );

      if (response.statusCode != 201) {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioError catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  /// Edita una categoría existente en la API
  Future<void> editarCategoria(String id, Map<String, dynamic> categoria) async {
    try {
      final url = '${ApiConstantes.categoriaUrl}/$id';
      final response = await _dio.put(url, data: categoria);

      if (response.statusCode != 200) {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioError catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  /// Elimina una categoría de la API
  Future<void> eliminarCategoria(String id) async {
    try {
      final url = '${ApiConstantes.categoriaUrl}/$id';
      final response = await _dio.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error desconocido: ${response.statusCode}');
      }
    } on DioError catch (e) {
      _handleError(e); // Llama al método centralizado para manejar el error
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}