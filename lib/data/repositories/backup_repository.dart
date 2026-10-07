import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/services/hive_economy.dart';
import '../../domain/services/hive_slots.dart';
import '../database/app_database.dart';
import 'settings_repository.dart';

class BackupRepository {
  BackupRepository({
    required this._database,
    required this._settingsRepository,
  });

  final AppDatabase _database;
  final SettingsRepository _settingsRepository;

  static const backupVersion = 1;

  Future<String> exportToJson() async {
    final settings = await _settingsRepository.load();
    final products = await _database.select(_database.products).get();
    final cycles = await _database.select(_database.purchaseCycles).get();
    final histories = await _database.select(_database.stockHistories).get();
    final records = await _database.select(_database.purchaseRecords).get();
    final cartItems = await _database.select(_database.cartItems).get();

    final payload = {
      'version': backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': _settingsToJson(settings),
      'products': products.map(_productRowToJson).toList(),
      'purchaseCycles': cycles.map(_cycleRowToJson).toList(),
      'stockHistories': histories.map(_historyRowToJson).toList(),
      'purchaseRecords': records.map(_recordRowToJson).toList(),
      'cartItems': cartItems.map(_cartRowToJson).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> importFromJson(String json) async {
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    final version = decoded['version'] as int?;
    if (version != backupVersion) {
      throw BackupException('지원하지 않는 백업 버전이에요.');
    }

    final settings = _settingsFromJson(
      decoded['settings'] as Map<String, dynamic>,
    );
    final products = (decoded['products'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final cycles = (decoded['purchaseCycles'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final histories = (decoded['stockHistories'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final records = (decoded['purchaseRecords'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    final cartItems = (decoded['cartItems'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();

    await _database.transaction(() async {
      await _database.delete(_database.cartItems).go();
      await _database.delete(_database.purchaseRecords).go();
      await _database.delete(_database.stockHistories).go();
      await _database.delete(_database.purchaseCycles).go();
      await _database.delete(_database.products).go();

      final hiveSlots = resolveImportedHiveSlots([
        for (final row in products) row['hiveSlot'] as int?,
      ]);
      for (var i = 0; i < products.length; i++) {
        final row = Map<String, dynamic>.from(products[i]);
        row['hiveSlot'] = hiveSlots[i];
        await _database
            .into(_database.products)
            .insert(_productRowFromJson(row));
      }
      for (final row in cycles) {
        await _database
            .into(_database.purchaseCycles)
            .insert(_cycleRowFromJson(row));
      }
      for (final row in histories) {
        await _database
            .into(_database.stockHistories)
            .insert(_historyRowFromJson(row));
      }
      for (final row in records) {
        await _database
            .into(_database.purchaseRecords)
            .insert(_recordRowFromJson(row));
      }
      for (final row in cartItems) {
        await _database.into(_database.cartItems).insert(_cartRowFromJson(row));
      }
    });

    await _settingsRepository.save(settings);
  }

  Future<void> shareBackup() async {
    final json = await exportToJson();
    final directory = await getTemporaryDirectory();
    final date = DateTime.now();
    final fileName =
        'honey_inventory_backup_${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}.json';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(json);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: '허니 인벤토리 백업'),
    );
  }

  Map<String, dynamic> _settingsToJson(AppSettings settings) {
    return {
      'notificationsEnabled': settings.notificationsEnabled,
      'notificationHour': settings.notificationTime.hour,
      'notificationMinute': settings.notificationTime.minute,
      'hasSeenOnboarding': settings.hasSeenOnboarding,
      'snoozedUntilByProductId': {
        for (final entry in settings.snoozedUntilByProductId.entries)
          entry.key: entry.value.toIso8601String(),
      },
      'dismissedReminderProductIds': settings.dismissedReminderProductIds
          .toList(),
      'themeMode': settings.themeMode.name,
      'honeyPoints': settings.honeyPoints,
      'unlockedHiveCells': settings.unlockedHiveCells,
      'isPro': settings.isPro,
      'lastAttendanceDate': settings.lastAttendanceDate?.toIso8601String(),
      'lastAdWatchDate': settings.lastAdWatchDate?.toIso8601String(),
      'adsWatchedToday': settings.adsWatchedToday,
    };
  }

  AppSettings _settingsFromJson(Map<String, dynamic> json) {
    final snoozedRaw =
        json['snoozedUntilByProductId'] as Map<String, dynamic>? ?? {};
    final dismissedRaw =
        (json['dismissedReminderProductIds'] as List<dynamic>? ?? const [])
            .cast<String>();
    return AppSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      notificationTime: TimeOfDay(
        hour: json['notificationHour'] as int? ?? 9,
        minute: json['notificationMinute'] as int? ?? 0,
      ),
      hasSeenOnboarding: json['hasSeenOnboarding'] as bool? ?? true,
      snoozedUntilByProductId: {
        for (final entry in snoozedRaw.entries)
          entry.key: DateTime.parse(entry.value as String),
      },
      dismissedReminderProductIds: dismissedRaw.toSet(),
      themeMode: AppThemeMode.values.byName(
        json['themeMode'] as String? ?? AppThemeMode.light.name,
      ),
      honeyPoints: json['honeyPoints'] as int? ?? 0,
      unlockedHiveCells: json['unlockedHiveCells'] as int? ?? freeHiveCells,
      isPro: json['isPro'] as bool? ?? false,
      lastAttendanceDate: _parseOptionalDate(json['lastAttendanceDate']),
      lastAdWatchDate: _parseOptionalDate(json['lastAdWatchDate']),
      adsWatchedToday: json['adsWatchedToday'] as int? ?? 0,
    );
  }

  DateTime? _parseOptionalDate(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  Map<String, dynamic> _productRowToJson(Product row) => {
    'id': row.id,
    'name': row.name,
    'category': row.category,
    'unit': row.unit,
    'currentStock': row.currentStock,
    'maxStock': row.maxStock,
    'minStock': row.minStock,
    'iconKey': row.iconKey,
    'iconColor': row.iconColor,
    'isActive': row.isActive,
    'hiveSlot': row.hiveSlot,
    'createdAt': row.createdAt.toIso8601String(),
    'updatedAt': row.updatedAt.toIso8601String(),
  };

  ProductsCompanion _productRowFromJson(Map<String, dynamic> json) {
    return ProductsCompanion.insert(
      id: json['id'] as String,
      name: json['name'] as String,
      category: Value(json['category'] as String?),
      unit: json['unit'] as String,
      currentStock: (json['currentStock'] as num).toDouble(),
      maxStock: (json['maxStock'] as num).toDouble(),
      minStock: (json['minStock'] as num).toDouble(),
      iconKey: json['iconKey'] as String,
      iconColor: Value(json['iconColor'] as String? ?? '#3D2E1F'),
      isActive: Value(json['isActive'] as bool? ?? true),
      hiveSlot: Value(json['hiveSlot'] as int? ?? 0),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> _cycleRowToJson(PurchaseCycle row) => {
    'id': row.id,
    'productId': row.productId,
    'intervalDays': row.intervalDays,
    'isAutoEstimated': row.isAutoEstimated,
    'lastPurchaseDate': row.lastPurchaseDate?.toIso8601String(),
    'nextReminderDate': row.nextReminderDate?.toIso8601String(),
    'isEnabled': row.isEnabled,
  };

  PurchaseCyclesCompanion _cycleRowFromJson(Map<String, dynamic> json) {
    return PurchaseCyclesCompanion.insert(
      id: json['id'] as String,
      productId: json['productId'] as String,
      intervalDays: json['intervalDays'] as int,
      isAutoEstimated: Value(json['isAutoEstimated'] as bool? ?? false),
      lastPurchaseDate: Value(
        json['lastPurchaseDate'] == null
            ? null
            : DateTime.parse(json['lastPurchaseDate'] as String),
      ),
      nextReminderDate: Value(
        json['nextReminderDate'] == null
            ? null
            : DateTime.parse(json['nextReminderDate'] as String),
      ),
      isEnabled: Value(json['isEnabled'] as bool? ?? true),
    );
  }

  Map<String, dynamic> _historyRowToJson(StockHistory row) => {
    'id': row.id,
    'productId': row.productId,
    'delta': row.delta,
    'stockAfter': row.stockAfter,
    'reason': row.reason,
    'createdAt': row.createdAt.toIso8601String(),
  };

  StockHistoriesCompanion _historyRowFromJson(Map<String, dynamic> json) {
    return StockHistoriesCompanion.insert(
      id: json['id'] as String,
      productId: json['productId'] as String,
      delta: (json['delta'] as num).toDouble(),
      stockAfter: (json['stockAfter'] as num).toDouble(),
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> _recordRowToJson(PurchaseRecord row) => {
    'id': row.id,
    'productId': row.productId,
    'quantity': row.quantity,
    'storeName': row.storeName,
    'note': row.note,
    'source': row.source,
    'purchasedAt': row.purchasedAt.toIso8601String(),
  };

  PurchaseRecordsCompanion _recordRowFromJson(Map<String, dynamic> json) {
    return PurchaseRecordsCompanion.insert(
      id: json['id'] as String,
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      storeName: Value(json['storeName'] as String?),
      note: Value(json['note'] as String?),
      source: json['source'] as String,
      purchasedAt: DateTime.parse(json['purchasedAt'] as String),
    );
  }

  Map<String, dynamic> _cartRowToJson(CartItem row) => {
    'id': row.id,
    'productId': row.productId,
    'pendingName': row.pendingName,
    'quantity': row.quantity,
    'preferredStoreName': row.preferredStoreName,
    'note': row.note,
    'addedAt': row.addedAt.toIso8601String(),
  };

  CartItemsCompanion _cartRowFromJson(Map<String, dynamic> json) {
    return CartItemsCompanion.insert(
      id: json['id'] as String,
      productId: Value(json['productId'] as String?),
      pendingName: Value(json['pendingName'] as String?),
      quantity: (json['quantity'] as num).toDouble(),
      preferredStoreName: Value(json['preferredStoreName'] as String?),
      note: Value(json['note'] as String?),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}

class BackupException implements Exception {
  BackupException(this.message);

  final String message;

  @override
  String toString() => message;
}
