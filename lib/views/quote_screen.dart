import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psiemens/api/service/quote_service.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/data/quote_repository.dart';
import 'package:psiemens/domain/quote.dart';
import 'package:psiemens/theme/theme.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final List<Quote> _quotes = [];
  int _currentPageForRandom = 1;
  bool _isLoading = false;
  bool _hasMoreQuotes = true;
  String? _error;
  bool _initialLoadComplete = false;

  final QuoteService _quoteService = QuoteService(quoteRepository: QuoteRepository());
  final ScrollController _scrollController = ScrollController();
  final double spacingHeight = 10.0;

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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(FinanceConstants.titleApp),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildQuoteList(),
    );
  }

  Widget _buildQuoteList() {
    if (_error != null && _quotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.gray07),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadQuotes(isInitialLoad: true),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_isLoading && _quotes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              FinanceConstants.loadingMessage,
              style: const TextStyle(
                color: AppColors.gray07,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (!_isLoading && _error == null && _quotes.isEmpty && _initialLoadComplete) {
      return const Center(
        child: Text(
          FinanceConstants.emptyList,
          style: TextStyle(color: AppColors.gray07),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: _quotes.length + (_isLoading && _initialLoadComplete ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _quotes.length) {
          return _isLoading && _initialLoadComplete
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacingHeight),
                    child: const CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink();
        }
        final quote = _quotes[index];
        final Color changeColor = quote.changePercentage >= 0 ? AppColors.secondary : Colors.red;
        final String formattedPrice = '\$${quote.stockPrice.toStringAsFixed(2)}';
        final String formattedPercentage = '${quote.changePercentage.toStringAsFixed(1)}%';
        
        // Corregir el formato de fecha usando DateFormat de intl
        final dateTime = quote.lastUpdated.toLocal();
        final String formattedDate = DateFormat(AppConstants.formatoFecha).format(dateTime);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColors.gray04.withOpacity(0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.companyName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.gray07,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formattedPercentage,
                        style: TextStyle(
                          fontSize: 16,
                          color: changeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Actualizado: $formattedDate',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray07,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ... resto del código existente (métodos _onScroll, _loadQuotes, etc.)
}