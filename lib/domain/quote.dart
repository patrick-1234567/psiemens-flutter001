class Quote {
  final String companyName; // Nombre de la compañía
  final double stockPrice; // Precio de la acción
  final double changePercentage; // Porcentaje de cambio
  final DateTime lastUpdated; // Última actualización de la cotización

  Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    required this.lastUpdated,
  });
}