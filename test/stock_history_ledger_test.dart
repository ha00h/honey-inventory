import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/domain/entities/inventory_models.dart';
import 'package:honey_inventory/presentation/product/widgets/stock_history_ledger.dart';

void main() {
  testWidgets('ledger shows date and signed quantity', (tester) async {
    var filter = HistoryLedgerFilter.all;
    final histories = [
      StockHistory(
        id: '1',
        productId: 'p',
        delta: -1,
        stockAfter: 2,
        reason: StockChangeReason.usage,
        createdAt: DateTime(2026, 9, 8),
      ),
      StockHistory(
        id: '2',
        productId: 'p',
        delta: 10,
        stockAfter: 12,
        reason: StockChangeReason.purchase,
        createdAt: DateTime(2026, 9, 7),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 400,
            child: StatefulBuilder(
              builder: (context, setState) {
                return StockHistoryLedger(
                  histories: histories,
                  filter: filter,
                  onFilterChanged: (value) => setState(() => filter = value),
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('전체'), findsOneWidget);
    expect(find.text('소비(지출)'), findsOneWidget);
    expect(find.text('충전(수입)'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);
    expect(find.text('+10'), findsOneWidget);

    await tester.tap(find.text('소비(지출)'));
    await tester.pumpAndSettle();
    expect(find.text('-1'), findsOneWidget);
    expect(find.text('+10'), findsNothing);
  });
}
