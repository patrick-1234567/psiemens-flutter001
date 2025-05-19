import 'package:dart_mappable/dart_mappable.dart';

part 'noticia.mapper.dart';


@MappableClass()
class Noticia with NoticiaMappable {
  @MappableField()
  final String? id;
  final String titulo;
  final String descripcion;
  final String fuente;
  
  @MappableField(key: 'publicadaEl')
  final DateTime publicadaEl;
  
  final String urlImagen;
  final String? categoriaId;

  const Noticia({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.urlImagen,
    this.categoriaId,
  });

  // Factory method para crear desde un mapa de forma segura
  static Noticia fromMapSafe(Map<String, dynamic> map) {
    // Manejar la fecha de forma segura
    DateTime fecha;
    try {
      if (map['publicadaEl'] is String) {
        fecha = DateTime.parse(map['publicadaEl'] as String);
      } else {
        fecha = DateTime.now();
      }
    } catch (e) {
      fecha = DateTime.now();
    }

    return Noticia(
      id: map['id'] as String?,
      titulo: map['titulo'] as String? ?? 'Sin título',
      descripcion: map['descripcion'] as String? ?? 'Sin descripción',
      fuente: map['fuente'] as String? ?? 'Fuente desconocida',
      publicadaEl: fecha,
      urlImagen: map['urlImagen'] as String? ?? '',
      categoriaId: map['categoriaId'] as String?,
    );
  }

  // Método para convertir a Map manualmente
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'urlImagen': urlImagen,
      if (categoriaId != null) 'categoriaId': categoriaId,
    };
  }
}