import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/receipt_models.dart';
import '../../domain/services/product_matcher.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/providers/repository_providers.dart';
import 'widgets/receipt_item_edit_dialog.dart';

class ReceiptScanScreen extends ConsumerStatefulWidget {
  const ReceiptScanScreen({required this.imagePath, super.key});

  final String imagePath;

  @override
  ConsumerState<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends ConsumerState<ReceiptScanScreen> {
  ReceiptScanResult? _result;
  String? _error;
  bool _loading = true;
  bool _importing = false;
  final _storeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  void dispose() {
    _storeController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final service = ref.read(receiptOcrServiceProvider);
      final result = await service.scanImage(widget.imagePath);
      final products = await ref
          .read(inventoryRepositoryProvider)
          .watchProductsOnce();

      final matchedItems = result.items.map((item) {
        final match = matchProductByName(item.name, products);
        return ReceiptLineItem(
          name: item.name,
          quantity: item.quantity,
          price: item.price,
          selected: item.selected,
          matchedProductId: match?.product.id,
          matchedProductName: match?.product.name,
          matchScore: match?.score,
        );
      }).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _result = ReceiptScanResult(
          storeName: result.storeName,
          items: matchedItems,
        );
        _storeController.text = result.storeName ?? '';
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _importSelected() async {
    final result = _result;
    if (result == null) {
      return;
    }

    final selected = result.items.where((item) => item.selected).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('등록할 품목을 선택해주세요.')));
      return;
    }

    setState(() => _importing = true);
    final count = await ref
        .read(inventoryActionsProvider)
        .importReceiptItems(
          storeName: _storeController.text.trim().isEmpty
              ? null
              : _storeController.text.trim(),
          items: selected
              .map(
                (item) => ReceiptImportItem(
                  name: item.name,
                  quantity: item.quantity,
                  matchedProductId: item.matchedProductId,
                ),
              )
              .toList(),
        );

    if (!mounted) {
      return;
    }

    setState(() => _importing = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$count개 품목을 등록했어요.')));
    Navigator.of(context).pop();
  }

  Future<void> _editItem(ReceiptLineItem item) async {
    final edited = await showReceiptItemEditDialog(
      context: context,
      item: item,
    );
    if (!mounted || edited == null) {
      return;
    }

    final products = await ref
        .read(inventoryRepositoryProvider)
        .watchProductsOnce();
    final match = matchProductByName(edited.name, products);

    setState(() {
      item.name = edited.name;
      item.quantity = edited.quantity;
      item.matchedProductId = match?.product.id;
      item.matchedProductName = match?.product.name;
      item.matchScore = match?.score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('영수증 스캔')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('영수증을 읽지 못했어요.\n$_error', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _scan, child: const Text('다시 시도')),
                  ],
                ),
              ),
            )
          : _buildResults(),
      bottomNavigationBar: _result == null || _loading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _importing ? null : _importSelected,
                  icon: _importing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(_importing ? '등록 중...' : '선택 항목 등록'),
                ),
              ),
            ),
    );
  }

  Widget _buildResults() {
    final result = _result!;
    if (result.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🧾', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              const Text('인식된 품목이 없어요.', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _scan, child: const Text('다시 스캔')),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _storeController,
          decoration: const InputDecoration(
            labelText: '구매처',
            hintText: '예: 이마트',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Text('인식된 품목', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...result.items.map((item) {
          return Card(
            child: CheckboxListTile(
              value: item.selected,
              onChanged: (value) {
                setState(() => item.selected = value ?? false);
              },
              title: Text(item.name),
              subtitle: Text(_matchLabel(item)),
              secondary: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.price != null) Text('${item.price!.toInt()}원'),
                  IconButton(
                    onPressed: () => _editItem(item),
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: '수정',
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  String _matchLabel(ReceiptLineItem item) {
    final quantity =
        '${item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 1)}개';
    if (item.matchedProductId == null) {
      return '$quantity · 새 물품 등록';
    }

    final matchedName = item.matchedProductName;
    if (matchedName != null && matchedName != item.name) {
      return '$quantity · $matchedName 매칭';
    }
    return '$quantity · 기존 물품 매칭';
  }
}
