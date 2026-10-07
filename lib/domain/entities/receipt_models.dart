class ReceiptLineItem {
  ReceiptLineItem({
    required this.name,
    this.quantity = 1,
    this.price,
    this.selected = true,
    this.matchedProductId,
    this.matchedProductName,
    this.matchScore,
  });

  String name;
  double quantity;
  final double? price;
  bool selected;
  String? matchedProductId;
  String? matchedProductName;
  double? matchScore;
}

class ReceiptScanResult {
  const ReceiptScanResult({this.storeName, required this.items});

  final String? storeName;
  final List<ReceiptLineItem> items;
}

class ReceiptImportItem {
  const ReceiptImportItem({
    required this.name,
    required this.quantity,
    this.matchedProductId,
  });

  final String name;
  final double quantity;
  final String? matchedProductId;
}

class PurchaseCycleSuggestion {
  const PurchaseCycleSuggestion({
    required this.productId,
    required this.productName,
    required this.intervalDays,
  });

  final String productId;
  final String productName;
  final int intervalDays;
}
