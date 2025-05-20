import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'comentario.mapper.dart';

@MappableClass()
class Comentario with ComentarioMappable {
  @MappableField()
  final String? id; // Cambiado a nullable
  final String noticiaId;
  final String texto;
  final String fecha;
  final String autor;
  final int likes;
  final int dislikes;
  // Nuevo campo para almacenar el ID del usuario que comenta
  final String? userId;

  final List<Comentario>? subcomentarios;
  final bool isSubComentario;
  final String? idSubComentario;

  Comentario({
    this.id,
    required this.noticiaId,
    required this.texto,
    required this.fecha,
    required this.autor,
    required this.likes,
    required this.dislikes,
    this.userId, // Nuevo campo opcional
    this.subcomentarios,
    this.isSubComentario = false,
    this.idSubComentario,
  });

  // Método factory para crear desde un mapa de forma segura
  static Comentario fromMapSafe(Map<String, dynamic> map) {
    // Código existente para procesar subcomentarios
    List<Comentario>? subcomentariosList;
    if (map['subcomentarios'] != null) {
      // código existente...
    }

    return Comentario(
      id: map['id'] as String?,
      noticiaId: map['noticiaId'] as String? ?? '',
      texto: map['texto'] as String? ?? '',
      fecha: map['fecha'] as String? ?? DateTime.now().toIso8601String(),
      autor: map['autor'] as String? ?? 'Desconocido',
      likes: map['likes'] as int? ?? 0,
      dislikes: map['dislikes'] as int? ?? 0,
      userId: map['userId'] as String?, // Extraer el userId del mapa
      subcomentarios: subcomentariosList,
      isSubComentario: map['isSubComentario'] as bool? ?? false,
      idSubComentario: map['idSubComentario'] as String?,
    );
  }

  // Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'noticiaId': noticiaId,
      'texto': texto,
      'fecha': fecha,
      'autor': autor,
      'likes': likes,
      'dislikes': dislikes,
      if (userId != null) 'userId': userId, // Incluir userId solo si no es nulo
      if (subcomentarios != null) 'subcomentarios': subcomentarios!.map((c) => c.toMap()).toList(),
      'isSubComentario': isSubComentario,
      if (idSubComentario != null) 'idSubComentario': idSubComentario,
    };
  }
}