import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:nichinichi/models/models.dart';


class DataManager {

  static Isar? _isar;

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<Isar> get isar async {
    _isar ??= await Isar.open([ItemSchema, DailySchema, TodoListSchema], directory: await _localPath);
    return _isar!;
  }

  /* GETTERS ================================================================ */

  static Future<TodoList?> getTodaysList() async {
    try {
      DateTime now = DateTime.now();
      TodoList? list = await (await isar).todoLists.filter()
        .dateEqualTo(DateTime(now.year, now.month, now.day))
        .findFirst();
      await list?.incompleteDailies.load();
      await list?.completeDailies.load();
      if (list != null) { return list; }
      else { return await insertList(DateTime(now.year, now.month, now.day)); }
    } catch (e) { return null; }
  }

  static Future<List<Daily>?> getActiveDailies() async {
    try {
      return await (await isar).dailys.filter()
        .archivedEqualTo(false)
        .findAll();
    } catch (e) { return null; }
  }

  static Future<List<Daily>?> getAllDailies() async {
    try { return await (await isar).dailys.where().findAll(); }
    catch (e) { return null; }
  }

  static Future<TodoList?> getList(DateTime date) async {
    try {
      TodoList? list = await (await isar).todoLists.filter()
        .dateEqualTo(date)
        .findFirst();
      return list;
    } catch (e) { return null; }
  }

  static Future<List<TodoList>?> getListsWithDailyItem(Item item) async {
    try {
      List<TodoList> lists = await (await isar).todoLists.filter()
        .completeDailies((q) => q.idEqualTo(item.id))
        .or()
        .incompleteDailies((q) => q.idEqualTo(item.id))
        .findAll();
      return lists;
    } catch (e) { return null; }
  }

  static Future<Map<int, TodoList>?> getListsForDaily(int year, int month, Daily daily) async {
    try {
      List<TodoList> lists = await (await isar).todoLists.filter()
        .dateBetween(DateTime(year, month), DateTime(year, month, DateTime(year, month + 1, 0).day))
        .group(
          (q) => q
            .completeDailies((q) => q.daily((q) => q.idEqualTo(daily.id)))
            .or()
            .completeDailies((q) => q.archivedDaily((q) => q.idEqualTo(daily.id)))
            .or()
            .incompleteDailies((q) => q.daily((q) => q.idEqualTo(daily.id)))
            .or()
            .incompleteDailies((q) => q.archivedDaily((q) => q.idEqualTo(daily.id)))
        )
        .findAll();
      Map<int, TodoList> listCalendar = {};
      for (var l in lists) { listCalendar[l.date.day] = l; }
      return listCalendar;
    } catch (e) { return null; }
  }

  /* SETTERS ================================================================ */

  static Future<bool> setDailyItems(Daily daily, List<Item> items) async {
    TodoList? list = await getTodaysList();

    int counter = 0;
    List<Item> toAdd = [];
    while (counter < items.length) {
      if (items[counter].description?.isNotEmpty ?? false) {
        items[counter].order = counter;
        if (!daily.items.contains(items[counter])) toAdd.add(items[counter]);
        counter++;
      } else { items.removeAt(counter); }
    }

    List<Item> toDelete = [];
    for (int i = daily.items.length - 1; i >= 0; i--) {
      Item item = daily.items.elementAt(i);
      if (!items.contains(item)) {
        List<TodoList>? lists = await getListsWithDailyItem(item);
        if (lists == null || lists.isEmpty || (lists.length == 1 && lists[0] == list)) {
          toDelete.add(item);
        } else { daily.archivedItems.add(item); }
        daily.items.remove(item);
        list?.incompleteDailies.remove(item);
        list?.completeDailies.remove(item);
      }
    }

    if (await upsertItems(items) && await deleteItems(toDelete)) {
      try {
        daily.items.addAll(toAdd);
        if (!daily.archived) list?.incompleteDailies.addAll(toAdd);
        await (await isar).writeTxn(() async {
          await daily.items.save();
          await daily.archivedItems.save();
          await list?.completeDailies.save();
          await list?.incompleteDailies.save();
        });
        return true;
      } catch (e) { return false; }
    }
    return false;
  }

  static Future<bool> setDailies(TodoList list, List<Item> items) async {
    int counter = 0;
    while (counter < list.incompleteDailies.length) {
      Item item = list.incompleteDailies.elementAt(counter);
      int index = items.indexOf(item);
      if (index == -1) { list.incompleteDailies.remove(item); }
      else {
        item.order = index;
        counter++;
      }
    }
    return await upsertItems(list.incompleteDailies.toList()) && await upsertList(list);
  }

  static Future<bool> setSingles(TodoList list, List<Item> items) async {
    int counter = 0;
    List<Item> toAdd = [];
    while (counter < items.length) {
      items[counter].order = counter;
      if (!list.incompleteSingles.contains(items[counter])) toAdd.add(items[counter]);
      counter++;
    }
    List<Item> toDelete = [];
    for (int i = list.incompleteSingles.length - 1; i >= 0; i--) {
      Item item = list.incompleteSingles.elementAt(i);
      if (!items.contains(item)) toDelete.add(item);
    }
    if (await upsertItems(items) && await deleteItems(toDelete)) {
      try {
        list.incompleteSingles.addAll(toAdd);
        await (await isar).writeTxn(() async {
          await list.incompleteSingles.save();
        });
        return true;
      } catch (e) { return false; }
    }
    return false;
  }

  /* COMPLETION UPDATES ===================================================== */

  static Future<bool> changeDailyCompletion(TodoList list, Item item, bool toComplete) async {
    if (toComplete) {
      list.completeDailies.add(item);
      list.incompleteDailies.remove(item);
    } else {
      list.incompleteDailies.add(item);
      list.completeDailies.remove(item);
    }
    return await upsertList(list);
  }

  static Future<bool> changeSingleCompletion(TodoList list, Item item, bool toComplete) async {
    if (toComplete) {
      list.completeSingles.add(item);
      list.incompleteSingles.remove(item);
    } else {
      list.incompleteSingles.add(item);
      list.completeSingles.remove(item);
    }
    return await upsertList(list);
  }

  /* UPSERTS ================================================================ */

  static Future<bool> upsertItems(List<Item> items) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).items.putAll(items);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> upsertDaily(Daily daily) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).dailys.put(daily);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> upsertList(TodoList list) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).todoLists.put(list);
        await list.incompleteDailies.save();
        await list.incompleteSingles.save();
        await list.completeDailies.save();
        await list.completeSingles.save();
      });
      return true;
    } catch (e) { return false; }
  }

  /*
  @precondition TodoList @ date.incompleteDailies does NOT contain daily
  @precondition TodoList @ date.completeDailies does NOT contain daily
  @postcondition TodoList @ date created with daily.items in TodoList.incompleteDailies
  */
  static Future<TodoList?> upsertPastListForDaily(DateTime date, Daily daily) async {
    TodoList? pastList = await getList(date);
    if (pastList != null) {
      try {
        pastList.incompleteDailies.addAll(daily.items);
        await (await isar).writeTxn(() async {
          await pastList.incompleteDailies.save();
        });
        return pastList;
      } catch (e) { return null; }
    } else { return await insertListForDaily(date, daily); }
  }

  static Future<TodoList?> insertList(DateTime date) async {
    List<Daily> dailies = await getActiveDailies() ?? [];
    TodoList toAdd = TodoList(date: date);
    try {
      await (await isar).writeTxn(() async {
        toAdd.id = await (await isar).todoLists.put(toAdd);
      });
      for (Daily daily in dailies) {
        for (Item item in daily.items) { toAdd.incompleteDailies.add(item); }
      }
      await (await isar).writeTxn(() async {
        await toAdd.incompleteDailies.save();
      });
      return toAdd;
    } catch (e) { return null; }
  }

  // Creates list for date but ONLY adds records for specified daily
  static Future<TodoList?> insertListForDaily(DateTime date, Daily daily) async {
    TodoList toAdd = TodoList(date: date);
    try {
      await (await isar).writeTxn(() async {
        toAdd.id = await (await isar).todoLists.put(toAdd);
      });
      for (Item item in daily.items) { toAdd.incompleteDailies.add(item); }
      await (await isar).writeTxn(() async {
        await toAdd.incompleteDailies.save();
      });
      return toAdd;
    } catch (e) { return null; }
  }

  /* DELETES ================================================================ */

  static Future<bool> deleteItems(List<Item> item) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).items.deleteAll(item.map((e) => e.id).toList());
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> deleteItem(Item item) async {
    try {
      await (await isar).writeTxn(() async {
        await (await isar).items.delete(item.id);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> deleteDaily(Daily daily) async {
    try {
      if (await deleteItems(daily.items.toList())) {
        TodoList? list = await getTodaysList();
        await (await isar).writeTxn(() async {
          await (await isar).dailys.delete(daily.id);
          await list?.incompleteDailies.load();
          await list?.completeDailies.load();
        });
        return true;
      } else { return false; }
    } catch (e) { return false; }
  }

  /* ARCHIVING ============================================================== */

  static Future<bool> archiveDaily(Daily daily) async {
    try {
      daily.archived = true;
      TodoList? list = await getTodaysList();
      list?.incompleteDailies.removeAll(daily.items);
      list?.completeDailies.removeAll(daily.items);
      await (await isar).writeTxn(() async {
        await (await isar).dailys.put(daily);
        await list?.incompleteDailies.save();
        await list?.completeDailies.save();
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> unarchiveDaily(Daily daily) async {
    try {
      daily.archived = false;
      TodoList? list = await getTodaysList();
      list?.incompleteDailies.addAll(daily.items);
      await (await isar).writeTxn(() async {
        await (await isar).dailys.put(daily);
        await list?.incompleteDailies.save();
      });
      return true;
    } catch (e) { return false; }
  }
}