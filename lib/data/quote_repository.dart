import 'dart:async';
import 'dart:math'; // Necesario para Random
import 'package:psiemens/domain/quote.dart';

class QuoteRepository {
  final Random _random = Random(); // Instancia de Random para generar valores

  // Lista de nombres de compañías de ejemplo para usar
  final List<String> _exampleCompanyNames = [
    'Apple', 'Microsoft', 'Google', 'Amazon', 'Tesla', 'Netflix', 'Meta',
    'NVIDIA', 'Adobe', 'Samsung', 'Intel', 'AMD', 'Oracle', 'IBM', 'Salesforce',
    'Cisco', 'Qualcomm', 'Broadcom', 'Texas Instruments', 'SAP', 'Accenture',
    'Infosys', 'TCS', 'Wipro', 'HCL Tech'
  ];

  /// Genera una lista de cotizaciones con datos aleatorios.
  ///
  /// [count] El número de cotizaciones aleatorias a generar.
  Future<List<Quote>> generateRandomQuotes(int count) async {
    // Simula un pequeño retraso, como si se estuvieran generando o buscando
    await Future.delayed(Duration(milliseconds: _random.nextInt(500) + 100));

    List<Quote> randomQuotes = [];
    for (int i = 0; i < count; i++) {
      // Selecciona un nombre aleatorio de la lista
      final companyName = _exampleCompanyNames[_random.nextInt(_exampleCompanyNames.length)];

      // Genera un precio de acción aleatorio (ej: entre 10.00 y 4000.00)
      final stockPrice = _random.nextDouble() * 3990.0 + 10.0;

      // Genera un porcentaje de cambio aleatorio (ej: entre -15.0 y +15.0)
      // Asegurándose de que esté dentro del rango -100 a 100
      final changePercentage = (_random.nextDouble() * 30.0) - 15.0; // Rango -15 a +15

      // Genera una fecha de actualización aleatoria en los últimos 30 minutos
      final lastUpdated = DateTime.now().subtract(Duration(minutes: _random.nextInt(30)));

      randomQuotes.add(Quote(
        companyName: '${companyName}_${i+1}', // Añade un sufijo para unicidad si es necesario
        stockPrice: stockPrice,
        changePercentage: changePercentage,
        lastUpdated: lastUpdated,
      ));
    }
    return randomQuotes;
  }


  /// Fetches a predefined list of quotes (método original).
  Future<List<Quote>> fetchQuotes() async {
    // Simula un retraso
    await Future.delayed(const Duration(seconds: 1)); // Reducido para pruebas más rápidas si se desea

    // Lista fija de cotizaciones (como la tenías antes)
    // Asegúrate de que esta lista también tenga datos variados si la usas
    return [
       Quote(
        companyName: 'Apple',
        stockPrice: 150.25,
        // ¡Ojo! Este valor 99 será filtrado por tu servicio si mantienes la validación -100 a 100
        // Considera cambiarlo a un valor dentro del rango válido, ej: 9.9
        changePercentage: 9.9, // Cambiado de 99
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
      // Puedes añadir más si quieres que la lista fija sea más larga
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
}