import 'dart:async';
import 'package:flutter/material.dart';
import 'package:psiemens/constants.dart';
import 'package:psiemens/data/quote_repository.dart'; // Import the repository
import 'package:psiemens/domain/quote.dart';

class QuoteService {
  final QuoteRepository _quoteRepository;

  // Inject the repository via the constructor
  QuoteService({required QuoteRepository quoteRepository})
      : _quoteRepository = quoteRepository;

  /// Helper method to validate a list of quotes.
  /// Prints warnings for invalid data found.
  void _validateQuoteList(List<Quote> quotes) {
    for (final quote in quotes) {
      // Ensure changePercentage is within the valid range (-100 to 100)
      if (quote.changePercentage > 100 || quote.changePercentage < -100) {
        debugPrint(
          'Warning: Invalid changePercentage found for ${quote.companyName}: ${quote.changePercentage}. Expected between -100 and 100.',
        );
      }
      // Ensure stock price is positive
      if (quote.stockPrice <= 0) {
         debugPrint(
          'Warning: Non-positive stockPrice found for ${quote.companyName}: ${quote.stockPrice}. Expected > 0.',
        );
      }
    }
  }

  /// Fetches a specific number of *random* quotes using the repository,
  /// ensuring valid input parameters and validating the generated quotes.
  ///
  /// [pageNumber] The page number requested (used primarily by the UI, less relevant here).
  /// [pageSize] The number of random quotes to generate (must be > 0, defaults to FinanceConstants.pageSize).
  ///
  /// Throws [ArgumentError] if [pageSize] is invalid.
  /// May print warnings based on validation results.
  Future<List<Quote>> getPaginatedQuotes({
    required int pageNumber, // Kept for compatibility with QuoteScreen's logic
    int pageSize = FinanceConstants.pageSize,
  }) async {
    // --- Input Validation ---
    if (pageNumber < 1) {
      throw ArgumentError.value(
          pageNumber, 'pageNumber', 'must be greater than or equal to 1');
    }
    if (pageSize <= 0) {
      throw ArgumentError.value(
          pageSize, 'pageSize', 'must be greater than 0');
    }
    // --- End Input Validation ---

    // 1. Generate 'pageSize' number of random quotes from the repository
    final List<Quote> randomQuotes = await _quoteRepository.generateRandomQuotes(pageSize);

    // 2. Validate the generated quotes (price and percentage)
    _validateQuoteList(randomQuotes);

    // 3. Filter quotes to include only those meeting criteria (e.g., positive price)
    final List<Quote> validQuotes = randomQuotes
        .where((quote) =>
            quote.stockPrice > 0 &&
            quote.changePercentage >= -100 &&
            quote.changePercentage <= 100)
        .toList();

    // 4. Return the validated and filtered list of random quotes.
    return validQuotes;
  }

  /// Gets the total count of quotes. (Meaning might be limited with random generation)
  Future<int> getTotalQuoteCount() async {
    debugPrint("Warning: getTotalQuoteCount may not be meaningful with random generation.");
    return 0; // Returning 0 as total count is not well-defined here
  }

  /// Fetches the predefined list of quotes from the repository.
  Future<List<Quote>> getAllQuotes() async {
    // 1. Fetch the predefined list
    final allQuotes = await _quoteRepository.fetchQuotes();

    // 2. Validate fetched quotes
    _validateQuoteList(allQuotes);

    // 3. Filter quotes
    final validQuotes = allQuotes
        .where((quote) =>
            quote.stockPrice > 0 &&
            quote.changePercentage >= -100 &&
            quote.changePercentage <= 100)
        .toList();
    return validQuotes;
  }

  /// Sorts a given list of quotes by stock price in descending order.
  ///
  /// [quotes] The list of quotes to sort.
  /// Returns a new list containing the sorted quotes.
  List<Quote> sortQuotesByPriceDescending(List<Quote> quotes) {
    // Create a mutable copy to avoid modifying the original list passed in.
    final List<Quote> sortedList = List.from(quotes);

    // Sort the list using the compareTo method on stockPrice.
    // b.compareTo(a) ensures descending order (highest price first).
    sortedList.sort((a, b) => b.stockPrice.compareTo(a.stockPrice));

    return sortedList;
  }
}
