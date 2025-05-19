import 'package:flutter/material.dart';
import 'package:psiemens/api/service/quote_service.dart';
import 'package:psiemens/data/quote_repository.dart';
import 'package:psiemens/domain/quote.dart';
// Asegúrate de que este import es necesario aquí, si no, puedes quitarlo.
// import 'package:psiemens/constants.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  // --- State Variables ---
  final List<Quote> _quotes = [];
  int _currentPageForRandom = 1;
  bool _isLoading = false;
  bool _hasMoreQuotes = true;
  String? _error;
  bool _initialLoadComplete = false;

  final QuoteService _quoteService = QuoteService(quoteRepository: QuoteRepository());
  final ScrollController _scrollController = ScrollController();

  // --- Constantes de UI ---
  final double spacingHeight = 10.0; // Variable para el espaciado

  @override
  void initState() {
    super.initState();
    _loadQuotes(isInitialLoad: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_initialLoadComplete &&
        !_isLoading &&
        _hasMoreQuotes &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9) {
      _loadQuotes();
    }
  }

  Future<void> _loadQuotes({bool isInitialLoad = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Quote> newQuotes;
      if (isInitialLoad) {
        debugPrint("Fetching initial fixed quotes...");
        newQuotes = await _quoteService.getAllQuotes();
        debugPrint("Sorting initial quotes by price...");
        newQuotes = _quoteService.sortQuotesByPriceDescending(newQuotes);
        setState(() {
           _initialLoadComplete = true;
        });
         debugPrint("Initial fixed quotes fetched and sorted: ${newQuotes.length}");
      } else {
         debugPrint("Fetching random quotes page: $_currentPageForRandom");
        newQuotes = await _quoteService.getPaginatedQuotes(
          pageNumber: _currentPageForRandom,
        );
         debugPrint("Random quotes fetched: ${newQuotes.length}");
         _currentPageForRandom++;
      }

      setState(() {
        _isLoading = false;
        _quotes.addAll(newQuotes);
      });
    } catch (e) {
      debugPrint("Error during quote fetch: $e");
      setState(() {
        _isLoading = false;
        _error = "Failed to load quotes: ${e.toString()}";
      });
      debugPrint("Error loading quotes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- Cambio de color de fondo ---
      backgroundColor: Colors.grey[200],
      // --- Fin cambio de color ---
      appBar: AppBar(
        title: const Text('Stock Quotes'),
        backgroundColor: Colors.blue,
        // Puedes ajustar el color del AppBar si lo deseas para que combine
        // backgroundColor: Colors.blueGrey, // Ejemplo
      ),
      body: _buildQuoteList(),
    );
  }

  Widget _buildQuoteList() {
    // --- Manejo de Errores y Carga Inicial (sin cambios) ---
    if (_error != null && _quotes.isEmpty) {
      return const Center( /* ... */ );
    }
    if (_isLoading && _quotes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_isLoading && _error == null && _quotes.isEmpty && _initialLoadComplete) {
       return const Center(child: Text('No initial quotes found.'));
    }
    // --- Fin Manejo Errores y Carga ---

    return ListView.builder(
      controller: _scrollController,
      // Ajusta el padding si es necesario con el nuevo fondo
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      itemCount: _quotes.length + (_isLoading && _initialLoadComplete ? 1 : 0),
      itemBuilder: (context, index) {
        // Muestra el indicador de carga al final si corresponde
        if (index == _quotes.length) {
          return (_isLoading && _initialLoadComplete)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacingHeight + 6.0), // Ajusta padding del indicador
                    child: const CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink();
        }

        // --- Construcción de la Card y SizedBox ---
        final quote = _quotes[index];
        final Color changeColor = quote.changePercentage >= 0 ? Colors.green : Colors.red;
        final String formattedPrice = '\$${quote.stockPrice.toStringAsFixed(2)}';
        final String formattedPercentage = '${quote.changePercentage.toStringAsFixed(1)}%';
        final dateTime = quote.lastUpdated.toLocal();
        final String formattedDate =
            '${dateTime.day.toString().padLeft(2, '0')}/'
            '${dateTime.month.toString().padLeft(2, '0')}/'
            '${dateTime.year} '
            '${dateTime.hour.toString().padLeft(2, '0')}:'
            '${dateTime.minute.toString().padLeft(2, '0')}';

        // Envuelve la Card en una Column para añadir el SizedBox debajo
        return Column(
          children: [
            Card(
              elevation: 3,
              // Quita el margen vertical de la Card si el SizedBox maneja el espacio
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.companyName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formattedPrice, style: const TextStyle(fontSize: 16)),
                        Text(
                          formattedPercentage,
                          style: TextStyle(fontSize: 16, color: changeColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Updated: $formattedDate',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]), // Ligeramente más oscuro para contraste
                    ),
                  ],
                ),
              ),
            ),
            // --- Añade el SizedBox debajo de la Card ---
            SizedBox(height: spacingHeight),
            // --- Fin del SizedBox ---
          ],
        );
        // --- Fin de la construcción ---
      },
    );
  }
}
