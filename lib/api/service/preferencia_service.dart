import 'dart:async';
import 'package:dio/dio.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/domain/preferencia.dart';
import 'package:psiemens/exceptions/api_exception.dart';

class PreferenciaService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
      receiveTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
    ),
  );

  // ID fijo para las preferencias globales
  final String preferenciaId = 'global_preferences';
  
  /// Obtiene las preferencias del usuario
  Future<Preferencia> getPreferencias() async {
    try {
      // Intentamos obtener el registro con ID conocido
      final response = await _dio.get(
        '${ApiConstantes.preferenciaUrl}/$preferenciaId',
      );
      
      // Si la respuesta es exitosa, convertir a objeto Preferencia
      return Preferencia.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Si no existe, devolver preferencias vacías
        // (se crearán cuando se guarden por primera vez)
        return Preferencia.empty();
      } else {
        throw ApiException(
          'Error al conectar con la API de preferencias: $e',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
  
  /// Guarda las preferencias del usuario (crea o actualiza según sea necesario)
  Future<void> guardarPreferencias(Preferencia preferencia) async {
    try {
      // Intentar actualizar primero (PUT)
      await _dio.put(
        '${ApiConstantes.preferenciaUrl}/$preferenciaId',
        data: preferencia.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Si el registro no existe (404), crear uno nuevo (POST)
        final Map<String, dynamic> data = preferencia.toJson();
        data['_id'] = preferenciaId;
        
        await _dio.post(
          ApiConstantes.preferenciaUrl,
          data: data,
        );
      } else {
        throw ApiException(
          'Error al conectar con la API de preferencias: $e',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
}
