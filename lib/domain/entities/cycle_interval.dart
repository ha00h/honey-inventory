enum CycleIntervalUnit { day, week, month }

extension CycleIntervalUnitLabel on CycleIntervalUnit {
  String get label => switch (this) {
    CycleIntervalUnit.day => '일',
    CycleIntervalUnit.week => '주',
    CycleIntervalUnit.month => '월',
  };
}

int intervalToDays({required int value, required CycleIntervalUnit unit}) {
  return switch (unit) {
    CycleIntervalUnit.day => value,
    CycleIntervalUnit.week => value * 7,
    CycleIntervalUnit.month => value * 30,
  };
}

({int value, CycleIntervalUnit unit}) daysToInterval(int days) {
  if (days <= 0) {
    return (value: 0, unit: CycleIntervalUnit.day);
  }
  if (days % 30 == 0) {
    return (value: days ~/ 30, unit: CycleIntervalUnit.month);
  }
  if (days % 7 == 0) {
    return (value: days ~/ 7, unit: CycleIntervalUnit.week);
  }
  return (value: days, unit: CycleIntervalUnit.day);
}
