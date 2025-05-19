import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'comentario.mapper.dart';

@MappableClass()
class Comentario with ComentarioMappable {
  @MappableField()
  final String? id; // Cambiado a nullable
  final String noticiaId; //
  final String texto; //
  final String fecha; //
  final String autor; //
  final int likes; //
  final int dislikes; //

  final List<Comentario>? subcomentarios;
  // isSubComentario es requerido con valor por defecto
  final bool isSubComentario; // Nuevo campo para indicar si es subcomentario

  final String? idSubComentario; // idNoticia es opcional

  Comentario({
    this.id, // id ahora es opcional
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
    this.subcomentarios,
    this.isSubComentario = false, // Valor por defecto
    this.idSubComentario, // idSubComentario es opcional
  });

  // Método factory para mapear manualmente en caso de problemas
  static Comentario fromMapSafe(Map<String, dynamic> map) {
    // Procesar los subcomentarios de forma segura
    List<Comentario>? subcomentariosList;
    if (map['subcomentarios'] != null) {
      try {
        if (map['subcomentarios'] is List) {
          final List<dynamic> subList = map['subcomentarios'];
          subcomentariosList = subList.map<Comentario>((item) {
            // Manejar tanto mapas como strings
            if (item is Map<String, dynamic>) {
              return ComentarioMapper.fromMap(item);
            } else if (item is String) {
              // Intentar parsear la string como JSON
              try {
                final Map<String, dynamic> parsed = 
                    Map<String, dynamic>.from(
                        ComentarioMapper.fromJson(item).toMap());
                return ComentarioMapper.fromMap(parsed);
              } catch (e) {
                debugPrint('Error al procesar subcomentario string: $e');
                // Devolver un comentario vacío en caso de error
                return Comentario(
                  noticiaId: map['noticiaId'] ?? '',
                  texto: 'Error en comentario',
                  fecha: DateTime.now().toIso8601String(),
                  autor: 'Sistema',
                  likes: 0,
                  dislikes: 0,
                  isSubComentario: true,
                );
              }
            } else {
              // Devolver un comentario vacío
              return Comentario(
                noticiaId: map['noticiaId'] ?? '',
                texto: 'Formato de comentario inválido',
                fecha: DateTime.now().toIso8601String(),
                autor: 'Sistema',
                likes: 0,
                dislikes: 0,
                isSubComentario: true,
              );
            }
          }).toList();
        }
      } catch (e) {
        debugPrint('❌ Error al procesar subcomentarios: $e');
        subcomentariosList = [];
      }
    }

    return Comentario(
      id: map['id'] as String?,
      noticiaId: map['noticiaId'] as String? ?? '',
      texto: map['texto'] as String? ?? '',
      fecha: map['fecha'] as String? ?? DateTime.now().toIso8601String(),
      autor: map['autor'] as String? ?? 'Desconocido',
      likes: map['likes'] as int? ?? 0,
      dislikes: map['dislikes'] as int? ?? 0,
      subcomentarios: subcomentariosList,
      isSubComentario: map['isSubComentario'] as bool? ?? false,
      idSubComentario: map['idSubComentario'] as String?,
    );
  }
}
