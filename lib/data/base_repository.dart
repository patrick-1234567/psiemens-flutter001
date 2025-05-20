import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:psiemens/exceptions/api_exception.dart';

/// Base para todos los repositorios en la aplicación
/// Proporciona funcionalidades comunes como caché, manejo de errores,
/// y validaciones generales.
abstract class BaseRepository<T> {
  /// Servicio API asociado al repositorio
  dynamic get service;
  
  /// Duración predeterminada para la caché
  final Duration cacheDuration = const Duration(minutes: 15);
  
  /// Manager para el manejo de caché
  final CacheManager cacheManager = DefaultCacheManager();
  
  /// Marca si los datos del caché están vigentes
  bool _cacheValido = false;
  
  /// Datos en caché
  Map<String, dynamic> _cache = {};
  
  /// Obtiene datos con manejo de errores y caché
  /// 
  /// [fetchFunction] es la función que obtiene los datos desde el servicio API
  /// [cacheKey] es la clave para almacenar los datos en caché
  /// [usarCache] indica si se debe utilizar el caché para esta petición
  Future<List<T>> obtenerDatos({
    required Future<List<T>> Function() fetchFunction,
    required String cacheKey,
    bool usarCache = true,
  }) async {
    // Verificar si hay datos en caché válidos
    if (usarCache && _cacheValido && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey] as List<T>;
    }
    
    try {
      final datos = await fetchFunction();
      
      // Almacenar en caché si se requiere
      if (usarCache) {
        _cache[cacheKey] = datos;
        _cacheValido = true;
        
        // Programar invalidación del caché
        Timer(cacheDuration, () {
          _cacheValido = false;
        });
      }
      
      return datos;
    } catch (e) {
      return _manejarError<List<T>>(e, 'Error al obtener datos.');
    }
  }
  
  /// Realiza una operación con manejo de errores
  /// 
  /// [operation] es la función que realiza la operación en el servicio API
  /// [errorMessage] es el mensaje de error personalizado
  Future<void> ejecutarOperacion({
    required Future<void> Function() operation,
    required String errorMessage,
  }) async {
    try {
      await operation();
      // Invalida el caché después de operaciones de escritura
      _cacheValido = false;
    } catch (e) {
      _manejarError<void>(e, errorMessage);
    }
  }
  
  /// Método genérico para manejo de errores
  /// 
  /// [error] es la excepción capturada
  /// [mensajeError] es el mensaje para mostrar al usuario
  T _manejarError<T>(dynamic error, String mensajeError) {
    if (error is ApiException) {
      throw error; // Relanza la excepción para que la maneje la capa superior
    }
    
    debugPrint('Error inesperado: $error');
    throw ApiException(mensajeError);
  }
  
  /// Valida que un valor no esté vacío
  /// 
  /// [valor] es el valor a validar
  /// [campo] es el nombre del campo para el mensaje de error
  void validarNoVacio(String valor, String campo) {
    if (valor.isEmpty) {
      throw ApiException('El campo $campo no puede estar vacío.');
    }
  }
  
  /// Limpia el caché del repositorio
  void limpiarCache() {
    _cache.clear();
    _cacheValido = false;
  }
}