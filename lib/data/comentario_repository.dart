import 'dart:async';
import 'package:psiemens/api/service/comentarios_service.dart';
import 'package:psiemens/domain/comentario.dart';
import 'package:psiemens/data/base_repository.dart';
import 'package:psiemens/exceptions/api_exception.dart';
import 'package:flutter/foundation.dart';

class ComentarioRepository extends BaseRepository<Comentario> {
  final ComentariosService _service = ComentariosService();
  
  @override
  ComentariosService get service => _service;

  // Cache de comentarios por noticiaId
  final Map<String, List<Comentario>> _comentariosCache = {};
  
  // Timestamp de la última actualización por noticiaId
  final Map<String, DateTime> _lastRefreshedByNoticiaId = {};
  
  // Tiempo de expiración del caché (5 minutos por defecto)
  static const Duration cacheExpiration = Duration(minutes: 5);

  /// Verifica si el caché de comentarios para una noticia ha expirado
  bool _isCacheExpired(String noticiaId) {
    final lastRefreshed = _lastRefreshedByNoticiaId[noticiaId];
    if (lastRefreshed == null) return true;
    
    final timeSinceLastRefresh = DateTime.now().difference(lastRefreshed);
    return timeSinceLastRefresh > cacheExpiration;
  }

  /// Obtiene los comentarios asociados a una noticia específica
  Future<List<Comentario>> obtenerComentariosPorNoticia(
    String noticiaId, {
    bool forceRefresh = false
  }) async {
    validarNoVacio(noticiaId, 'ID de la noticia');
    
    try {
      // Verificar si hay comentarios en caché y si no están expirados
      final bool useCache = !forceRefresh && 
                          _comentariosCache.containsKey(noticiaId) && 
                          !_isCacheExpired(noticiaId);
      
      if (useCache) {
        debugPrint('📋 Usando comentarios en caché para noticia: $noticiaId');
        return List<Comentario>.from(_comentariosCache[noticiaId]!);
      }
      
      debugPrint('🔄 Obteniendo comentarios frescos para noticia: $noticiaId');
      final comentarios = await _service.obtenerComentariosPorNoticia(noticiaId);
      
      // Actualizar caché
      _comentariosCache[noticiaId] = comentarios;
      _lastRefreshedByNoticiaId[noticiaId] = DateTime.now();
      
      debugPrint('✅ Caché actualizado para noticia $noticiaId: ${comentarios.length} comentarios');
      return comentarios;
    } catch (e) {
      debugPrint('❌ Error al obtener comentarios: ${e.toString()}');
      
      // Si hay un error pero tenemos datos en caché, devolvemos los datos en caché
      if (_comentariosCache.containsKey(noticiaId)) {
        debugPrint('⚠️ Usando caché antiguo debido a error en la obtención de datos frescos');
        return List<Comentario>.from(_comentariosCache[noticiaId]!);
      }
      
      // Si no hay caché, relanzamos la excepción
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado al obtener comentarios: $e');
    }
  }

  /// Agrega un nuevo comentario a una noticia
  Future<void> agregarComentario(
    String noticiaId,
    String texto,
    String autor,
    String fecha,
  ) async {
    validarNoVacio(noticiaId, 'ID de la noticia');
    validarNoVacio(texto, 'texto del comentario');
    validarNoVacio(autor, 'autor');
    validarNoVacio(fecha, 'fecha');
    
    try {
      // Primero guardamos en la API
      await _service.agregarComentario(
        noticiaId,
        texto,
        autor,
        fecha,
      );
      
      // Crear comentario para el caché (con ID temporal)
      final nuevoComentario = Comentario(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID temporal
        noticiaId: noticiaId,
        texto: texto,
        fecha: fecha,
        autor: autor,
        likes: 0,
        dislikes: 0,
        isSubComentario: false,
      );
      
      // Actualizar caché si existe
      if (_comentariosCache.containsKey(noticiaId)) {
        // Añadimos al inicio para que aparezca primero (comentarios más recientes primero)
        _comentariosCache[noticiaId]!.insert(0, nuevoComentario);
        _lastRefreshedByNoticiaId[noticiaId] = DateTime.now();
        debugPrint('✅ Comentario añadido al caché para noticia $noticiaId');
      } else {
        // Si no existe el caché, forzamos una recarga
        await obtenerComentariosPorNoticia(noticiaId, forceRefresh: true);
      }
    } catch (e) {
      debugPrint('❌ Error al agregar comentario: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado al agregar comentario: $e');
    }
  }

  /// Obtiene el número total de comentarios para una noticia específica
  Future<int> obtenerNumeroComentarios(String noticiaId) async {
    validarNoVacio(noticiaId, 'ID de la noticia');
    
    try {
      // Primero intentamos obtener del caché
      if (_comentariosCache.containsKey(noticiaId) && !_isCacheExpired(noticiaId)) {
        return _comentariosCache[noticiaId]!.length;
      }
      
      // Si no hay en caché, llamamos a la API
      final count = await _service.obtenerNumeroComentarios(noticiaId);
      return count;
    } catch (e) {
      debugPrint('❌ Error al obtener número de comentarios: ${e.toString()}');
      
      // Si hay caché pero expirado, lo usamos como fallback
      if (_comentariosCache.containsKey(noticiaId)) {
        return _comentariosCache[noticiaId]!.length;
      }
      
      // En caso de error sin caché, retornamos 0 como valor seguro
      return 0;
    }
  }

  /// Añade una reacción (like o dislike) a un comentario específico
  Future<void> reaccionarComentario({
    required String comentarioId,
    required String tipoReaccion,
    required String noticiaId,
  }) async {
    validarNoVacio(comentarioId, 'ID del comentario');
    validarNoVacio(tipoReaccion, 'tipo de reacción');
    validarNoVacio(noticiaId, 'ID de la noticia');
    
    try {
      // Actualizar caché optimísticamente
      bool cacheActualizado = false;
      
      if (_comentariosCache.containsKey(noticiaId)) {
        cacheActualizado = _actualizarReaccionEnCache(
          comentarioId, 
          tipoReaccion, 
          noticiaId
        );
      }
      
      // Luego llamamos a la API para persistir el cambio
      await _service.reaccionarComentario(
        comentarioId: comentarioId,
        tipoReaccion: tipoReaccion,
      );
      
      // Si no se pudo actualizar el caché, refrescamos
      if (!cacheActualizado && _comentariosCache.containsKey(noticiaId)) {
        await obtenerComentariosPorNoticia(noticiaId, forceRefresh: true);
      }
    } catch (e) {
      debugPrint('❌ Error al reaccionar al comentario: ${e.toString()}');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error inesperado al reaccionar al comentario: $e');
    }
  }

  /// Actualiza la reacción en caché
  bool _actualizarReaccionEnCache(String comentarioId, String tipoReaccion, String noticiaId) {
    bool encontrado = false;
    
    // Buscar en comentarios principales
    for (int i = 0; i < _comentariosCache[noticiaId]!.length; i++) {
      final comentario = _comentariosCache[noticiaId]![i];
      
      if (comentario.id == comentarioId) {
        // Actualizar likes o dislikes
        _comentariosCache[noticiaId]![i] = Comentario(
          id: comentario.id,
          noticiaId: comentario.noticiaId,
          texto: comentario.texto,
          fecha: comentario.fecha,
          autor: comentario.autor,
          likes: tipoReaccion == 'like' ? comentario.likes + 1 : comentario.likes,
          dislikes: tipoReaccion == 'dislike' ? comentario.dislikes + 1 : comentario.dislikes,
          subcomentarios: comentario.subcomentarios,
          isSubComentario: comentario.isSubComentario,
          idSubComentario: comentario.idSubComentario,
        );
        encontrado = true;
        break;
      }
      
      // Revisar subcomentarios
      if (!encontrado && comentario.subcomentarios != null && comentario.subcomentarios!.isNotEmpty) {
        final actualizadoEnSub = _actualizarReaccionEnSubcomentarios(
          i, comentario, comentarioId, tipoReaccion, noticiaId
        );
        
        if (actualizadoEnSub) {
          encontrado = true;
          break;
        }
      }
    }
    
    if (encontrado) {
      _lastRefreshedByNoticiaId[noticiaId] = DateTime.now();
      debugPrint('✅ Reacción ($tipoReaccion) actualizada en caché para comentario $comentarioId');
    }
    
    return encontrado;
  }

  /// Actualiza la reacción en subcomentarios
  bool _actualizarReaccionEnSubcomentarios(
    int indiceComentarioPrincipal, 
    Comentario comentarioPrincipal,
    String comentarioId, 
    String tipoReaccion, 
    String noticiaId
  ) {
    final subcomentarios = List<Comentario>.from(comentarioPrincipal.subcomentarios!);
    bool subcomentarioActualizado = false;
    
    for (int j = 0; j < subcomentarios.length; j++) {
      final subcomentario = subcomentarios[j];
      
      if (subcomentario.id == comentarioId || subcomentario.idSubComentario == comentarioId) {
        // Actualizar likes o dislikes del subcomentario
        subcomentarios[j] = Comentario(
          id: subcomentario.id,
          noticiaId: subcomentario.noticiaId,
          texto: subcomentario.texto,
          fecha: subcomentario.fecha,
          autor: subcomentario.autor,
          likes: tipoReaccion == 'like' ? subcomentario.likes + 1 : subcomentario.likes,
          dislikes: tipoReaccion == 'dislike' ? subcomentario.dislikes + 1 : subcomentario.dislikes,
          subcomentarios: subcomentario.subcomentarios,
          isSubComentario: subcomentario.isSubComentario,
          idSubComentario: subcomentario.idSubComentario,
        );
        
        // Actualizar el comentario principal con los subcomentarios modificados
        _comentariosCache[noticiaId]![indiceComentarioPrincipal] = Comentario(
          id: comentarioPrincipal.id,
          noticiaId: comentarioPrincipal.noticiaId,
          texto: comentarioPrincipal.texto,
          fecha: comentarioPrincipal.fecha,
          autor: comentarioPrincipal.autor,
          likes: comentarioPrincipal.likes,
          dislikes: comentarioPrincipal.dislikes,
          subcomentarios: subcomentarios,
          isSubComentario: comentarioPrincipal.isSubComentario,
          idSubComentario: comentarioPrincipal.idSubComentario,
        );
        
        subcomentarioActualizado = true;
        break;
      }
    }
    
    return subcomentarioActualizado;
  }

  /// Agrega un subcomentario a un comentario existente
  Future<Map<String, dynamic>> agregarSubcomentario({
    required String comentarioId,
    required String texto,
    required String autor,
    required String noticiaId,
  }) async {
    validarNoVacio(comentarioId, 'ID del comentario');
    validarNoVacio(texto, 'texto del subcomentario');
    validarNoVacio(autor, 'autor');
    validarNoVacio(noticiaId, 'ID de la noticia');

    try {
      // Actualizar caché optimísticamente si existe
      bool cacheActualizado = false;
      
      if (_comentariosCache.containsKey(noticiaId)) {
        final subcomentarioId = 'sub_${DateTime.now().millisecondsSinceEpoch}';
        final nuevoSubcomentario = Comentario(
          id: subcomentarioId,
          noticiaId: noticiaId,
          texto: texto,
          fecha: DateTime.now().toIso8601String(),
          autor: autor,
          likes: 0,
          dislikes: 0,
          isSubComentario: true,
          idSubComentario: subcomentarioId,
        );
        
        cacheActualizado = _agregarSubcomentarioEnCache(comentarioId, nuevoSubcomentario, noticiaId);
      }
      
      // Llamar a la API para persistir el cambio
      final resultado = await _service.agregarSubcomentario(
        comentarioId: comentarioId,
        texto: texto,
        autor: autor,
      );
      
      // Si no se pudo actualizar el caché o si el API falló, refrescar
      if ((!cacheActualizado && _comentariosCache.containsKey(noticiaId)) || 
          resultado['success'] != true) {
        await obtenerComentariosPorNoticia(noticiaId, forceRefresh: true);
      }
      
      return resultado;
    } catch (e) {
      debugPrint('❌ Error inesperado al agregar subcomentario: ${e.toString()}');
      
      // En caso de error, intentar refrescar el caché
      if (_comentariosCache.containsKey(noticiaId)) {
        await obtenerComentariosPorNoticia(noticiaId, forceRefresh: true);
      }
      
      return {
        'success': false,
        'message': 'Error inesperado al agregar subcomentario: ${e.toString()}'
      };
    }
  }

  /// Agrega un subcomentario al caché
  bool _agregarSubcomentarioEnCache(String comentarioId, Comentario subcomentario, String noticiaId) {
    bool encontrado = false;
    
    // Buscar el comentario principal
    for (int i = 0; i < _comentariosCache[noticiaId]!.length; i++) {
      if (_comentariosCache[noticiaId]![i].id == comentarioId) {
        // Obtener el comentario actual
        final comentario = _comentariosCache[noticiaId]![i];
        final subcomentarios = comentario.subcomentarios ?? [];
        
        // Actualizar el comentario con el nuevo subcomentario
        _comentariosCache[noticiaId]![i] = Comentario(
          id: comentario.id,
          noticiaId: comentario.noticiaId,
          texto: comentario.texto,
          fecha: comentario.fecha,
          autor: comentario.autor,
          likes: comentario.likes,
          dislikes: comentario.dislikes,
          subcomentarios: [...subcomentarios, subcomentario],
          isSubComentario: comentario.isSubComentario,
          idSubComentario: comentario.idSubComentario,
        );
        
        encontrado = true;
        break;
      }
    }
    
    if (encontrado) {
      _lastRefreshedByNoticiaId[noticiaId] = DateTime.now();
      debugPrint('✅ Subcomentario añadido al caché para comentario $comentarioId');
    } else {
      debugPrint('⚠️ No se encontró el comentario $comentarioId para añadir el subcomentario');
    }
    
    return encontrado;
  }

  /// Busca comentarios según un criterio de texto
  List<Comentario> buscarComentarios(String noticiaId, String criterio) {
    if (!_comentariosCache.containsKey(noticiaId)) {
      return [];
    }
    
    final textoBuscado = criterio.toLowerCase();
    return _comentariosCache[noticiaId]!.where((comentario) {
      final textoComentario = comentario.texto.toLowerCase();
      final autorComentario = comentario.autor.toLowerCase();
      
      return textoComentario.contains(textoBuscado) || 
             autorComentario.contains(textoBuscado);
    }).toList();
  }

  /// Limpia el caché para una noticia específica
  void limpiarCacheParaNoticia(String noticiaId) {
    _comentariosCache.remove(noticiaId);
    _lastRefreshedByNoticiaId.remove(noticiaId);
    debugPrint('🗑️ Cache limpiado para noticia $noticiaId');
  }
  
  /// Limpia todo el caché de comentarios
  @override
  void limpiarCache() {
    _comentariosCache.clear();
    _lastRefreshedByNoticiaId.clear();
    debugPrint('🗑️ Cache de comentarios limpiado completamente');
    super.limpiarCache();
  }

  @override
  Comentario fromMap(Map<String, dynamic> map) {
    return Comentario.fromMapSafe(map);
  }

  @override
  Map<String, dynamic> toMap(Comentario entity) {
    return entity.toMap();
  }
}