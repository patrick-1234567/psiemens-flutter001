import 'package:dart_mappable/dart_mappable.dart';

part 'categoria.mapper.dart';

@MappableClass()
class Categoria with CategoriaMappable {
  @MappableField()
  final String? id;
  final String nombre;
  final String descripcion;
  final String? imagenUrl;

  const Categoria({
    this.id,
    required this.nombre,
    required this.descripcion,
    this.imagenUrl,
  });

  // Factory method para crear desde un mapa de forma segura
  static Categoria fromMapSafe(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'] as String?,
      nombre: map['nombre'] as String? ?? 'Sin nombre',
      descripcion: map['descripcion'] as String? ?? 'Sin descripción',
      imagenUrl: map['imagenUrl'] as String?,
    );
  }

  // Factory method para crear desde json usando el mapper
  factory Categoria.fromJson(Map<String, dynamic> json) => 
      CategoriaMapper.fromMap(json);

  // Método para crear una instancia vacía
  factory Categoria.empty() => const Categoria(
    nombre: '',
    descripcion: '',
  );
}