import 'package:flutter/material.dart';

import '../../../domain/entities/inventory_models.dart';

String stockChangeReasonLabel(StockChangeReason reason) {
  return switch (reason) {
    StockChangeReason.usage => '사용',
    StockChangeReason.discard => '폐기',
    StockChangeReason.adjust => '조정',
    StockChangeReason.purchase => '구매',
    StockChangeReason.initial => '초기',
  };
}

class StockReasonSelector extends StatelessWidget {
  const StockReasonSelector({
    required this.selected,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final StockChangeReason selected;
  final List<StockChangeReason> options;
  final ValueChanged<StockChangeReason> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options.map((reason) {
        return ChoiceChip(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(stockChangeReasonLabel(reason)),
          selected: selected == reason,
          onSelected: (_) => onChanged(reason),
        );
      }).toList(),
    );
  }
}
