import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/data/database/app_database.dart';
import 'package:honey_inventory/data/repositories/backup_repository.dart';
import 'package:honey_inventory/data/repositories/settings_repository.dart';
import 'package:honey_inventory/data/simulation/household_simulation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('simulation seed has a full hive and a tissue ledger', () async {
    final decoded =
        jsonDecode(householdSimulationBackupJson()) as Map<String, dynamic>;
    final products = (decoded['products'] as List).cast<Map<String, dynamic>>();
    final histories = (decoded['stockHistories'] as List)
        .cast<Map<String, dynamic>>();

    expect(products.length, greaterThanOrEqualTo(50));
    expect(decoded['version'], 1);

    final tissue = products.firstWhere((row) => row['id'] == 'sim_tissue');
    final tissueHistory = histories
        .where((row) => row['productId'] == 'sim_tissue')
        .toList();
    expect(tissueHistory.length, greaterThanOrEqualTo(40));
    expect(
      tissueHistory.map((row) => row['reason']).toSet(),
      containsAll({'initial', 'usage', 'purchase', 'discard', 'adjust'}),
    );
    expect(tissueHistory.any((row) => (row['delta'] as num) < 0), isTrue);
    expect(tissueHistory.any((row) => (row['delta'] as num) > 0), isTrue);
    expect(tissueHistory.last['stockAfter'], tissue['currentStock']);

    SharedPreferences.setMockInitialValues({});
    final database = AppDatabase.forTesting();
    addTearDown(database.close);
    final repository = BackupRepository(
      database: database,
      settingsRepository: SettingsRepository(),
    );
    await repository.importFromJson(householdSimulationBackupJson());
    final stored = await database.select(database.products).get();
    expect(stored.length, products.length);
  });
}
