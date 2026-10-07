int nextEmptyHiveSlot(Iterable<int> occupied) {
  final taken = occupied.toSet();
  var slot = 0;
  while (taken.contains(slot)) {
    slot += 1;
  }
  return slot;
}

/// Keeps unique explicit slots and fills missing/colliding ones without holes
/// in the assignment sequence.
List<int> resolveImportedHiveSlots(List<int?> requested) {
  final taken = <int>{};
  final result = List<int>.filled(requested.length, -1);
  for (var i = 0; i < requested.length; i++) {
    final slot = requested[i];
    if (slot != null && slot >= 0 && !taken.contains(slot)) {
      result[i] = slot;
      taken.add(slot);
    }
  }
  for (var i = 0; i < result.length; i++) {
    if (result[i] >= 0) {
      continue;
    }
    final slot = nextEmptyHiveSlot(taken);
    result[i] = slot;
    taken.add(slot);
  }
  return result;
}

/// 빈 칸이면 [movingProductId]만 옮기고, 채워져 있으면 자리를 맞바꾼다.
Map<String, int> applyHiveMove({
  required Map<String, int> slotsByProductId,
  required String movingProductId,
  required int toSlot,
}) {
  final fromSlot = slotsByProductId[movingProductId];
  if (fromSlot == null || fromSlot == toSlot) {
    return Map<String, int>.from(slotsByProductId);
  }

  String? occupantId;
  for (final entry in slotsByProductId.entries) {
    if (entry.key == movingProductId) {
      continue;
    }
    if (entry.value == toSlot) {
      occupantId = entry.key;
      break;
    }
  }

  final next = Map<String, int>.from(slotsByProductId);
  next[movingProductId] = toSlot;
  if (occupantId != null) {
    next[occupantId] = fromSlot;
  }
  return next;
}
