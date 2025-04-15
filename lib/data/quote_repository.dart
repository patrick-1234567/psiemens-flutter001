import 'dart:async';
import 'package:psiemens/domain/quote.dart';

class QuoteRepository {
  Future<List<Quote>> fetchQuotes() async {
    // Simula un retraso de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    // Lista inicial de cotizaciones con el campo lastUpdated
    return [
      Quote(
        companyName: 'Apple',
        stockPrice: 150.25,
        changePercentage: 2.5,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Microsoft',
        stockPrice: 280.50,
        changePercentage: -1.2,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Google',
        stockPrice: 2750.00,
        changePercentage: 0.8,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Amazon',
        stockPrice: 3450.75,
        changePercentage: -0.5,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Tesla',
        stockPrice: 720.10,
        changePercentage: 3.1,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Netflix',
        stockPrice: 590.30,
        changePercentage: 4.2,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Meta',
        stockPrice: 340.75,
        changePercentage: -0.8,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'NVIDIA',
        stockPrice: 220.15,
        changePercentage: 2.9,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Adobe',
        stockPrice: 510.60,
        changePercentage: 1.5,
        lastUpdated: DateTime.now(),
      ),
      Quote(
        companyName: 'Samsung',
        stockPrice: 1400.50,
        changePercentage: 1.8,
        lastUpdated: DateTime.now(),
      ),
    ];
  }
}