import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_complete_result.dart';
import '../../domain/entities/inventory_models.dart';
import '../../domain/entities/receipt_models.dart';
import '../../domain/services/hive_economy.dart';
import '../../domain/services/inventory_services.dart';
import '../hive/hive_capacity_dialog.dart';
import '../shared/providers/inventory_providers.dart';
import '../shared/widgets/brand_art.dart';
import '../shared/widgets/cycle_suggestion_dialog.dart';
import '../shared/widgets/max_stock_suggestion_dialog.dart';
import 'widgets/add_cart_item_dialog.dart';
import 'widgets/bulk_complete_dialog.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _adding = false;
  bool _buildingHive = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buildHive(List<CartItem> items) async {
    if (items.isEmpty || _buildingHive) {
      return;
    }

    final storeName = await showBulkCompleteStoreDialog(
      context: context,
      itemCount: items.length,
    );
    if (!mounted || storeName == null) {
      return;
    }

    setState(() => _buildingHive = true);
    try {
      final results = await ref
          .read(inventoryActionsProvider)
          .buildHiveFromCart(
            items: items,
            storeName: storeName.isEmpty ? null : storeName,
          );
      if (!mounted) {
        return;
      }
      await _handleCompleteResults(results);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('벌집에 넣었어요.')));
      }
    } on HiveCapacityException {
      if (mounted) {
        await showHiveCapacityDialog(context);
      }
    } finally {
      if (mounted) {
        setState(() => _buildingHive = false);
      }
    }
  }

  Future<void> _handleCompleteResults(List<CartCompleteResult> results) async {
    final maxSuggestions = <MaxStockSuggestion>[];
    final cycleSuggestions = <PurchaseCycleSuggestion>[];
    final seenMax = <String>{};
    final seenCycle = <String>{};

    for (final result in results) {
      final max = result.maxStockSuggestion;
      if (max != null && seenMax.add(max.productId)) {
        maxSuggestions.add(max);
      }
      final cycle = result.cycleSuggestion;
      if (cycle != null && seenCycle.add(cycle.productId)) {
        cycleSuggestions.add(cycle);
      }
    }

    final actions = ref.read(inventoryActionsProvider);
    for (final suggestion in maxSuggestions) {
      if (!mounted) {
        return;
      }
      final accepted = await showMaxStockSuggestionDialog(
        context: context,
        suggestion: suggestion,
      );
      if (accepted == true) {
        await actions.updateProductMaxStock(
          productId: suggestion.productId,
          maxStock: suggestion.suggestedMaxStock,
        );
      }
    }

    if (!mounted || cycleSuggestions.isEmpty) {
      return;
    }

    await showPurchaseCycleSuggestionsDialog(
      context: context,
      ref: ref,
      suggestions: cycleSuggestions,
    );
  }

  Future<void> _confirmRemoveFromHive({
    required CartItem item,
    required String productName,
    required bool inHive,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(inHive ? '벌집에서 빼겠습니까?' : '이 물품을 지울까요?'),
        content: Text(
          inHive
              ? '$productName을(를) 벌집에서 제거할까요?\n장바구니에서도 빠지고, 이력은 유지됩니다.'
              : '$productName은(는) 아직 벌집에 없어요.\n장바구니에서만 지워집니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(inHive ? '빼기' : '지우기'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    final actions = ref.read(inventoryActionsProvider);
    if (inHive && item.productId != null) {
      await actions.deleteProduct(item.productId!);
    } else {
      await actions.removeCartItem(item.id);
    }
  }

  Future<void> _openAddDialog() async {
    final name = await showAddCartItemDialog(context: context);
    if (name == null || !mounted) {
      return;
    }
    await _addNameToCart(name);
  }

  @override
  Widget build(BuildContext context) {
    final groupedCartValue = ref.watch(groupedCartProvider);
    final productsValue = ref.watch(productsProvider);
    final products = productsValue.maybeWhen(
      data: (items) => items,
      orElse: () => const <Product>[],
    );
    final productMap = {for (final product in products) product.id: product};
    final productNames = {
      for (final product in products) product.id: product.name,
    };
    final allItems = groupedCartValue.maybeWhen(
      data: (groups) => groups.expand((group) => group.items).toList(),
      orElse: () => const <CartItem>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
        actions: [
          IconButton(
            onPressed: _adding ? null : _openAddDialog,
            icon: const Icon(Icons.add_rounded),
            tooltip: '물품 추가',
          ),
        ],
      ),
      body: groupedCartValue.when(
        data: (groups) {
          final cartProductIds = groups
              .expand((group) => group.items)
              .map((item) => item.productId)
              .whereType<String>()
              .toSet();
          final addableProducts = findProductsToAddToCart(
            query: _searchQuery,
            products: products,
            cartProductIds: cartProductIds,
          );
          final filteredGroups = filterCartGroupsByQuery(
            groups: groups,
            productNameById: productNames,
            query: _searchQuery,
          );

          if (groups.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSearchField(),
                ..._buildQuickAddArea(
                  products: products,
                  cartProductIds: cartProductIds,
                  addableProducts: addableProducts,
                ),
                const SizedBox(height: 24),
                const Center(child: BrandImage.honeyJar(size: 112)),
                const SizedBox(height: 12),
                Text(
                  '장바구니가 비었어요',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '오른쪽 위 + 로 담거나, 이름을 적고 담아보세요.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _buildSearchField(),
              ..._buildQuickAddArea(
                products: products,
                cartProductIds: cartProductIds,
                addableProducts: addableProducts,
              ),
              const SizedBox(height: 16),
              if (_searchQuery.trim().isNotEmpty && filteredGroups.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '장바구니에 있는 물품이 없어요.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              else ...[
                Text(
                  '오늘 사야 할 물품',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                for (final group in filteredGroups) ...[
                  _StoreHeader(
                    storeName: group.storeName,
                    count: group.items.length,
                  ),
                  const SizedBox(height: 8),
                  ...group.items.map((item) {
                    final product = item.productId == null
                        ? null
                        : productMap[item.productId];
                    final productName = item.label(product?.name);
                    final inHive = product != null;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Semantics(
                        label: inHive
                            ? '$productName, 벌집에서 빼기'
                            : '$productName, 장바구니에서 지우기',
                        child: _CartItemCard(
                          item: item,
                          productName: productName,
                          unit: product?.unit ?? '개',
                          inHive: inHive,
                          onDecrease: () => ref
                              .read(inventoryActionsProvider)
                              .updateCartQuantity(
                                cartItemId: item.id,
                                quantity: item.quantity - 1,
                              ),
                          onIncrease: () => ref
                              .read(inventoryActionsProvider)
                              .updateCartQuantity(
                                cartItemId: item.id,
                                quantity: item.quantity + 1,
                              ),
                          onRemove: () => _confirmRemoveFromHive(
                            item: item,
                            productName: productName,
                            inHive: inHive,
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text('장바구니를 불러오지 못했어요: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: allItems.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: FilledButton(
                  onPressed: _buildingHive ? null : () => _buildHive(allItems),
                  child: Text(_buildingHive ? '넣는 중' : '벌집 만들기'),
                ),
              ),
            ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _quickAddFromQuery(),
            decoration: InputDecoration(
              hintText: '이름만 적고 담기',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _searchController.clear,
                      icon: const Icon(Icons.close_rounded),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              filled: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: _searchQuery.trim().isEmpty || _adding
                ? null
                : _quickAddFromQuery,
            child: Text(_adding ? '담는 중' : '담기'),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildQuickAddArea({
    required List<Product> products,
    required Set<String> cartProductIds,
    required List<Product> addableProducts,
  }) {
    final query = _searchQuery.trim();
    if (query.isEmpty) {
      return const [];
    }

    final exact = findExactProductByName(query: query, products: products);
    final alreadyInCart = exact != null && cartProductIds.contains(exact.id);
    final canCreate = shouldCreateProductFromCartQuery(
      query: query,
      products: products,
    );

    return [
      const SizedBox(height: 12),
      if (alreadyInCart)
        Card(
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline_rounded),
            title: Text('"$query"은(는) 이미 장바구니에 있어요'),
            subtitle: const Text('수량은 아래 목록에서 바꿀 수 있어요.'),
          ),
        ),
      if (canCreate)
        Card(
          child: ListTile(
            leading: const BrandImage.honeyJar(size: 32),
            title: Text('"$query" 새로 담기'),
            subtitle: const Text('벌집 만들 때 칸이 있으면 칸에 넣어요.'),
            trailing: FilledButton(
              onPressed: _adding ? null : _quickAddFromQuery,
              child: const Text('담기'),
            ),
          ),
        ),
      if (addableProducts.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text('검색 결과', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ..._buildAddableProducts(addableProducts),
      ],
    ];
  }

  Future<void> _quickAddFromQuery() async {
    await _addNameToCart(_searchQuery.trim(), clearSearch: true);
  }

  Future<void> _addNameToCart(String name, {bool clearSearch = false}) async {
    if (name.isEmpty || _adding) {
      return;
    }

    setState(() => _adding = true);
    try {
      await ref.read(inventoryActionsProvider).addNamedItemToCart(name);
      if (!mounted) {
        return;
      }
      if (clearSearch) {
        _searchController.clear();
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('"$name"을(를) 장바구니에 담았어요.')));
    } finally {
      if (mounted) {
        setState(() => _adding = false);
      }
    }
  }

  List<Widget> _buildAddableProducts(List<Product> addableProducts) {
    return addableProducts.map((product) {
      return Card(
        child: ListTile(
          leading: const BrandImage.honeyJar(size: 32),
          title: Text(product.name),
          subtitle: Text('현재 ${product.currentStock} ${product.unit}'),
          trailing: FilledButton.tonal(
            onPressed: () => _addProductToCart(product),
            child: const Text('담기'),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _addProductToCart(Product product) async {
    await ref.read(inventoryActionsProvider).addToCart(productId: product.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name}을(를) 장바구니에 담았어요.')));
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.storeName, required this.count});

  final String storeName;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storefront_outlined, size: 16),
              const SizedBox(width: 6),
              Text('$storeName ($count)'),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.productName,
    required this.unit,
    required this.inHive,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  final CartItem item;
  final String productName;
  final String unit;
  final bool inHive;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const BrandImage.honeyJar(size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productName),
                      Text(
                        inHive ? '벌집에 있는 물품' : '새 칸이 필요해요',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  tooltip: inHive ? '벌집에서 빼기' : '장바구니에서 지우기',
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(onPressed: onDecrease, child: const Text('-')),
                const SizedBox(width: 8),
                Text('${item.quantity.toStringAsFixed(0)} $unit'),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: onIncrease, child: const Text('+')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
