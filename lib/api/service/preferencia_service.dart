import 'dart:async';
import 'package:dio/dio.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/domain/preferencia.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
      receiveTimeout: const Duration(seconds: CategoriaConstantes.timeoutSeconds),
    ),
  );

  // Clave para almacenar el ID en SharedPreferences
  static const String _preferenciaIdKey = 'preferencia_id';
  
  // ID para preferencias, inicialmente nulo
  String? _preferenciaId;
  
  // Constructor que inicializa el ID desde SharedPreferences
  PreferenciaService() {
    _cargarIdGuardado();
  }
  
  Future<void> _cargarIdGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_preferenciaIdKey)) {
      _preferenciaId = prefs.getString(_preferenciaIdKey);
    } else {
      _preferenciaId = '';
    }
  }
  
  Future<void> _guardarId(String id) async {
    _preferenciaId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferenciaIdKey, id);
  }
  
  /// Obtiene las preferencias del usuario
  Future<Preferencia> getPreferencias() async {
    try {
      // Si no hay ID almacenado, devolver preferencias vacías sin consultar API
      if (_preferenciaId != null && _preferenciaId!.isNotEmpty) {
        final response = await _dio.get(
          '${ApiConstantes.preferenciaUrl}/$_preferenciaId',
        );      
        // Si la respuesta es exitosa, convertir a objeto Preferencia
        return Preferencia.fromJson(response.data);
      }   
      return await _crearPreferenciasVacias();   
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Si no existe, devolver preferencias vacías
        return await _crearPreferenciasVacias();
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
  
  /// Guarda las preferencias del usuario (Actualiza)
  Future<void> guardarPreferencias(Preferencia preferencia) async {
    try {
      await _dio.put(
        '${ApiConstantes.preferenciaUrl}/$_preferenciaId',
        data: preferencia.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de preferencias: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }

  /// Método auxiliar para crear un nuevo registro de preferencias vacías
  Future<Preferencia> _crearPreferenciasVacias() async {
    try {
      final preferenciasVacias = Preferencia.empty();
      
      // Crear un nuevo registro en la API
      final Response response = await _dio.post(
        ApiConstantes.preferenciaUrl,
        data: preferenciasVacias.toJson(),
      );
      
      // Guardar el nuevo ID
      await _guardarId(response.data['_id']);
      
      return preferenciasVacias;
    } on DioException catch (e) {
      throw ApiException(
        'Error al conectar con la API de preferencias: $e',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException('Error desconocido: $e');
    }
  }
}
