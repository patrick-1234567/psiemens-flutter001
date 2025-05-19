import 'dart:async';
import 'package:dio/dio.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/core/api_config.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:psiemens/helpers/error_helper.dart';
import 'package:psiemens/helpers/secure_storage_service.dart';
import 'package:psiemens/helpers/connectivity_service.dart';
import 'package:flutter/foundation.dart';

/// Clase base para todos los servicios de la API.
/// Proporciona configuración común y manejo de errores centralizado.
class BaseService {
  /// Cliente HTTP Dio
  late final Dio _dio;
  
  /// Servicio para almacenamiento seguro
  final SecureStorageService _secureStorage = SecureStorageService();
  
  /// Servicio para verificar la conectividad a Internet
  final ConnectivityService _connectivityService = ConnectivityService();
  
  /// Constructor
  BaseService() {
    _initializeDio();
  }
  
  /// Inicializa el cliente Dio con configuraciones comunes
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.beeceptorBaseUrl,
      connectTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
      receiveTimeout: const Duration(seconds: ApiConstantes.timeoutSeconds),
      headers: {
        'Authorization': 'Bearer ${ApiConfig.beeceptorApiKey}',
        'Content-Type': 'application/json',
      },
    ));
    
     // Interceptor para añadir el token JWT a cada solicitud
     /*
     _dio.interceptors.add(InterceptorsWrapper(
       onRequest: (options, handler) async {
         await _addAuthToken(options, handler);
       },
     ));
  }

  // Añade el token de autenticación a las solicitudes (método antiguo)
   Future<void> _addAuthToken(RequestOptions options, RequestInterceptorHandler handler) async {
     final jwt = await _secureStorage.getJwt();
     if (jwt != null && jwt.isNotEmpty) {
       options.headers['X-Auth-Token'] = jwt;
       handler.next(options);
     } else {
       handler.reject(
         DioException(
           requestOptions: options,
           error: 'No se encontró el token de autenticación',
           type: DioExceptionType.unknown,
         ),
       );
     }
     */
   }
  /// Obtiene opciones de solicitud con token de autenticación si es requerido
  Future<Options> _getRequestOptions({bool requireAuthToken = false}) async {
    final options = Options();
    
    if (requireAuthToken) {
      final jwt = await _secureStorage.getJwt();
      if (jwt != null && jwt.isNotEmpty) {
        options.headers = {
          ...(options.headers ?? {}),
          'X-Auth-Token': jwt,
        };
      } else {
        throw ApiException(
          'No se encontró el token de autenticación',
          statusCode: 401,
        );
      }
    }
    
    return options;
  }
  /// Verifica la conectividad antes de realizar una solicitud
  Future<void> _checkConnectivityBeforeRequest() async {
    await _connectivityService.checkConnectivity();

  }
  
  /// Manejo centralizado de errores para servicios
  void handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ApiException(ApiConstantes.errorTimeout);
    }

    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 400:
        throw ApiException('Solicitud incorrecta', statusCode: 400);
      case 401:
        throw ApiException(ApiConstantes.errorUnauthorized, statusCode: 401);
      case 404:
        throw ApiException(ApiConstantes.errorNotFound, statusCode: 404);
      case 500:
        throw ApiException(ApiConstantes.errorServer, statusCode: 500);
      default:
        final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
        throw ApiException(
          errorData['message'] ?? 'Error desconocido: ${statusCode ?? 'Sin código'}',
          statusCode: statusCode,
        );
    }
  }
    /// Método GET genérico
  Future<dynamic> get(String path, {
    Map<String, dynamic>? queryParameters,
    bool requireAuthToken = false,
  }) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      
      debugPrint('🔍 GET: ${ApiConfig.beeceptorBaseUrl}$path');
      final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow;
    } on DioException catch (e) {
      debugPrint('❌ DioException en GET $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en GET $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
    /// Método POST genérico
  Future<dynamic> post(String path, {
    dynamic data,
    bool requireAuthToken = false,
  }) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      
      debugPrint('📤 POST: ${ApiConfig.beeceptorBaseUrl}$path');
      final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
      final response = await _dio.post(
        path,
        data: data,
        options: options,
      );
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow;
    } on DioException catch (e) {
      debugPrint('❌ DioException en POST $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en POST $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
    /// Método PUT genérico
  Future<dynamic> put(String path, {
    dynamic data,
    bool requireAuthToken = false,
  }) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      
      debugPrint('📝 PUT: ${ApiConfig.beeceptorBaseUrl}$path');
      final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
      final response = await _dio.put(
        path,
        data: data,
        options: options,
      );
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow; 
    } on DioException catch (e) {
      debugPrint('❌ DioException en PUT $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en PUT $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
    /// Método DELETE genérico
  Future<dynamic> delete(String path, {
    bool requireAuthToken = false,
  }) async {
    try {
      // Verificar conectividad antes de realizar la solicitud
      await _checkConnectivityBeforeRequest();
      
      debugPrint('🗑️ DELETE: ${ApiConfig.beeceptorBaseUrl}$path');
      final options = await _getRequestOptions(requireAuthToken: requireAuthToken);
      final response = await _dio.delete(
        path,
        options: options,
      );
      
      debugPrint('✅ Respuesta recibida: ${response.statusCode}');
      return response.data;
    } on ApiException {
      // Re-lanzar excepciones de API (incluidas las de conectividad)
      rethrow;
    } on DioException catch (e) {
      debugPrint('❌ DioException en DELETE $path: ${e.toString()}');
      debugPrint('URL: ${e.requestOptions.uri}');
      handleError(e);
    } catch (e) {
      debugPrint('❌ Error inesperado en DELETE $path: ${e.toString()}');
      throw ApiException('Error inesperado: $e');
    }
  }
  
  /// Acceso protegido al cliente Dio para casos especiales
  Dio get dio => _dio;
  
  /// Acceso al servicio de conectividad
  ConnectivityService get connectivityService => _connectivityService;
}
