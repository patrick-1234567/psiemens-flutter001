class Preferencia {
  final List<String> categoriasSeleccionadas;

  Preferencia({required this.categoriasSeleccionadas});

  factory Preferencia.empty() {
    return Preferencia(categoriasSeleccionadas: []);
  }

  Preferencia copyWith({List<String>? categoriasSeleccionadas}) {
    return Preferencia(
      categoriasSeleccionadas: categoriasSeleccionadas ?? this.categoriasSeleccionadas,
    );
  }
}