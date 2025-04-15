import 'package:flutter/material.dart';
import 'package:psiemens/api/service/quote_service.dart'; // Asegúrate que la ruta sea correcta
import 'package:psiemens/data/quote_repository.dart'; // Asegúrate que la ruta sea correcta
import 'package:psiemens/domain/quote.dart'; // Asegúrate que la ruta sea correcta

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  // Instancia del servicio (Idealmente, esto se inyectaría con un gestor de dependencias)
  late final QuoteService _quoteService;

  // Estado para manejar la carga y los datos
  Future<List<Quote>>? _quotesFuture;

  @override
  void initState() {
    super.initState();
    // Creamos las instancias aquí (o las obtenemos de un inyector)
    final repository = QuoteRepository();
    _quoteService = QuoteService(repository);
    // Iniciamos la carga de datos
    _loadQuotes();
  }

  void _loadQuotes() {
    setState(() {
      _quotesFuture = _quoteService.getQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Quotes'),
        backgroundColor: Colors.blue,
        actions: [
          // Botón para recargar los datos
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQuotes,
            tooltip: 'Refresh Quotes',
          ),
        ],
      ),
      body: FutureBuilder<List<Quote>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          // --- Estado de Carga ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- Estado de Error ---
          else if (snapshot.hasError) {
            print('Error en FutureBuilder: ${snapshot.error}'); // Log para depuración
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadQuotes,
                    child: const Text('Intentar de nuevo'),
                  )
                ],
              ),
            );
          }
          // --- Estado con Datos ---
          else if (snapshot.hasData) {
            final quotes = snapshot.data!;
            if (quotes.isEmpty) {
              return const Center(child: Text('No hay cotizaciones disponibles.'));
            }

            // --- Lista de Quotes ---
            return ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                final color = quote.changePercentage >= 0 ? Colors.green : Colors.red;
                final icon = quote.changePercentage >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

                return ListTile(
                  leading: Icon(icon, color: color),
                  title: Text(quote.companyName),
                  subtitle: Text(
                    'Actualizado: ${quote.lastUpdated.hour}:${quote.lastUpdated.minute.toString().padLeft(2, '0')}', // Formato simple
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${quote.stockPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${quote.changePercentage.toStringAsFixed(2)}%',
                        style: TextStyle(color: color),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // --- Estado por defecto (no debería ocurrir con FutureBuilder bien usado) ---
          else {
            return const Center(child: Text('Iniciando...'));
          }
        },
      ),
    );
  }
}
