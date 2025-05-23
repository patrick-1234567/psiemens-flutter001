import 'dart:async';
import 'dart:math';
import 'package:psiemens/domain/quote.dart';
import 'package:psiemens/data/base_repository.dart';
import 'package:psiemens/exceptions/api_exception.dart';

class QuoteRepository extends CacheableRepository<Quote> {
  final Random _random = Random();
  
  // Lista de nombres de compañías de ejemplo para usar
  final List<String> _exampleCompanyNames = [
    'Apple', 'Microsoft', 'Google', 'Amazon', 'Tesla', 'Netflix', 'Meta',
    'NVIDIA', 'Adobe', 'Samsung', 'Intel', 'AMD', 'Oracle', 'IBM', 'Salesforce',
    'Cisco', 'Qualcomm', 'Broadcom', 'Texas Instruments', 'SAP', 'Accenture',
    'Infosys', 'TCS', 'Wipro', 'HCL Tech'
  ];
  
  @override
  void validarEntidad(Quote quote) {
    validarNoVacio(quote.companyName, 'nombre de la compañía');
    if (quote.stockPrice < 0) {
      throw ApiException('El precio de la acción no puede ser negativo', statusCode: 400);
    }
  }
  
  @override
  Future<List<Quote>> cargarDatos() async {
    // Simula un retraso
    await Future.delayed(const Duration(seconds: 1));

    // Lista fija de cotizaciones
    return [
      Quote(
        companyName: 'Apple',
        stockPrice: 150.25,
        changePercentage: 9.9,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Quote(
        companyName: 'Microsoft',
        stockPrice: 280.50,
        changePercentage: -1.2,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Quote(
        companyName: 'Google',
        stockPrice: 2750.00,
        changePercentage: 0.8,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      Quote(
        companyName: 'Amazon',
        stockPrice: 3450.75,
        changePercentage: -0.5,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      Quote(
        companyName: 'Tesla',
        stockPrice: 720.10,
        changePercentage: 3.1,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      Quote(
        companyName: 'Netflix',
        stockPrice: 590.30,
        changePercentage: 4.2,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      Quote(
        companyName: 'Meta',
        stockPrice: 340.75,
        changePercentage: -0.8,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Quote(
        companyName: 'NVIDIA',
        stockPrice: 220.15,
        changePercentage: 2.9,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
      Quote(
        companyName: 'Adobe',
        stockPrice: 510.60,
        changePercentage: 1.5,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      Quote(
        companyName: 'Samsung',
        stockPrice: 1400.50,
        changePercentage: 1.8,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      Quote(
        companyName: 'Intel',
        stockPrice: 55.20,
        changePercentage: -0.2,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      Quote(
        companyName: 'AMD',
        stockPrice: 105.80,
        changePercentage: 1.1,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 7)),
      ),
    ];
  }

  /// Genera una lista de cotizaciones con datos aleatorios.
  ///
  /// [count] El número de cotizaciones aleatorias a generar.
  Future<List<Quote>> generateRandomQuotes(int count) async {
    return manejarExcepcion(() async {
      // Simula un pequeño retraso
      await Future.delayed(Duration(milliseconds: _random.nextInt(500) + 100));

      List<Quote> randomQuotes = [];
      for (int i = 0; i < count; i++) {
        // Selecciona un nombre aleatorio de la lista
        final companyName = _exampleCompanyNames[_random.nextInt(_exampleCompanyNames.length)];

        // Genera un precio de acción aleatorio
        final stockPrice = _random.nextDouble() * 3990.0 + 10.0;

        // Genera un porcentaje de cambio aleatorio
        final changePercentage = (_random.nextDouble() * 30.0) - 15.0;

        // Genera una fecha de actualización aleatoria
        final lastUpdated = DateTime.now().subtract(Duration(minutes: _random.nextInt(30)));

        randomQuotes.add(Quote(
          companyName: '${companyName}_${i+1}',
          stockPrice: stockPrice,
          changePercentage: changePercentage,
          lastUpdated: lastUpdated,
        ));
      }
      
      // Invalidar la caché para que se use esta nueva lista aleatoria
      invalidarCache();
      
      return randomQuotes;
    }, mensajeError: 'Error al generar cotizaciones aleatorias');
  }

  /// Obtiene una lista predefinida de cotizaciones.
  Future<List<Quote>> fetchQuotes() async {
    return obtenerDatos();
  }
}