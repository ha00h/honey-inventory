// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStockMeta = const VerificationMeta(
    'currentStock',
  );
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
    'current_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxStockMeta = const VerificationMeta(
    'maxStock',
  );
  @override
  late final GeneratedColumn<double> maxStock = GeneratedColumn<double>(
    'max_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minStockMeta = const VerificationMeta(
    'minStock',
  );
  @override
  late final GeneratedColumn<double> minStock = GeneratedColumn<double>(
    'min_stock',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconColorMeta = const VerificationMeta(
    'iconColor',
  );
  @override
  late final GeneratedColumn<String> iconColor = GeneratedColumn<String>(
    'icon_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#3D2E1F'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hiveSlotMeta = const VerificationMeta(
    'hiveSlot',
  );
  @override
  late final GeneratedColumn<int> hiveSlot = GeneratedColumn<int>(
    'hive_slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    unit,
    currentStock,
    maxStock,
    minStock,
    iconKey,
    iconColor,
    isActive,
    hiveSlot,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('current_stock')) {
      context.handle(
        _currentStockMeta,
        currentStock.isAcceptableOrUnknown(
          data['current_stock']!,
          _currentStockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentStockMeta);
    }
    if (data.containsKey('max_stock')) {
      context.handle(
        _maxStockMeta,
        maxStock.isAcceptableOrUnknown(data['max_stock']!, _maxStockMeta),
      );
    } else if (isInserting) {
      context.missing(_maxStockMeta);
    }
    if (data.containsKey('min_stock')) {
      context.handle(
        _minStockMeta,
        minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta),
      );
    } else if (isInserting) {
      context.missing(_minStockMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('icon_color')) {
      context.handle(
        _iconColorMeta,
        iconColor.isAcceptableOrUnknown(data['icon_color']!, _iconColorMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('hive_slot')) {
      context.handle(
        _hiveSlotMeta,
        hiveSlot.isAcceptableOrUnknown(data['hive_slot']!, _hiveSlotMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      currentStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_stock'],
      )!,
      maxStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_stock'],
      )!,
      minStock: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_stock'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      iconColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_color'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      hiveSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hive_slot'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String? category;
  final String unit;
  final double currentStock;
  final double maxStock;
  final double minStock;
  final String iconKey;
  final String iconColor;
  final bool isActive;
  final int hiveSlot;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    this.category,
    required this.unit,
    required this.currentStock,
    required this.maxStock,
    required this.minStock,
    required this.iconKey,
    required this.iconColor,
    required this.isActive,
    required this.hiveSlot,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['unit'] = Variable<String>(unit);
    map['current_stock'] = Variable<double>(currentStock);
    map['max_stock'] = Variable<double>(maxStock);
    map['min_stock'] = Variable<double>(minStock);
    map['icon_key'] = Variable<String>(iconKey);
    map['icon_color'] = Variable<String>(iconColor);
    map['is_active'] = Variable<bool>(isActive);
    map['hive_slot'] = Variable<int>(hiveSlot);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      unit: Value(unit),
      currentStock: Value(currentStock),
      maxStock: Value(maxStock),
      minStock: Value(minStock),
      iconKey: Value(iconKey),
      iconColor: Value(iconColor),
      isActive: Value(isActive),
      hiveSlot: Value(hiveSlot),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      unit: serializer.fromJson<String>(json['unit']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      maxStock: serializer.fromJson<double>(json['maxStock']),
      minStock: serializer.fromJson<double>(json['minStock']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      iconColor: serializer.fromJson<String>(json['iconColor']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      hiveSlot: serializer.fromJson<int>(json['hiveSlot']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'unit': serializer.toJson<String>(unit),
      'currentStock': serializer.toJson<double>(currentStock),
      'maxStock': serializer.toJson<double>(maxStock),
      'minStock': serializer.toJson<double>(minStock),
      'iconKey': serializer.toJson<String>(iconKey),
      'iconColor': serializer.toJson<String>(iconColor),
      'isActive': serializer.toJson<bool>(isActive),
      'hiveSlot': serializer.toJson<int>(hiveSlot),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    Value<String?> category = const Value.absent(),
    String? unit,
    double? currentStock,
    double? maxStock,
    double? minStock,
    String? iconKey,
    String? iconColor,
    bool? isActive,
    int? hiveSlot,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    unit: unit ?? this.unit,
    currentStock: currentStock ?? this.currentStock,
    maxStock: maxStock ?? this.maxStock,
    minStock: minStock ?? this.minStock,
    iconKey: iconKey ?? this.iconKey,
    iconColor: iconColor ?? this.iconColor,
    isActive: isActive ?? this.isActive,
    hiveSlot: hiveSlot ?? this.hiveSlot,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      maxStock: data.maxStock.present ? data.maxStock.value : this.maxStock,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      iconColor: data.iconColor.present ? data.iconColor.value : this.iconColor,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      hiveSlot: data.hiveSlot.present ? data.hiveSlot.value : this.hiveSlot,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('currentStock: $currentStock, ')
          ..write('maxStock: $maxStock, ')
          ..write('minStock: $minStock, ')
          ..write('iconKey: $iconKey, ')
          ..write('iconColor: $iconColor, ')
          ..write('isActive: $isActive, ')
          ..write('hiveSlot: $hiveSlot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    unit,
    currentStock,
    maxStock,
    minStock,
    iconKey,
    iconColor,
    isActive,
    hiveSlot,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.currentStock == this.currentStock &&
          other.maxStock == this.maxStock &&
          other.minStock == this.minStock &&
          other.iconKey == this.iconKey &&
          other.iconColor == this.iconColor &&
          other.isActive == this.isActive &&
          other.hiveSlot == this.hiveSlot &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<String> unit;
  final Value<double> currentStock;
  final Value<double> maxStock;
  final Value<double> minStock;
  final Value<String> iconKey;
  final Value<String> iconColor;
  final Value<bool> isActive;
  final Value<int> hiveSlot;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.maxStock = const Value.absent(),
    this.minStock = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.iconColor = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hiveSlot = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    this.category = const Value.absent(),
    required String unit,
    required double currentStock,
    required double maxStock,
    required double minStock,
    required String iconKey,
    this.iconColor = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hiveSlot = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       unit = Value(unit),
       currentStock = Value(currentStock),
       maxStock = Value(maxStock),
       minStock = Value(minStock),
       iconKey = Value(iconKey),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<double>? currentStock,
    Expression<double>? maxStock,
    Expression<double>? minStock,
    Expression<String>? iconKey,
    Expression<String>? iconColor,
    Expression<bool>? isActive,
    Expression<int>? hiveSlot,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (currentStock != null) 'current_stock': currentStock,
      if (maxStock != null) 'max_stock': maxStock,
      if (minStock != null) 'min_stock': minStock,
      if (iconKey != null) 'icon_key': iconKey,
      if (iconColor != null) 'icon_color': iconColor,
      if (isActive != null) 'is_active': isActive,
      if (hiveSlot != null) 'hive_slot': hiveSlot,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<String>? unit,
    Value<double>? currentStock,
    Value<double>? maxStock,
    Value<double>? minStock,
    Value<String>? iconKey,
    Value<String>? iconColor,
    Value<bool>? isActive,
    Value<int>? hiveSlot,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      currentStock: currentStock ?? this.currentStock,
      maxStock: maxStock ?? this.maxStock,
      minStock: minStock ?? this.minStock,
      iconKey: iconKey ?? this.iconKey,
      iconColor: iconColor ?? this.iconColor,
      isActive: isActive ?? this.isActive,
      hiveSlot: hiveSlot ?? this.hiveSlot,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (maxStock.present) {
      map['max_stock'] = Variable<double>(maxStock.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<double>(minStock.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (iconColor.present) {
      map['icon_color'] = Variable<String>(iconColor.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (hiveSlot.present) {
      map['hive_slot'] = Variable<int>(hiveSlot.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('currentStock: $currentStock, ')
          ..write('maxStock: $maxStock, ')
          ..write('minStock: $minStock, ')
          ..write('iconKey: $iconKey, ')
          ..write('iconColor: $iconColor, ')
          ..write('isActive: $isActive, ')
          ..write('hiveSlot: $hiveSlot, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseCyclesTable extends PurchaseCycles
    with TableInfo<$PurchaseCyclesTable, PurchaseCycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseCyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAutoEstimatedMeta = const VerificationMeta(
    'isAutoEstimated',
  );
  @override
  late final GeneratedColumn<bool> isAutoEstimated = GeneratedColumn<bool>(
    'is_auto_estimated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_auto_estimated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastPurchaseDateMeta = const VerificationMeta(
    'lastPurchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastPurchaseDate =
      GeneratedColumn<DateTime>(
        'last_purchase_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextReminderDateMeta = const VerificationMeta(
    'nextReminderDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReminderDate =
      GeneratedColumn<DateTime>(
        'next_reminder_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    intervalDays,
    isAutoEstimated,
    lastPurchaseDate,
    nextReminderDate,
    isEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseCycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intervalDaysMeta);
    }
    if (data.containsKey('is_auto_estimated')) {
      context.handle(
        _isAutoEstimatedMeta,
        isAutoEstimated.isAcceptableOrUnknown(
          data['is_auto_estimated']!,
          _isAutoEstimatedMeta,
        ),
      );
    }
    if (data.containsKey('last_purchase_date')) {
      context.handle(
        _lastPurchaseDateMeta,
        lastPurchaseDate.isAcceptableOrUnknown(
          data['last_purchase_date']!,
          _lastPurchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('next_reminder_date')) {
      context.handle(
        _nextReminderDateMeta,
        nextReminderDate.isAcceptableOrUnknown(
          data['next_reminder_date']!,
          _nextReminderDateMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseCycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseCycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      isAutoEstimated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_auto_estimated'],
      )!,
      lastPurchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_purchase_date'],
      ),
      nextReminderDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_reminder_date'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
    );
  }

  @override
  $PurchaseCyclesTable createAlias(String alias) {
    return $PurchaseCyclesTable(attachedDatabase, alias);
  }
}

class PurchaseCycle extends DataClass implements Insertable<PurchaseCycle> {
  final String id;
  final String productId;
  final int intervalDays;
  final bool isAutoEstimated;
  final DateTime? lastPurchaseDate;
  final DateTime? nextReminderDate;
  final bool isEnabled;
  const PurchaseCycle({
    required this.id,
    required this.productId,
    required this.intervalDays,
    required this.isAutoEstimated,
    this.lastPurchaseDate,
    this.nextReminderDate,
    required this.isEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['interval_days'] = Variable<int>(intervalDays);
    map['is_auto_estimated'] = Variable<bool>(isAutoEstimated);
    if (!nullToAbsent || lastPurchaseDate != null) {
      map['last_purchase_date'] = Variable<DateTime>(lastPurchaseDate);
    }
    if (!nullToAbsent || nextReminderDate != null) {
      map['next_reminder_date'] = Variable<DateTime>(nextReminderDate);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    return map;
  }

  PurchaseCyclesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseCyclesCompanion(
      id: Value(id),
      productId: Value(productId),
      intervalDays: Value(intervalDays),
      isAutoEstimated: Value(isAutoEstimated),
      lastPurchaseDate: lastPurchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPurchaseDate),
      nextReminderDate: nextReminderDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReminderDate),
      isEnabled: Value(isEnabled),
    );
  }

  factory PurchaseCycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseCycle(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      isAutoEstimated: serializer.fromJson<bool>(json['isAutoEstimated']),
      lastPurchaseDate: serializer.fromJson<DateTime?>(
        json['lastPurchaseDate'],
      ),
      nextReminderDate: serializer.fromJson<DateTime?>(
        json['nextReminderDate'],
      ),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'isAutoEstimated': serializer.toJson<bool>(isAutoEstimated),
      'lastPurchaseDate': serializer.toJson<DateTime?>(lastPurchaseDate),
      'nextReminderDate': serializer.toJson<DateTime?>(nextReminderDate),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  PurchaseCycle copyWith({
    String? id,
    String? productId,
    int? intervalDays,
    bool? isAutoEstimated,
    Value<DateTime?> lastPurchaseDate = const Value.absent(),
    Value<DateTime?> nextReminderDate = const Value.absent(),
    bool? isEnabled,
  }) => PurchaseCycle(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    intervalDays: intervalDays ?? this.intervalDays,
    isAutoEstimated: isAutoEstimated ?? this.isAutoEstimated,
    lastPurchaseDate: lastPurchaseDate.present
        ? lastPurchaseDate.value
        : this.lastPurchaseDate,
    nextReminderDate: nextReminderDate.present
        ? nextReminderDate.value
        : this.nextReminderDate,
    isEnabled: isEnabled ?? this.isEnabled,
  );
  PurchaseCycle copyWithCompanion(PurchaseCyclesCompanion data) {
    return PurchaseCycle(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      isAutoEstimated: data.isAutoEstimated.present
          ? data.isAutoEstimated.value
          : this.isAutoEstimated,
      lastPurchaseDate: data.lastPurchaseDate.present
          ? data.lastPurchaseDate.value
          : this.lastPurchaseDate,
      nextReminderDate: data.nextReminderDate.present
          ? data.nextReminderDate.value
          : this.nextReminderDate,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseCycle(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('isAutoEstimated: $isAutoEstimated, ')
          ..write('lastPurchaseDate: $lastPurchaseDate, ')
          ..write('nextReminderDate: $nextReminderDate, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    intervalDays,
    isAutoEstimated,
    lastPurchaseDate,
    nextReminderDate,
    isEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseCycle &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.intervalDays == this.intervalDays &&
          other.isAutoEstimated == this.isAutoEstimated &&
          other.lastPurchaseDate == this.lastPurchaseDate &&
          other.nextReminderDate == this.nextReminderDate &&
          other.isEnabled == this.isEnabled);
}

class PurchaseCyclesCompanion extends UpdateCompanion<PurchaseCycle> {
  final Value<String> id;
  final Value<String> productId;
  final Value<int> intervalDays;
  final Value<bool> isAutoEstimated;
  final Value<DateTime?> lastPurchaseDate;
  final Value<DateTime?> nextReminderDate;
  final Value<bool> isEnabled;
  final Value<int> rowid;
  const PurchaseCyclesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.isAutoEstimated = const Value.absent(),
    this.lastPurchaseDate = const Value.absent(),
    this.nextReminderDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseCyclesCompanion.insert({
    required String id,
    required String productId,
    required int intervalDays,
    this.isAutoEstimated = const Value.absent(),
    this.lastPurchaseDate = const Value.absent(),
    this.nextReminderDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       intervalDays = Value(intervalDays);
  static Insertable<PurchaseCycle> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<int>? intervalDays,
    Expression<bool>? isAutoEstimated,
    Expression<DateTime>? lastPurchaseDate,
    Expression<DateTime>? nextReminderDate,
    Expression<bool>? isEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (isAutoEstimated != null) 'is_auto_estimated': isAutoEstimated,
      if (lastPurchaseDate != null) 'last_purchase_date': lastPurchaseDate,
      if (nextReminderDate != null) 'next_reminder_date': nextReminderDate,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseCyclesCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<int>? intervalDays,
    Value<bool>? isAutoEstimated,
    Value<DateTime?>? lastPurchaseDate,
    Value<DateTime?>? nextReminderDate,
    Value<bool>? isEnabled,
    Value<int>? rowid,
  }) {
    return PurchaseCyclesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      intervalDays: intervalDays ?? this.intervalDays,
      isAutoEstimated: isAutoEstimated ?? this.isAutoEstimated,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      nextReminderDate: nextReminderDate ?? this.nextReminderDate,
      isEnabled: isEnabled ?? this.isEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (isAutoEstimated.present) {
      map['is_auto_estimated'] = Variable<bool>(isAutoEstimated.value);
    }
    if (lastPurchaseDate.present) {
      map['last_purchase_date'] = Variable<DateTime>(lastPurchaseDate.value);
    }
    if (nextReminderDate.present) {
      map['next_reminder_date'] = Variable<DateTime>(nextReminderDate.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseCyclesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('isAutoEstimated: $isAutoEstimated, ')
          ..write('lastPurchaseDate: $lastPurchaseDate, ')
          ..write('nextReminderDate: $nextReminderDate, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseRecordsTable extends PurchaseRecords
    with TableInfo<$PurchaseRecordsTable, PurchaseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    quantity,
    storeName,
    note,
    source,
    purchasedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
    );
  }

  @override
  $PurchaseRecordsTable createAlias(String alias) {
    return $PurchaseRecordsTable(attachedDatabase, alias);
  }
}

class PurchaseRecord extends DataClass implements Insertable<PurchaseRecord> {
  final String id;
  final String productId;
  final double quantity;
  final String? storeName;
  final String? note;
  final String source;
  final DateTime purchasedAt;
  const PurchaseRecord({
    required this.id,
    required this.productId,
    required this.quantity,
    this.storeName,
    this.note,
    required this.source,
    required this.purchasedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source'] = Variable<String>(source);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    return map;
  }

  PurchaseRecordsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseRecordsCompanion(
      id: Value(id),
      productId: Value(productId),
      quantity: Value(quantity),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
      purchasedAt: Value(purchasedAt),
    );
  }

  factory PurchaseRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseRecord(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      storeName: serializer.fromJson<String?>(json['storeName']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String>(json['source']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'storeName': serializer.toJson<String?>(storeName),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String>(source),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
    };
  }

  PurchaseRecord copyWith({
    String? id,
    String? productId,
    double? quantity,
    Value<String?> storeName = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? source,
    DateTime? purchasedAt,
  }) => PurchaseRecord(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    storeName: storeName.present ? storeName.value : this.storeName,
    note: note.present ? note.value : this.note,
    source: source ?? this.source,
    purchasedAt: purchasedAt ?? this.purchasedAt,
  );
  PurchaseRecord copyWithCompanion(PurchaseRecordsCompanion data) {
    return PurchaseRecord(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseRecord(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('storeName: $storeName, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('purchasedAt: $purchasedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    quantity,
    storeName,
    note,
    source,
    purchasedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseRecord &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.storeName == this.storeName &&
          other.note == this.note &&
          other.source == this.source &&
          other.purchasedAt == this.purchasedAt);
}

class PurchaseRecordsCompanion extends UpdateCompanion<PurchaseRecord> {
  final Value<String> id;
  final Value<String> productId;
  final Value<double> quantity;
  final Value<String?> storeName;
  final Value<String?> note;
  final Value<String> source;
  final Value<DateTime> purchasedAt;
  final Value<int> rowid;
  const PurchaseRecordsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.storeName = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseRecordsCompanion.insert({
    required String id,
    required String productId,
    required double quantity,
    this.storeName = const Value.absent(),
    this.note = const Value.absent(),
    required String source,
    required DateTime purchasedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       quantity = Value(quantity),
       source = Value(source),
       purchasedAt = Value(purchasedAt);
  static Insertable<PurchaseRecord> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<double>? quantity,
    Expression<String>? storeName,
    Expression<String>? note,
    Expression<String>? source,
    Expression<DateTime>? purchasedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (storeName != null) 'store_name': storeName,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<double>? quantity,
    Value<String?>? storeName,
    Value<String?>? note,
    Value<String>? source,
    Value<DateTime>? purchasedAt,
    Value<int>? rowid,
  }) {
    return PurchaseRecordsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      storeName: storeName ?? this.storeName,
      note: note ?? this.note,
      source: source ?? this.source,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('storeName: $storeName, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockHistoriesTable extends StockHistories
    with TableInfo<$StockHistoriesTable, StockHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<double> delta = GeneratedColumn<double>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockAfterMeta = const VerificationMeta(
    'stockAfter',
  );
  @override
  late final GeneratedColumn<double> stockAfter = GeneratedColumn<double>(
    'stock_after',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    delta,
    stockAfter,
    reason,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('stock_after')) {
      context.handle(
        _stockAfterMeta,
        stockAfter.isAcceptableOrUnknown(data['stock_after']!, _stockAfterMeta),
      );
    } else if (isInserting) {
      context.missing(_stockAfterMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delta'],
      )!,
      stockAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_after'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockHistoriesTable createAlias(String alias) {
    return $StockHistoriesTable(attachedDatabase, alias);
  }
}

class StockHistory extends DataClass implements Insertable<StockHistory> {
  final String id;
  final String productId;
  final double delta;
  final double stockAfter;
  final String reason;
  final DateTime createdAt;
  const StockHistory({
    required this.id,
    required this.productId,
    required this.delta,
    required this.stockAfter,
    required this.reason,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['delta'] = Variable<double>(delta);
    map['stock_after'] = Variable<double>(stockAfter);
    map['reason'] = Variable<String>(reason);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockHistoriesCompanion toCompanion(bool nullToAbsent) {
    return StockHistoriesCompanion(
      id: Value(id),
      productId: Value(productId),
      delta: Value(delta),
      stockAfter: Value(stockAfter),
      reason: Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory StockHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockHistory(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      delta: serializer.fromJson<double>(json['delta']),
      stockAfter: serializer.fromJson<double>(json['stockAfter']),
      reason: serializer.fromJson<String>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'delta': serializer.toJson<double>(delta),
      'stockAfter': serializer.toJson<double>(stockAfter),
      'reason': serializer.toJson<String>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockHistory copyWith({
    String? id,
    String? productId,
    double? delta,
    double? stockAfter,
    String? reason,
    DateTime? createdAt,
  }) => StockHistory(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    delta: delta ?? this.delta,
    stockAfter: stockAfter ?? this.stockAfter,
    reason: reason ?? this.reason,
    createdAt: createdAt ?? this.createdAt,
  );
  StockHistory copyWithCompanion(StockHistoriesCompanion data) {
    return StockHistory(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      delta: data.delta.present ? data.delta.value : this.delta,
      stockAfter: data.stockAfter.present
          ? data.stockAfter.value
          : this.stockAfter,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockHistory(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('delta: $delta, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, delta, stockAfter, reason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockHistory &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.delta == this.delta &&
          other.stockAfter == this.stockAfter &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class StockHistoriesCompanion extends UpdateCompanion<StockHistory> {
  final Value<String> id;
  final Value<String> productId;
  final Value<double> delta;
  final Value<double> stockAfter;
  final Value<String> reason;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockHistoriesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.delta = const Value.absent(),
    this.stockAfter = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockHistoriesCompanion.insert({
    required String id,
    required String productId,
    required double delta,
    required double stockAfter,
    required String reason,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       delta = Value(delta),
       stockAfter = Value(stockAfter),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<StockHistory> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<double>? delta,
    Expression<double>? stockAfter,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (delta != null) 'delta': delta,
      if (stockAfter != null) 'stock_after': stockAfter,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockHistoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<double>? delta,
    Value<double>? stockAfter,
    Value<String>? reason,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StockHistoriesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      delta: delta ?? this.delta,
      stockAfter: stockAfter ?? this.stockAfter,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (delta.present) {
      map['delta'] = Variable<double>(delta.value);
    }
    if (stockAfter.present) {
      map['stock_after'] = Variable<double>(stockAfter.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('delta: $delta, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CartItemsTable extends CartItems
    with TableInfo<$CartItemsTable, CartItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _pendingNameMeta = const VerificationMeta(
    'pendingName',
  );
  @override
  late final GeneratedColumn<String> pendingName = GeneratedColumn<String>(
    'pending_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredStoreNameMeta =
      const VerificationMeta('preferredStoreName');
  @override
  late final GeneratedColumn<String> preferredStoreName =
      GeneratedColumn<String>(
        'preferred_store_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    pendingName,
    quantity,
    preferredStoreName,
    note,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CartItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('pending_name')) {
      context.handle(
        _pendingNameMeta,
        pendingName.isAcceptableOrUnknown(
          data['pending_name']!,
          _pendingNameMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('preferred_store_name')) {
      context.handle(
        _preferredStoreNameMeta,
        preferredStoreName.isAcceptableOrUnknown(
          data['preferred_store_name']!,
          _preferredStoreNameMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CartItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      pendingName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_name'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      preferredStoreName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_store_name'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(attachedDatabase, alias);
  }
}

class CartItem extends DataClass implements Insertable<CartItem> {
  final String id;
  final String? productId;
  final String? pendingName;
  final double quantity;
  final String? preferredStoreName;
  final String? note;
  final DateTime addedAt;
  const CartItem({
    required this.id,
    this.productId,
    this.pendingName,
    required this.quantity,
    this.preferredStoreName,
    this.note,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || pendingName != null) {
      map['pending_name'] = Variable<String>(pendingName);
    }
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || preferredStoreName != null) {
      map['preferred_store_name'] = Variable<String>(preferredStoreName);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      id: Value(id),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      pendingName: pendingName == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingName),
      quantity: Value(quantity),
      preferredStoreName: preferredStoreName == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredStoreName),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      addedAt: Value(addedAt),
    );
  }

  factory CartItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItem(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String?>(json['productId']),
      pendingName: serializer.fromJson<String?>(json['pendingName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      preferredStoreName: serializer.fromJson<String?>(
        json['preferredStoreName'],
      ),
      note: serializer.fromJson<String?>(json['note']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String?>(productId),
      'pendingName': serializer.toJson<String?>(pendingName),
      'quantity': serializer.toJson<double>(quantity),
      'preferredStoreName': serializer.toJson<String?>(preferredStoreName),
      'note': serializer.toJson<String?>(note),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  CartItem copyWith({
    String? id,
    Value<String?> productId = const Value.absent(),
    Value<String?> pendingName = const Value.absent(),
    double? quantity,
    Value<String?> preferredStoreName = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? addedAt,
  }) => CartItem(
    id: id ?? this.id,
    productId: productId.present ? productId.value : this.productId,
    pendingName: pendingName.present ? pendingName.value : this.pendingName,
    quantity: quantity ?? this.quantity,
    preferredStoreName: preferredStoreName.present
        ? preferredStoreName.value
        : this.preferredStoreName,
    note: note.present ? note.value : this.note,
    addedAt: addedAt ?? this.addedAt,
  );
  CartItem copyWithCompanion(CartItemsCompanion data) {
    return CartItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      pendingName: data.pendingName.present
          ? data.pendingName.value
          : this.pendingName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      preferredStoreName: data.preferredStoreName.present
          ? data.preferredStoreName.value
          : this.preferredStoreName,
      note: data.note.present ? data.note.value : this.note,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('pendingName: $pendingName, ')
          ..write('quantity: $quantity, ')
          ..write('preferredStoreName: $preferredStoreName, ')
          ..write('note: $note, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    pendingName,
    quantity,
    preferredStoreName,
    note,
    addedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.pendingName == this.pendingName &&
          other.quantity == this.quantity &&
          other.preferredStoreName == this.preferredStoreName &&
          other.note == this.note &&
          other.addedAt == this.addedAt);
}

class CartItemsCompanion extends UpdateCompanion<CartItem> {
  final Value<String> id;
  final Value<String?> productId;
  final Value<String?> pendingName;
  final Value<double> quantity;
  final Value<String?> preferredStoreName;
  final Value<String?> note;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const CartItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.pendingName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.preferredStoreName = const Value.absent(),
    this.note = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartItemsCompanion.insert({
    required String id,
    this.productId = const Value.absent(),
    this.pendingName = const Value.absent(),
    required double quantity,
    this.preferredStoreName = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quantity = Value(quantity),
       addedAt = Value(addedAt);
  static Insertable<CartItem> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? pendingName,
    Expression<double>? quantity,
    Expression<String>? preferredStoreName,
    Expression<String>? note,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (pendingName != null) 'pending_name': pendingName,
      if (quantity != null) 'quantity': quantity,
      if (preferredStoreName != null)
        'preferred_store_name': preferredStoreName,
      if (note != null) 'note': note,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? productId,
    Value<String?>? pendingName,
    Value<double>? quantity,
    Value<String?>? preferredStoreName,
    Value<String?>? note,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return CartItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      pendingName: pendingName ?? this.pendingName,
      quantity: quantity ?? this.quantity,
      preferredStoreName: preferredStoreName ?? this.preferredStoreName,
      note: note ?? this.note,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (pendingName.present) {
      map['pending_name'] = Variable<String>(pendingName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (preferredStoreName.present) {
      map['preferred_store_name'] = Variable<String>(preferredStoreName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('pendingName: $pendingName, ')
          ..write('quantity: $quantity, ')
          ..write('preferredStoreName: $preferredStoreName, ')
          ..write('note: $note, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $PurchaseCyclesTable purchaseCycles = $PurchaseCyclesTable(this);
  late final $PurchaseRecordsTable purchaseRecords = $PurchaseRecordsTable(
    this,
  );
  late final $StockHistoriesTable stockHistories = $StockHistoriesTable(this);
  late final $CartItemsTable cartItems = $CartItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    purchaseCycles,
    purchaseRecords,
    stockHistories,
    cartItems,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      Value<String?> category,
      required String unit,
      required double currentStock,
      required double maxStock,
      required double minStock,
      required String iconKey,
      Value<String> iconColor,
      Value<bool> isActive,
      Value<int> hiveSlot,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> category,
      Value<String> unit,
      Value<double> currentStock,
      Value<double> maxStock,
      Value<double> minStock,
      Value<String> iconKey,
      Value<String> iconColor,
      Value<bool> isActive,
      Value<int> hiveSlot,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchaseCyclesTable, List<PurchaseCycle>>
  _purchaseCyclesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseCycles,
    aliasName: 'products__id__purchase_cycles__product_id',
  );

  $$PurchaseCyclesTableProcessedTableManager get purchaseCyclesRefs {
    final manager = $$PurchaseCyclesTableTableManager(
      $_db,
      $_db.purchaseCycles,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseCyclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PurchaseRecordsTable, List<PurchaseRecord>>
  _purchaseRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseRecords,
    aliasName: 'products__id__purchase_records__product_id',
  );

  $$PurchaseRecordsTableProcessedTableManager get purchaseRecordsRefs {
    final manager = $$PurchaseRecordsTableTableManager(
      $_db,
      $_db.purchaseRecords,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _purchaseRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockHistoriesTable, List<StockHistory>>
  _stockHistoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockHistories,
    aliasName: 'products__id__stock_histories__product_id',
  );

  $$StockHistoriesTableProcessedTableManager get stockHistoriesRefs {
    final manager = $$StockHistoriesTableTableManager(
      $_db,
      $_db.stockHistories,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockHistoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CartItemsTable, List<CartItem>>
  _cartItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cartItems,
    aliasName: 'products__id__cart_items__product_id',
  );

  $$CartItemsTableProcessedTableManager get cartItemsRefs {
    final manager = $$CartItemsTableTableManager(
      $_db,
      $_db.cartItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cartItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxStock => $composableBuilder(
    column: $table.maxStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconColor => $composableBuilder(
    column: $table.iconColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hiveSlot => $composableBuilder(
    column: $table.hiveSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> purchaseCyclesRefs(
    Expression<bool> Function($$PurchaseCyclesTableFilterComposer f) f,
  ) {
    final $$PurchaseCyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseCycles,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseCyclesTableFilterComposer(
            $db: $db,
            $table: $db.purchaseCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> purchaseRecordsRefs(
    Expression<bool> Function($$PurchaseRecordsTableFilterComposer f) f,
  ) {
    final $$PurchaseRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseRecords,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseRecordsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockHistoriesRefs(
    Expression<bool> Function($$StockHistoriesTableFilterComposer f) f,
  ) {
    final $$StockHistoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockHistories,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockHistoriesTableFilterComposer(
            $db: $db,
            $table: $db.stockHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cartItemsRefs(
    Expression<bool> Function($$CartItemsTableFilterComposer f) f,
  ) {
    final $$CartItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableFilterComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxStock => $composableBuilder(
    column: $table.maxStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconColor => $composableBuilder(
    column: $table.iconColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hiveSlot => $composableBuilder(
    column: $table.hiveSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxStock =>
      $composableBuilder(column: $table.maxStock, builder: (column) => column);

  GeneratedColumn<double> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<String> get iconColor =>
      $composableBuilder(column: $table.iconColor, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get hiveSlot =>
      $composableBuilder(column: $table.hiveSlot, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> purchaseCyclesRefs<T extends Object>(
    Expression<T> Function($$PurchaseCyclesTableAnnotationComposer a) f,
  ) {
    final $$PurchaseCyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseCycles,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseCyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> purchaseRecordsRefs<T extends Object>(
    Expression<T> Function($$PurchaseRecordsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseRecords,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockHistoriesRefs<T extends Object>(
    Expression<T> Function($$StockHistoriesTableAnnotationComposer a) f,
  ) {
    final $$StockHistoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockHistories,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockHistoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockHistories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cartItemsRefs<T extends Object>(
    Expression<T> Function($$CartItemsTableAnnotationComposer a) f,
  ) {
    final $$CartItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cartItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.cartItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool purchaseCyclesRefs,
            bool purchaseRecordsRefs,
            bool stockHistoriesRefs,
            bool cartItemsRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> currentStock = const Value.absent(),
                Value<double> maxStock = const Value.absent(),
                Value<double> minStock = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<String> iconColor = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> hiveSlot = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                category: category,
                unit: unit,
                currentStock: currentStock,
                maxStock: maxStock,
                minStock: minStock,
                iconKey: iconKey,
                iconColor: iconColor,
                isActive: isActive,
                hiveSlot: hiveSlot,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> category = const Value.absent(),
                required String unit,
                required double currentStock,
                required double maxStock,
                required double minStock,
                required String iconKey,
                Value<String> iconColor = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> hiveSlot = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                category: category,
                unit: unit,
                currentStock: currentStock,
                maxStock: maxStock,
                minStock: minStock,
                iconKey: iconKey,
                iconColor: iconColor,
                isActive: isActive,
                hiveSlot: hiveSlot,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                purchaseCyclesRefs = false,
                purchaseRecordsRefs = false,
                stockHistoriesRefs = false,
                cartItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (purchaseCyclesRefs) db.purchaseCycles,
                    if (purchaseRecordsRefs) db.purchaseRecords,
                    if (stockHistoriesRefs) db.stockHistories,
                    if (cartItemsRefs) db.cartItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (purchaseCyclesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          PurchaseCycle
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._purchaseCyclesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseCyclesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (purchaseRecordsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          PurchaseRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._purchaseRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).purchaseRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockHistoriesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          StockHistory
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._stockHistoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockHistoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cartItemsRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          CartItem
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._cartItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).cartItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool purchaseCyclesRefs,
        bool purchaseRecordsRefs,
        bool stockHistoriesRefs,
        bool cartItemsRefs,
      })
    >;
typedef $$PurchaseCyclesTableCreateCompanionBuilder =
    PurchaseCyclesCompanion Function({
      required String id,
      required String productId,
      required int intervalDays,
      Value<bool> isAutoEstimated,
      Value<DateTime?> lastPurchaseDate,
      Value<DateTime?> nextReminderDate,
      Value<bool> isEnabled,
      Value<int> rowid,
    });
typedef $$PurchaseCyclesTableUpdateCompanionBuilder =
    PurchaseCyclesCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<int> intervalDays,
      Value<bool> isAutoEstimated,
      Value<DateTime?> lastPurchaseDate,
      Value<DateTime?> nextReminderDate,
      Value<bool> isEnabled,
      Value<int> rowid,
    });

final class $$PurchaseCyclesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseCyclesTable, PurchaseCycle> {
  $$PurchaseCyclesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('purchase_cycles__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchaseCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseCyclesTable> {
  $$PurchaseCyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAutoEstimated => $composableBuilder(
    column: $table.isAutoEstimated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPurchaseDate => $composableBuilder(
    column: $table.lastPurchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReminderDate => $composableBuilder(
    column: $table.nextReminderDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseCyclesTable> {
  $$PurchaseCyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAutoEstimated => $composableBuilder(
    column: $table.isAutoEstimated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPurchaseDate => $composableBuilder(
    column: $table.lastPurchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReminderDate => $composableBuilder(
    column: $table.nextReminderDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseCyclesTable> {
  $$PurchaseCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAutoEstimated => $composableBuilder(
    column: $table.isAutoEstimated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPurchaseDate => $composableBuilder(
    column: $table.lastPurchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReminderDate => $composableBuilder(
    column: $table.nextReminderDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseCyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseCyclesTable,
          PurchaseCycle,
          $$PurchaseCyclesTableFilterComposer,
          $$PurchaseCyclesTableOrderingComposer,
          $$PurchaseCyclesTableAnnotationComposer,
          $$PurchaseCyclesTableCreateCompanionBuilder,
          $$PurchaseCyclesTableUpdateCompanionBuilder,
          (PurchaseCycle, $$PurchaseCyclesTableReferences),
          PurchaseCycle,
          PrefetchHooks Function({bool productId})
        > {
  $$PurchaseCyclesTableTableManager(
    _$AppDatabase db,
    $PurchaseCyclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<bool> isAutoEstimated = const Value.absent(),
                Value<DateTime?> lastPurchaseDate = const Value.absent(),
                Value<DateTime?> nextReminderDate = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseCyclesCompanion(
                id: id,
                productId: productId,
                intervalDays: intervalDays,
                isAutoEstimated: isAutoEstimated,
                lastPurchaseDate: lastPurchaseDate,
                nextReminderDate: nextReminderDate,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required int intervalDays,
                Value<bool> isAutoEstimated = const Value.absent(),
                Value<DateTime?> lastPurchaseDate = const Value.absent(),
                Value<DateTime?> nextReminderDate = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseCyclesCompanion.insert(
                id: id,
                productId: productId,
                intervalDays: intervalDays,
                isAutoEstimated: isAutoEstimated,
                lastPurchaseDate: lastPurchaseDate,
                nextReminderDate: nextReminderDate,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchaseCyclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$PurchaseCyclesTableReferences
                                    ._productIdTable(db),
                                referencedColumn:
                                    $$PurchaseCyclesTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseCyclesTable,
      PurchaseCycle,
      $$PurchaseCyclesTableFilterComposer,
      $$PurchaseCyclesTableOrderingComposer,
      $$PurchaseCyclesTableAnnotationComposer,
      $$PurchaseCyclesTableCreateCompanionBuilder,
      $$PurchaseCyclesTableUpdateCompanionBuilder,
      (PurchaseCycle, $$PurchaseCyclesTableReferences),
      PurchaseCycle,
      PrefetchHooks Function({bool productId})
    >;
typedef $$PurchaseRecordsTableCreateCompanionBuilder =
    PurchaseRecordsCompanion Function({
      required String id,
      required String productId,
      required double quantity,
      Value<String?> storeName,
      Value<String?> note,
      required String source,
      required DateTime purchasedAt,
      Value<int> rowid,
    });
typedef $$PurchaseRecordsTableUpdateCompanionBuilder =
    PurchaseRecordsCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<double> quantity,
      Value<String?> storeName,
      Value<String?> note,
      Value<String> source,
      Value<DateTime> purchasedAt,
      Value<int> rowid,
    });

final class $$PurchaseRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PurchaseRecordsTable, PurchaseRecord> {
  $$PurchaseRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('purchase_records__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchaseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseRecordsTable> {
  $$PurchaseRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseRecordsTable> {
  $$PurchaseRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseRecordsTable> {
  $$PurchaseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseRecordsTable,
          PurchaseRecord,
          $$PurchaseRecordsTableFilterComposer,
          $$PurchaseRecordsTableOrderingComposer,
          $$PurchaseRecordsTableAnnotationComposer,
          $$PurchaseRecordsTableCreateCompanionBuilder,
          $$PurchaseRecordsTableUpdateCompanionBuilder,
          (PurchaseRecord, $$PurchaseRecordsTableReferences),
          PurchaseRecord,
          PrefetchHooks Function({bool productId})
        > {
  $$PurchaseRecordsTableTableManager(
    _$AppDatabase db,
    $PurchaseRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseRecordsCompanion(
                id: id,
                productId: productId,
                quantity: quantity,
                storeName: storeName,
                note: note,
                source: source,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required double quantity,
                Value<String?> storeName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String source,
                required DateTime purchasedAt,
                Value<int> rowid = const Value.absent(),
              }) => PurchaseRecordsCompanion.insert(
                id: id,
                productId: productId,
                quantity: quantity,
                storeName: storeName,
                note: note,
                source: source,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchaseRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$PurchaseRecordsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$PurchaseRecordsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseRecordsTable,
      PurchaseRecord,
      $$PurchaseRecordsTableFilterComposer,
      $$PurchaseRecordsTableOrderingComposer,
      $$PurchaseRecordsTableAnnotationComposer,
      $$PurchaseRecordsTableCreateCompanionBuilder,
      $$PurchaseRecordsTableUpdateCompanionBuilder,
      (PurchaseRecord, $$PurchaseRecordsTableReferences),
      PurchaseRecord,
      PrefetchHooks Function({bool productId})
    >;
typedef $$StockHistoriesTableCreateCompanionBuilder =
    StockHistoriesCompanion Function({
      required String id,
      required String productId,
      required double delta,
      required double stockAfter,
      required String reason,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StockHistoriesTableUpdateCompanionBuilder =
    StockHistoriesCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<double> delta,
      Value<double> stockAfter,
      Value<String> reason,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StockHistoriesTableReferences
    extends BaseReferences<_$AppDatabase, $StockHistoriesTable, StockHistory> {
  $$StockHistoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('stock_histories__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StockHistoriesTable> {
  $$StockHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockAfter => $composableBuilder(
    column: $table.stockAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockHistoriesTable> {
  $$StockHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockAfter => $composableBuilder(
    column: $table.stockAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockHistoriesTable> {
  $$StockHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<double> get stockAfter => $composableBuilder(
    column: $table.stockAfter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockHistoriesTable,
          StockHistory,
          $$StockHistoriesTableFilterComposer,
          $$StockHistoriesTableOrderingComposer,
          $$StockHistoriesTableAnnotationComposer,
          $$StockHistoriesTableCreateCompanionBuilder,
          $$StockHistoriesTableUpdateCompanionBuilder,
          (StockHistory, $$StockHistoriesTableReferences),
          StockHistory,
          PrefetchHooks Function({bool productId})
        > {
  $$StockHistoriesTableTableManager(
    _$AppDatabase db,
    $StockHistoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<double> delta = const Value.absent(),
                Value<double> stockAfter = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockHistoriesCompanion(
                id: id,
                productId: productId,
                delta: delta,
                stockAfter: stockAfter,
                reason: reason,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required double delta,
                required double stockAfter,
                required String reason,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StockHistoriesCompanion.insert(
                id: id,
                productId: productId,
                delta: delta,
                stockAfter: stockAfter,
                reason: reason,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockHistoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$StockHistoriesTableReferences
                                    ._productIdTable(db),
                                referencedColumn:
                                    $$StockHistoriesTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StockHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockHistoriesTable,
      StockHistory,
      $$StockHistoriesTableFilterComposer,
      $$StockHistoriesTableOrderingComposer,
      $$StockHistoriesTableAnnotationComposer,
      $$StockHistoriesTableCreateCompanionBuilder,
      $$StockHistoriesTableUpdateCompanionBuilder,
      (StockHistory, $$StockHistoriesTableReferences),
      StockHistory,
      PrefetchHooks Function({bool productId})
    >;
typedef $$CartItemsTableCreateCompanionBuilder =
    CartItemsCompanion Function({
      required String id,
      Value<String?> productId,
      Value<String?> pendingName,
      required double quantity,
      Value<String?> preferredStoreName,
      Value<String?> note,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$CartItemsTableUpdateCompanionBuilder =
    CartItemsCompanion Function({
      Value<String> id,
      Value<String?> productId,
      Value<String?> pendingName,
      Value<double> quantity,
      Value<String?> preferredStoreName,
      Value<String?> note,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

final class $$CartItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CartItemsTable, CartItem> {
  $$CartItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('cart_items__product_id__products__id');

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<String>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingName => $composableBuilder(
    column: $table.pendingName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredStoreName => $composableBuilder(
    column: $table.preferredStoreName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingName => $composableBuilder(
    column: $table.pendingName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredStoreName => $composableBuilder(
    column: $table.preferredStoreName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pendingName => $composableBuilder(
    column: $table.pendingName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get preferredStoreName => $composableBuilder(
    column: $table.preferredStoreName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CartItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartItemsTable,
          CartItem,
          $$CartItemsTableFilterComposer,
          $$CartItemsTableOrderingComposer,
          $$CartItemsTableAnnotationComposer,
          $$CartItemsTableCreateCompanionBuilder,
          $$CartItemsTableUpdateCompanionBuilder,
          (CartItem, $$CartItemsTableReferences),
          CartItem,
          PrefetchHooks Function({bool productId})
        > {
  $$CartItemsTableTableManager(_$AppDatabase db, $CartItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> pendingName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String?> preferredStoreName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CartItemsCompanion(
                id: id,
                productId: productId,
                pendingName: pendingName,
                quantity: quantity,
                preferredStoreName: preferredStoreName,
                note: note,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> productId = const Value.absent(),
                Value<String?> pendingName = const Value.absent(),
                required double quantity,
                Value<String?> preferredStoreName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => CartItemsCompanion.insert(
                id: id,
                productId: productId,
                pendingName: pendingName,
                quantity: quantity,
                preferredStoreName: preferredStoreName,
                note: note,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CartItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$CartItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$CartItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CartItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartItemsTable,
      CartItem,
      $$CartItemsTableFilterComposer,
      $$CartItemsTableOrderingComposer,
      $$CartItemsTableAnnotationComposer,
      $$CartItemsTableCreateCompanionBuilder,
      $$CartItemsTableUpdateCompanionBuilder,
      (CartItem, $$CartItemsTableReferences),
      CartItem,
      PrefetchHooks Function({bool productId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$PurchaseCyclesTableTableManager get purchaseCycles =>
      $$PurchaseCyclesTableTableManager(_db, _db.purchaseCycles);
  $$PurchaseRecordsTableTableManager get purchaseRecords =>
      $$PurchaseRecordsTableTableManager(_db, _db.purchaseRecords);
  $$StockHistoriesTableTableManager get stockHistories =>
      $$StockHistoriesTableTableManager(_db, _db.stockHistories);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db, _db.cartItems);
}
