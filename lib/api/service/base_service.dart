import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:psiemens/helpers/error_helper.dart';

/// Servicio base que centraliza las operaciones HTTP usando Dio
/// Proporciona métodos para realizar peticiones GET, POST, PUT y DELETE
class BaseService {
  final Dio _dio;
  final String baseUrl;

  /// Constructor que recibe una URL base opcional
  /// Si no se proporciona, se usará por defecto la URL base de la API
  BaseService({String? baseUrl}) 
    : baseUrl = baseUrl ?? ApiConstantes.newsurl,
      _dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
        receiveTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
      ));

  /// Realiza una petición GET a la URL especificada
  /// [endpoint] es la parte final de la URL
  /// [queryParameters] son los parámetros de consulta opcionales
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final url = '$baseUrl/$endpoint';
      final response = await _dio.get(
        url, 
        queryParameters: queryParameters,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      debugPrint('Error inesperado en GET $endpoint: $e');
      throw ApiException('Error inesperado al realizar la petición GET.');
    }
  }

  /// Realiza una petición POST a la URL especificada
  /// [endpoint] es la parte final de la URL
  /// [data] son los datos a enviar en el cuerpo de la petición
  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final url = '$baseUrl/$endpoint';
      final response = await _dio.post(
        url, 
        data: data,
      );

      return _handleResponse(response, expectedCode: 201);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      debugPrint('Error inesperado en POST $endpoint: $e');
      throw ApiException('Error inesperado al realizar la petición POST.');
    }
  }

  /// Realiza una petición PUT a la URL especificada
  /// [endpoint] es la parte final de la URL
  /// [id] es el identificador del recurso a actualizar
  /// [data] son los datos a enviar en el cuerpo de la petición
  Future<dynamic> put(String endpoint, String id, {dynamic data}) async {
    try {
      final url = '$baseUrl/$endpoint/$id';
      final response = await _dio.put(
        url, 
        data: data,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      debugPrint('Error inesperado en PUT $endpoint/$id: $e');
      throw ApiException('Error inesperado al realizar la petición PUT.');
    }
  }

  /// Realiza una petición DELETE a la URL especificada
  /// [endpoint] es la parte final de la URL
  /// [id] es el identificador del recurso a eliminar
  Future<dynamic> delete(String endpoint, String id) async {
    try {
      final url = '$baseUrl/$endpoint/$id';
      final response = await _dio.delete(url);

      return _handleResponse(response, expectedCodes: [200, 204]);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      debugPrint('Error inesperado en DELETE $endpoint/$id: $e');
      throw ApiException('Error inesperado al realizar la petición DELETE.');
    }
  }

  /// Procesa la respuesta HTTP y verifica que el código de estado sea el esperado
  /// [response] es la respuesta HTTP
  /// [expectedCode] es el código de estado esperado (por defecto 200)
  /// [expectedCodes] es una lista de códigos de estado esperados (opcional)
  dynamic _handleResponse(Response response, {int expectedCode = 200, List<int>? expectedCodes}) {
    final validCodes = expectedCodes ?? [expectedCode];
    
    if (validCodes.contains(response.statusCode)) {
      return response.data;
    } else {
      throw ApiException(
        'Error en la respuesta del servidor', 
        statusCode: response.statusCode
      );
    }
  }

  /// Centraliza el manejo de errores de Dio
  /// [e] es la excepción de tipo DioException
  ApiException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException(CategoriaConstantes.errorTimeout);
    }

    final statusCode = e.response?.statusCode;
    final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
    
    return ApiException(
      errorData['message'] as String, 
      statusCode: statusCode
    );
  }
}