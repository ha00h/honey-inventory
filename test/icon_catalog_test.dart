import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:honey_inventory/presentation/shared/icon_catalog.dart';

void main() {
  test('parseIconColor reads 6-digit hex', () {
    expect(parseIconColor('#F5C842'), const Color(0xFFF5C842));
  });

  test('icon catalog keeps existing product keys', () {
    expect(iconForKey('tissue'), isNot(Icons.inventory_2_rounded));
    expect(iconForKey('water'), Icons.water_drop_rounded);
    expect(iconForKey('basket'), Icons.inventory_2_rounded);
    expect(iconOptions.length, greaterThan(50));
    expect(iconColorOptions.length, greaterThanOrEqualTo(12));
  });
}
