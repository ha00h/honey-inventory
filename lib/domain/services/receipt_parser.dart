import '../entities/receipt_models.dart';

final _pricePattern = RegExp(r'([\d,]+)\s*원?$');
final _qtyPattern = RegExp(r'^(\d+(?:\.\d+)?)\s*[xX×]\s*(.+)$');
final _qtySuffixPattern = RegExp(
  r'^(.+?)\s+(\d+(?:\.\d+)?)\s*(?:개|EA|ea|병|봉|팩|박스|통|롤)?$',
);
final _skipLinePattern = RegExp(
  r'합계|총액|부가세|카드|현금|승인|사업자|전화|주소|영수증|거래|일시|포인트|할인|면세|과세|상품명|품명|수량|단가|금액|매출|고객|카운터',
);
final _storeHintPattern = RegExp(r'마트|슈퍼|코스트코|이마트|홈플|롯데|세븐|GS|다이소|편의점|점$');

ReceiptScanResult parseReceiptText(String text) {
  final lines = text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  String? storeName;
  final items = <ReceiptLineItem>[];

  for (final line in lines) {
    if (_skipLinePattern.hasMatch(line)) {
      continue;
    }

    final qtyMatch = _qtyPattern.firstMatch(line);
    if (qtyMatch != null) {
      final name = _cleanItemName(qtyMatch.group(2)!);
      if (name.isNotEmpty) {
        items.add(
          ReceiptLineItem(
            name: name,
            quantity: double.tryParse(qtyMatch.group(1)!) ?? 1,
          ),
        );
      }
      continue;
    }

    final suffixMatch = _qtySuffixPattern.firstMatch(line);
    if (suffixMatch != null) {
      final name = _cleanItemName(suffixMatch.group(1)!);
      final qty = double.tryParse(suffixMatch.group(2)!) ?? 1;
      if (name.length >= 2) {
        items.add(ReceiptLineItem(name: name, quantity: qty));
      }
      continue;
    }

    final priceMatch = _pricePattern.firstMatch(line);
    if (priceMatch != null) {
      final namePart = line.substring(0, priceMatch.start).trim();
      final name = _cleanItemName(namePart);
      final price = _parsePrice(priceMatch.group(1)!);
      if (name.length >= 2 && !_looksLikeStoreOnly(name)) {
        items.add(ReceiptLineItem(name: name, price: price));
      }
      continue;
    }

    if (storeName == null &&
        line.length >= 2 &&
        line.length <= 30 &&
        (_storeHintPattern.hasMatch(line) || lines.indexOf(line) < 5)) {
      storeName = line;
    }
  }

  final deduped = <String, ReceiptLineItem>{};
  for (final item in items) {
    final key = item.name.toLowerCase();
    final existing = deduped[key];
    if (existing == null) {
      deduped[key] = item;
    } else {
      deduped[key] = ReceiptLineItem(
        name: existing.name,
        quantity: existing.quantity + item.quantity,
        price: item.price ?? existing.price,
        selected: existing.selected,
      );
    }
  }

  return ReceiptScanResult(
    storeName: storeName,
    items: deduped.values.toList(),
  );
}

String _cleanItemName(String value) {
  return value
      .replaceAll(RegExp(r'[^\w가-힣\s.%\-+]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

double? _parsePrice(String value) {
  final normalized = value.replaceAll(',', '');
  return double.tryParse(normalized);
}

bool _looksLikeStoreOnly(String value) {
  return RegExp(r'^\d+$').hasMatch(value);
}
