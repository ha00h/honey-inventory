import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/cycle_interval.dart';
import '../../../domain/entities/receipt_models.dart';
import '../providers/inventory_providers.dart';

Future<void> showPurchaseCycleSuggestionDialog({
  required BuildContext context,
  required WidgetRef ref,
  required PurchaseCycleSuggestion suggestion,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('구매 패턴을 발견했어요'),
      content: Text(
        '${suggestion.productName}은(는) 약 ${suggestion.intervalDays}일마다\n구매하시는 것 같아요.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('나중에'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await showManualCycleInputDialog(
              context: context,
              ref: ref,
              suggestion: suggestion,
            );
          },
          child: const Text('직접 입력'),
        ),
        FilledButton(
          onPressed: () async {
            await ref
                .read(inventoryActionsProvider)
                .applyEstimatedCycle(
                  productId: suggestion.productId,
                  intervalDays: suggestion.intervalDays,
                );
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${suggestion.intervalDays}일 주기를 적용했어요.'),
                ),
              );
            }
          },
          child: const Text('이 주기 적용'),
        ),
      ],
    ),
  );
}

Future<void> showManualCycleInputDialog({
  required BuildContext context,
  required WidgetRef ref,
  required PurchaseCycleSuggestion suggestion,
}) {
  final controller = TextEditingController(
    text: suggestion.intervalDays.toString(),
  );
  var unit = CycleIntervalUnit.day;

  return showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('구매 주기 직접 입력'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '주기'),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<CycleIntervalUnit>(
                  value: unit,
                  items: CycleIntervalUnit.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => unit = value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              final value = int.tryParse(controller.text.trim());
              if (value == null || value <= 0) {
                return;
              }
              await ref
                  .read(inventoryActionsProvider)
                  .updatePurchaseCycle(
                    productId: suggestion.productId,
                    intervalDays: intervalToDays(value: value, unit: unit),
                  );
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('구매 주기를 저장했어요.')));
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    ),
  ).whenComplete(controller.dispose);
}

Future<void> showPurchaseCycleSuggestionsDialog({
  required BuildContext context,
  required WidgetRef ref,
  required List<PurchaseCycleSuggestion> suggestions,
}) {
  if (suggestions.length == 1) {
    return showPurchaseCycleSuggestionDialog(
      context: context,
      ref: ref,
      suggestion: suggestions.first,
    );
  }

  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('구매 패턴을 발견했어요'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: suggestions
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '• ${item.productName}: 약 ${item.intervalDays}일 주기',
                  ),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('나중에'),
        ),
        FilledButton(
          onPressed: () async {
            final actions = ref.read(inventoryActionsProvider);
            for (final suggestion in suggestions) {
              await actions.applyEstimatedCycle(
                productId: suggestion.productId,
                intervalDays: suggestion.intervalDays,
              );
            }
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${suggestions.length}개 물품에 주기를 적용했어요.'),
                ),
              );
            }
          },
          child: const Text('모두 적용'),
        ),
      ],
    ),
  );
}
