import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';

import 'package:honey_inventory/app.dart';

Future<void> _pumpFrames(WidgetTester tester, {int times = 20}) async {
  for (var i = 0; i < times; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('온보딩, 물품 등록, 알림, 백업 스모크', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HoneyInventoryApp()));
    await _pumpFrames(tester, times: 40);

    final skip = find.text('건너뛰기');
    if (skip.evaluate().isNotEmpty) {
      await tester.tap(skip);
      await _pumpFrames(tester);
    }

    expect(find.text('허니 인벤토리'), findsWidgets);
    expect(find.text('재고'), findsOneWidget);

    final addIcon = find.byIcon(Icons.add_rounded);
    for (var i = 0; i < 50 && addIcon.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(addIcon, findsWidgets);

    await tester.tap(addIcon.first);
    await _pumpFrames(tester);
    expect(find.text('저장'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'SmokeMilk');
    await tester.pump();
    await tester.ensureVisible(find.text('저장'));
    await tester.tap(find.text('저장'));
    await _pumpFrames(tester, times: 30);

    expect(find.textContaining('SmokeMilk'), findsWidgets);

    final closeBee = find.text('닫기');
    if (closeBee.evaluate().isNotEmpty) {
      await tester.tap(closeBee);
      await _pumpFrames(tester);
    }

    await tester.tap(find.byTooltip('알림'));
    await _pumpFrames(tester);
    expect(find.text('알림'), findsWidgets);

    await tester.pageBack();
    await _pumpFrames(tester);

    await tester.tap(find.text('설정'));
    await _pumpFrames(tester);
    expect(find.text('데이터 백업'), findsOneWidget);

    await tester.tap(find.text('데이터 백업'));
    await tester.pump(const Duration(seconds: 2));
  });
}
