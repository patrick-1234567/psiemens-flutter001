import 'package:psiemens/data/quote_repository.dart';
import 'package:psiemens/domain/quote.dart';

class QuoteService {
  final QuoteRepository _repository;

  // Constructor that takes a QuoteRepository instance (Dependency Injection)
  QuoteService(this._repository);

  /// Fetches the list of quotes from the repository.
  Future<List<Quote>> getQuotes() async {
    try {
      // Call the repository method to get the data
      final quotes = await _repository.fetchQuotes();
      // Here you could add additional business logic if needed,
      // like filtering, sorting, or transforming the data.
      return quotes;
    } catch (e) {
      // Handle potential errors (e.g., logging, returning a default value, rethrowing)
      print('Error fetching quotes in QuoteService: $e');
      // Depending on your error handling strategy, you might rethrow,
      // return an empty list, or a custom error object.
      rethrow; // Rethrowing the error for the caller to handle
    }
  }

  // You could add more methods here for other quote-related operations
  // like fetching a single quote by ID, updating a quote, etc.
}