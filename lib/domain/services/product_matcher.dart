import '../entities/inventory_models.dart';

class ProductMatch {
  const ProductMatch({
    required this.product,
    required this.score,
    required this.matchType,
  });

  final Product product;
  final double score;
  final ProductMatchType matchType;
}

enum ProductMatchType { exact, normalized, contains, similar }

ProductMatch? matchProductByName(String name, List<Product> products) {
  final query = name.trim();
  if (query.isEmpty || products.isEmpty) {
    return null;
  }

  final normalizedQuery = _normalizeName(query);
  ProductMatch? best;

  for (final product in products) {
    final normalizedProduct = _normalizeName(product.name);

    if (product.name.trim() == query) {
      return ProductMatch(
        product: product,
        score: 1,
        matchType: ProductMatchType.exact,
      );
    }

    if (normalizedProduct == normalizedQuery) {
      best = _betterMatch(
        best,
        ProductMatch(
          product: product,
          score: 0.95,
          matchType: ProductMatchType.normalized,
        ),
      );
      continue;
    }

    if (normalizedProduct.contains(normalizedQuery) ||
        normalizedQuery.contains(normalizedProduct)) {
      final shorter = normalizedQuery.length < normalizedProduct.length
          ? normalizedQuery.length
          : normalizedProduct.length;
      final longer = normalizedQuery.length > normalizedProduct.length
          ? normalizedQuery.length
          : normalizedProduct.length;
      final score = 0.75 + (shorter / longer) * 0.15;
      best = _betterMatch(
        best,
        ProductMatch(
          product: product,
          score: score,
          matchType: ProductMatchType.contains,
        ),
      );
      continue;
    }

    final similarity = _similarity(normalizedQuery, normalizedProduct);
    if (similarity >= 0.72) {
      best = _betterMatch(
        best,
        ProductMatch(
          product: product,
          score: similarity,
          matchType: ProductMatchType.similar,
        ),
      );
    }
  }

  return best;
}

ProductMatch? _betterMatch(ProductMatch? current, ProductMatch candidate) {
  if (current == null || candidate.score > current.score) {
    return candidate;
  }
  return current;
}

String _normalizeName(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll(RegExp(r'[^\w가-힣]'), '');
}

double _similarity(String left, String right) {
  if (left.isEmpty || right.isEmpty) {
    return 0;
  }
  if (left == right) {
    return 1;
  }

  final distance = _levenshtein(left, right);
  final maxLength = left.length > right.length ? left.length : right.length;
  return 1 - (distance / maxLength);
}

int _levenshtein(String left, String right) {
  final rows = left.length + 1;
  final cols = right.length + 1;
  final matrix = List.generate(rows, (_) => List<int>.filled(cols, 0));

  for (var i = 0; i < rows; i++) {
    matrix[i][0] = i;
  }
  for (var j = 0; j < cols; j++) {
    matrix[0][j] = j;
  }

  for (var i = 1; i < rows; i++) {
    for (var j = 1; j < cols; j++) {
      final cost = left[i - 1] == right[j - 1] ? 0 : 1;
      matrix[i][j] = [
        matrix[i - 1][j] + 1,
        matrix[i][j - 1] + 1,
        matrix[i - 1][j - 1] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }
  }

  return matrix[left.length][right.length];
}
