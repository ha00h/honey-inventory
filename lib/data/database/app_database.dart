import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  TextColumn get unit => text()();
  RealColumn get currentStock => real()();
  RealColumn get maxStock => real()();
  RealColumn get minStock => real()();
  TextColumn get iconKey => text()();
  TextColumn get iconColor =>
      text().withDefault(const Constant('#3D2E1F'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get hiveSlot => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PurchaseCycles extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get intervalDays => integer()();
  BoolColumn get isAutoEstimated =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastPurchaseDate => dateTime().nullable()();
  DateTimeColumn get nextReminderDate => dateTime().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PurchaseRecords extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  RealColumn get quantity => real()();
  TextColumn get storeName => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get source => text()();
  DateTimeColumn get purchasedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StockHistories extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  RealColumn get delta => real()();
  RealColumn get stockAfter => real()();
  TextColumn get reason => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CartItems extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().nullable().references(Products, #id)();
  TextColumn get pendingName => text().nullable()();
  RealColumn get quantity => real()();
  TextColumn get preferredStoreName => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'honey_inventory.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(
  tables: [
    Products,
    PurchaseCycles,
    PurchaseRecords,
    StockHistories,
    CartItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(products, products.iconColor);
      }
      if (from < 3) {
        await migrator.addColumn(cartItems, cartItems.pendingName);
        await migrator.alterTable(TableMigration(cartItems));
      }
      if (from < 4) {
        await migrator.addColumn(products, products.hiveSlot);
        final rows =
            await (select(products)..orderBy([
                  (table) => OrderingTerm.asc(table.createdAt),
                ]))
                .get();
        var slot = 0;
        for (final row in rows.where((item) => item.isActive)) {
          await (update(products)..where((table) => table.id.equals(row.id)))
              .write(ProductsCompanion(hiveSlot: Value(slot)));
          slot += 1;
        }
        for (final row in rows.where((item) => !item.isActive)) {
          await (update(products)..where((table) => table.id.equals(row.id)))
              .write(ProductsCompanion(hiveSlot: Value(slot)));
          slot += 1;
        }
      }
    },
  );
}
