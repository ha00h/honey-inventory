import 'package:flutter/material.dart';

import '../../../domain/entities/cycle_interval.dart';
import '../../../domain/entities/inventory_models.dart';

class PurchaseCycleEditor extends StatefulWidget {
  const PurchaseCycleEditor({
    required this.productId,
    required this.cycle,
    required this.onSave,
    super.key,
  });

  final String productId;
  final PurchaseCycle? cycle;
  final Future<void> Function({
    required int intervalDays,
    required bool isEnabled,
    required DateTime lastPurchaseDate,
  })
  onSave;

  @override
  State<PurchaseCycleEditor> createState() => _PurchaseCycleEditorState();
}

class _PurchaseCycleEditorState extends State<PurchaseCycleEditor> {
  late final TextEditingController _intervalController;
  late CycleIntervalUnit _unit;
  late bool _enabled;
  late DateTime _lastPurchaseDate;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final cycle = widget.cycle;
    if (cycle != null && cycle.intervalDays > 0) {
      final parsed = daysToInterval(cycle.intervalDays);
      _intervalController = TextEditingController(text: '${parsed.value}');
      _unit = parsed.unit;
      _enabled = cycle.isEnabled;
      _lastPurchaseDate = cycle.lastPurchaseDate ?? DateTime.now();
    } else {
      _intervalController = TextEditingController(text: '14');
      _unit = CycleIntervalUnit.day;
      _enabled = true;
      _lastPurchaseDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = int.tryParse(_intervalController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('주기는 1 이상의 숫자여야 해요.')));
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onSave(
        intervalDays: intervalToDays(value: value, unit: _unit),
        isEnabled: _enabled,
        lastPurchaseDate: _lastPurchaseDate,
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('알림 받기'),
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _intervalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '구매 주기',
                  hintText: '14',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<CycleIntervalUnit>(
                initialValue: _unit,
                decoration: const InputDecoration(labelText: '단위'),
                items: CycleIntervalUnit.values
                    .map(
                      (unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _unit = value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('마지막 구매일'),
          subtitle: Text(_dateText(_lastPurchaseDate)),
          trailing: const Icon(Icons.calendar_today_rounded),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _lastPurchaseDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 1)),
            );
            if (picked != null) {
              setState(() => _lastPurchaseDate = picked);
            }
          },
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? '저장 중...' : '주기 저장'),
        ),
      ],
    );
  }

  String _dateText(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
