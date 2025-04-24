class Noticia {
  final String id;
  final String titulo;
  final String descripcion;
  final String fuente;
  final DateTime publicadaEl;
  final String imageUrl;

  Noticia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fuente,
    required this.publicadaEl,
    required this.imageUrl,
  });

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fuente': fuente,
      'publicadaEl': publicadaEl.toIso8601String(),
      'urlImagen': imageUrl,
    };
  }

  // Método para crear una instancia desde un mapa (opcional)
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['_id'] ?? '',
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fuente: json['fuente'] ?? 'Fuente desconocida',
      publicadaEl: DateTime.tryParse(json['publicadaEl'] ?? '') ?? DateTime.now(),
      imageUrl: json['urlImagen'] ?? '',
    );
  }
}