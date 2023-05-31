import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';

extension ColorConverter on Color {
  static Color parse(String hexColor) {
    try { return Color(int.parse(hexColor, radix: 16) + 0xFF000000); }
    catch (e) { return Colors.white; }
  }

  String toHex() {
    return value.toRadixString(16);
  }
}

extension DailySort on Daily {
  List<Item> getSortedItems() {
    List<Item> list = items.toList();
    list.sort((item1, item2) => item1.order?.compareTo(item2.order ?? -1) ?? 0);
    return list;
  }
}

extension ListSort on TodoList {
  List<Item> getSortedCompletedDailies() {
    List<Item> list = completeDailies.toList();
    list.sort((item1, item2) {
      int compareDaily = item1.daily.value?.id.compareTo(item2.daily.value?.id ?? -1) ?? 0;
      return compareDaily != 0 ? compareDaily : item1.order?.compareTo(item2.order ?? -1) ?? 0;
    });
    return list;
  }

  List<Item> getSortedCompletedSingles() {
    List<Item> list = completeSingles.toList();
    list.sort((item1, item2) => item1.order?.compareTo(item2.order ?? -1) ?? 0);
    return list;
  }

  List<Item> getSortedIncompleteDailies() {
    List<Item> list = incompleteDailies.toList();
    list.sort((item1, item2) {
      int compareDaily = item1.daily.value?.id.compareTo(item2.daily.value?.id ?? -1) ?? 0;
      return compareDaily != 0 ? compareDaily : item1.order?.compareTo(item2.order ?? -1) ?? 0;
    });
    return list;
  }

  List<Item> getSortedIncompleteSingles() {
    List<Item> list = incompleteSingles.toList();
    list.sort((item1, item2) => item1.order?.compareTo(item2.order ?? -1) ?? 0);
    return list;
  }
}