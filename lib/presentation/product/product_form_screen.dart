import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/inventory_models.dart';
import '../../domain/services/hive_economy.dart';
import '../hive/hive_capacity_dialog.dart';
import '../shared/icon_catalog.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/providers/repository_providers.dart';
import '../shared/widgets/cycle_suggestion_dialog.dart';
import 'widgets/icon_picker_sheet.dart';
import 'widgets/stock_history_ledger.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({this.productId, super.key});

  final String? productId;

  bool get isEditing => productId != null;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController(text: '개');
  final _stockController = TextEditingController(text: '1');
  final _maxStockController = TextEditingController(text: '3');
  final _minStockController = TextEditingController(text: '1');
  final _intervalController = TextEditingController();

  ProductCategory? _category = ProductCategory.household;
  String _iconKey = iconOptions.first.key;
  String _iconColor = defaultIconColorHex;
  HistoryLedgerFilter _historyFilter = HistoryLedgerFilter.all;
  bool _saving = false;
  bool _loaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _stockController.dispose();
    _maxStockController.dispose();
    _minStockController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isEditing) {
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      final productValue = ref.watch(productDetailProvider(widget.productId!));
      final cycleValue = ref.watch(productCycleProvider(widget.productId!));

      ref.listen(productDetailProvider(widget.productId!), (previous, next) {
        final product = next.value;
        if (product != null && !_loaded) {
          final cycle = cycleValue.maybeWhen(
            data: (value) => value,
            orElse: () => null,
          );
          _populateForm(product, cycle);
          setState(() => _loaded = true);
        }
      });

      if (!_loaded) {
        final product = productValue.value;
        if (product != null) {
          final cycle = cycleValue.maybeWhen(
            data: (value) => value,
            orElse: () => null,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_loaded && mounted) {
              _populateForm(product, cycle);
              setState(() => _loaded = true);
            }
          });
        }
      }

      return productValue.when(
        data: (product) {
          if (product == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('물품 수정')),
              body: const Center(child: Text('물품을 찾을 수 없어요.')),
            );
          }

          if (!_loaded) {
            return Scaffold(
              appBar: AppBar(title: const Text('물품 수정')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return _buildScaffold(title: '물품 수정');
        },
        error: (error, stackTrace) => Scaffold(
          appBar: AppBar(title: const Text('물품 수정')),
          body: Center(child: Text('불러오지 못했어요: $error')),
        ),
        loading: () => Scaffold(
          appBar: AppBar(title: const Text('물품 수정')),
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return _buildScaffold(title: '물품 등록');
  }

  Widget _buildScaffold({required String title}) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildFormFields(),
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxHeight < 120) {
                      return const SizedBox.shrink();
                    }
                    return _buildHistoryLedger();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: Material(
          elevation: 6,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check_rounded),
                label: Text(_saving ? '저장 중...' : '저장'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _populateForm(Product product, PurchaseCycle? cycle) {
    _nameController.text = product.name;
    _unitController.text = product.unit;
    _stockController.text = _formatNumber(product.currentStock);
    _maxStockController.text = _formatNumber(product.maxStock);
    _minStockController.text = _formatNumber(product.minStock);
    _category = product.category ?? ProductCategory.household;
    _iconKey = product.iconKey;
    _iconColor = product.iconColor;
    if (cycle != null && cycle.isEnabled) {
      _intervalController.text = cycle.intervalDays.toString();
    }
    _loaded = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentStock = double.parse(_stockController.text.trim());
    final maxStock = double.parse(_maxStockController.text.trim());
    final minStock = double.parse(_minStockController.text.trim());
    if (minStock > maxStock) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('최소 재고는 최대 재고보다 클 수 없어요.')));
      return;
    }

    final data = ProductFormData(
      name: _nameController.text.trim(),
      category: _category,
      unit: _unitController.text.trim(),
      currentStock: currentStock,
      maxStock: maxStock,
      minStock: minStock,
      iconKey: _iconKey,
      iconColor: _iconColor,
      purchaseIntervalDays: _intervalController.text.trim().isEmpty
          ? null
          : int.parse(_intervalController.text.trim()),
    );

    setState(() => _saving = true);
    final actions = ref.read(inventoryActionsProvider);

    try {
      if (widget.isEditing) {
      final existing = await ref
          .read(inventoryRepositoryProvider)
          .findActiveProductByNameExcluding(
            name: data.name,
            excludeProductId: widget.productId,
          );
      if (!mounted) {
        return;
      }
      if (existing != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${existing.name}"(이)라는 이름의 물품이 이미 있어요.')),
        );
        setState(() => _saving = false);
        return;
      }

      await actions.updateProduct(productId: widget.productId!, data: data);
    } else {
      final existing = await ref
          .read(inventoryRepositoryProvider)
          .findActiveProductByName(data.name);
      if (!mounted) {
        return;
      }
      if (existing != null) {
        final choice = await showDialog<_DuplicateChoice>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('이미 있는 물품이에요'),
            content: Text('"${existing.name}"이(가) 이미 있어요.\n기존 물품에 재고를 추가할까요?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(_DuplicateChoice.cancel),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(_DuplicateChoice.createNew),
                child: const Text('새로 등록'),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pop(_DuplicateChoice.merge),
                child: const Text('기존에 추가'),
              ),
            ],
          ),
        );

        if (!mounted) {
          return;
        }

        if (choice == null || choice == _DuplicateChoice.cancel) {
          setState(() => _saving = false);
          return;
        }

        if (choice == _DuplicateChoice.merge) {
          final suggestion = await actions.mergeToExistingProduct(
            productId: existing.id,
            data: data,
          );
          if (!mounted) {
            return;
          }
          if (suggestion != null) {
            await showPurchaseCycleSuggestionDialog(
              context: context,
              ref: ref,
              suggestion: suggestion,
            );
          }
        } else {
          await actions.addProduct(data);
        }
      } else {
        await actions.addProduct(data);
      }
      }
    } on HiveCapacityException {
      if (!mounted) {
        return;
      }
      setState(() => _saving = false);
      await showHiveCapacityDialog(context);
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    Navigator.of(context).pop();
  }

  List<Widget> _buildFormFields() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconLeadButton(
            iconKey: _iconKey,
            colorHex: _iconColor,
            onTap: _openIconPicker,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactField(
              label: '물품명',
              controller: _nameController,
              hintText: '예: 휴지',
              validator: _requiredText,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<ProductCategory>(
              initialValue: _category,
              isDense: true,
              isExpanded: true,
              decoration: _inputDecoration('카테고리'),
              items: categoryLabels.entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _category = value),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _CompactField(
              label: '단위',
              controller: _unitController,
              hintText: '개',
              validator: _requiredText,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _CompactField(
              label: '현재',
              controller: _stockController,
              hintText: '1',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _nonNegativeNumber,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactField(
              label: '최소',
              controller: _minStockController,
              hintText: '1',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _nonNegativeNumber,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactField(
              label: '최대',
              controller: _maxStockController,
              hintText: '3',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _positiveNumber,
              textInputAction: TextInputAction.next,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      _CompactField(
        label: '구매 주기 (일)',
        controller: _intervalController,
        hintText: '비워두면 주기 없음',
        keyboardType: TextInputType.number,
        validator: _optionalPositiveInt,
        textInputAction: TextInputAction.done,
      ),
    ];
  }

  Widget _buildHistoryLedger() {
    if (!widget.isEditing) {
      return StockHistoryLedger(
        histories: const [],
        filter: _historyFilter,
        onFilterChanged: (value) => setState(() => _historyFilter = value),
      );
    }

    final historyValue = ref.watch(stockHistoryProvider(widget.productId!));
    return historyValue.when(
      data: (histories) => StockHistoryLedger(
        histories: histories,
        filter: _historyFilter,
        onFilterChanged: (value) => setState(() => _historyFilter = value),
      ),
      error: (error, stackTrace) => Center(child: Text('이력을 불러오지 못했어요: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _openIconPicker() async {
    final result = await showIconPickerSheet(
      context: context,
      iconKey: _iconKey,
      colorHex: _iconColor,
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      _iconKey = result.iconKey;
      _iconColor = result.colorHex;
    });
  }

  String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '필수 입력 항목입니다.';
    }
    return null;
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return '0보다 큰 숫자를 입력해주세요.';
    }
    return null;
  }

  String? _nonNegativeNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null || number < 0) {
      return '0 이상 숫자를 입력해주세요.';
    }
    return null;
  }

  String? _optionalPositiveInt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final number = int.tryParse(value.trim());
    if (number == null || number <= 0) {
      return '1일 이상 입력해주세요.';
    }
    return null;
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
    );
  }
}

enum _DuplicateChoice { merge, createNew, cancel }

class _CompactField extends StatelessWidget {
  const _CompactField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      scrollPadding: const EdgeInsets.only(bottom: 120),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _IconLeadButton extends StatelessWidget {
  const _IconLeadButton({
    required this.iconKey,
    required this.colorHex,
    required this.onTap,
  });

  final String iconKey;
  final String colorHex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = parseIconColor(colorHex);
    return Semantics(
      button: true,
      label: '아이콘 선택, ${iconLabelForKey(iconKey)}',
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(
              iconForKey(iconKey),
              color: contrastOnColor(color),
            ),
          ),
        ),
      ),
    );
  }
}
