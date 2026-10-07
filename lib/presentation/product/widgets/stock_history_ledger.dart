import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/inventory_models.dart';
import '../../shared/widgets/stock_reason_selector.dart';

enum HistoryLedgerFilter { all, spend, charge }

class StockHistoryLedger extends StatelessWidget {
  const StockHistoryLedger({
    required this.histories,
    required this.filter,
    required this.onFilterChanged,
    this.showTitle = true,
    super.key,
  });

  final List<StockHistory> histories;
  final HistoryLedgerFilter filter;
  final ValueChanged<HistoryLedgerFilter> onFilterChanged;
  final bool showTitle;

  List<StockHistory> get _visible {
    return histories.where((item) {
      return switch (filter) {
        HistoryLedgerFilter.all => true,
        HistoryLedgerFilter.spend => item.delta < 0,
        HistoryLedgerFilter.charge => item.delta > 0,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTitle) ...[
          Text('변경 이력', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
        ],
        SegmentedButton<HistoryLedgerFilter>(
          showSelectedIcon: false,
          expandedInsets: EdgeInsets.zero,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: WidgetStatePropertyAll(
              Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          segments: const [
            ButtonSegment(
              value: HistoryLedgerFilter.all,
              label: Text('전체'),
            ),
            ButtonSegment(
              value: HistoryLedgerFilter.spend,
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('소비(지출)'),
              ),
            ),
            ButtonSegment(
              value: HistoryLedgerFilter.charge,
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('충전(수입)'),
              ),
            ),
          ],
          selected: {filter},
          onSelectionChanged: (value) => onFilterChanged(value.first),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      filter == HistoryLedgerFilter.all
                          ? '아직 이력이 없어요.'
                          : '해당하는 이력이 없어요.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      return _LedgerRow(item: visible[index]);
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.item});

  final StockHistory item;

  @override
  Widget build(BuildContext context) {
    final isSpend = item.delta < 0;
    final amountColor = isSpend
        ? const Color(0xFFC62828)
        : const Color(0xFF2E7D32);
    final date = DateFormat('M/d').format(item.createdAt);
    final amount = _formatDelta(item.delta);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(date, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              stockChangeReasonLabel(item.reason),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDelta(double value) {
    final abs = value.abs();
    final number = abs % 1 == 0 ? abs.toInt().toString() : abs.toStringAsFixed(1);
    if (value > 0) {
      return '+$number';
    }
    if (value < 0) {
      return '-$number';
    }
    return number;
  }
}
