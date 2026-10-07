import 'receipt_models.dart';

class MaxStockSuggestion {
  const MaxStockSuggestion({
    required this.productId,
    required this.productName,
    required this.previousMaxStock,
    required this.newStock,
    required this.suggestedMaxStock,
  });

  final String productId;
  final String productName;
  final double previousMaxStock;
  final double newStock;
  final double suggestedMaxStock;
}

class CartCompleteResult {
  const CartCompleteResult({this.cycleSuggestion, this.maxStockSuggestion});

  final PurchaseCycleSuggestion? cycleSuggestion;
  final MaxStockSuggestion? maxStockSuggestion;
}
