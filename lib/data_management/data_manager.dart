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
        .group(
          (q) => q
            .completeDailies((q) => q.daily((q) => q.idEqualTo(daily.id)))
            .or()
            .incompleteDailies((q) => q.daily((q) => q.idEqualTo(daily.id)))
        )
        .dateBetween(DateTime(year, month), DateTime(year, month, DateTime(year, month + 1, 0).day))
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
        if (!daily.items.contains(items[counter])) {
          toAdd.add(items[counter]);
          if (list != null && !daily.archived) {
            list.incompleteDailies.add(items[counter]);
          }
        }
        counter++;
      } else { items.removeAt(counter); }
    }

    List<Item> toDelete = [];
    for (int i = 0; i < daily.items.length; i++) {
      Item item = daily.items.elementAt(i);
      if (!items.contains(item)) {
        List<TodoList>? lists = await getListsWithDailyItem(item);
        if (lists == null || lists.isEmpty || (lists.length == 1 && lists[0] == list)) {
          toDelete.add(item);
        }
        list?.incompleteDailies.remove(item);
        list?.completeDailies.remove(item);
      }
    }
    daily.items.removeAll(toDelete);

    if (await upsertItems(items) && await deleteItems(toDelete)) {
      try {
        daily.items.addAll(toAdd);
        (await isar).writeTxn(() async {
          await daily.items.save();
          await list?.completeDailies.save();
          await list?.incompleteDailies.save();
        });
        return true;
      } catch (e) { print(e); return false; }
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
      if (!list.incompleteSingles.contains(items[counter])) {
        toAdd.add(items[counter]);
      }
      counter++;
    }
    List<Item> toDelete = [];
    for (int i = list.incompleteSingles.length - 1; i >= 0; i--) {
      Item item = list.incompleteSingles.elementAt(i);
      if (!items.contains(item)) {
        toDelete.add(item);
        list.incompleteSingles.remove(item);
      }
    }
    if (await upsertItems(items) && await deleteItems(toDelete)) {
      try {
        list.incompleteSingles.addAll(toAdd);
        (await isar).writeTxn(() async {
          await list.incompleteSingles.save();
        });
        return true;
      } catch (e) { print(e); return false; }
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
    } catch (e) { return false; }
    return true;
  }

  static Future<bool> upsertDaily(Daily daily) async {
    try {
      (await isar).writeTxn(() async {
        (await isar).dailys.put(daily);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> upsertList(TodoList list) async {
    try {
      (await isar).writeTxn(() async {
        (await isar).todoLists.put(list);
        await list.incompleteDailies.save();
        await list.incompleteSingles.save();
        await list.completeDailies.save();
        await list.completeSingles.save();
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<TodoList?> insertList(DateTime date) async {
    List<Daily> dailies = await getActiveDailies() ?? [];
    TodoList toAdd = TodoList(date: date);

    try {
      (await isar).writeTxn(() async {
        toAdd.id = await (await isar).todoLists.put(toAdd);
      });
    } catch (e) { return null; }

    for (Daily daily in dailies) {
      for (Item item in daily.items) { toAdd.incompleteDailies.add(item); }
    }
    if (await upsertList(toAdd)) return toAdd;
    return null;
  }

  /* DELETES ================================================================ */

  static Future<bool> deleteItems(List<Item> item) async {
    try {
      (await isar).writeTxn(() async {
        (await isar).items.deleteAll(item.map((e) => e.id).toList());
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> deleteItem(Item item) async {
    try {
      (await isar).writeTxn(() async {
        (await isar).items.delete(item.id);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> deleteDaily(Daily daily) async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      TodoList? list = await getTodaysList();
      for (int i = daily.items.length - 1; i >= 0; i--) {
        Item item = daily.items.elementAt(i);
        List<TodoList> lists = await getListsWithDailyItem(daily.items.elementAt(i)) ?? [];
        if (lists.isEmpty || (lists.length == 1 && lists[0].date.isAtSameMomentAs(today))) {
          await deleteItem(item);
        }
        list?.incompleteDailies.remove(item);
        list?.completeDailies.remove(item);
      }
      (await isar).writeTxn(() async {
        (await isar).dailys.delete(daily.id);
        list?.incompleteDailies.save();
        list?.completeDailies.save();
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> deleteList(TodoList list) async {
    try {
      (await isar).writeTxn(() async {
        (await isar).todoLists.delete(list.id);
      });
      return true;
    } catch (e) { return false; }
  }

  /* ARCHIVING ============================================================== */

  static Future<bool> archiveDaily(Daily daily) async {
    try {
      daily.archived = true;
      TodoList? list = await getTodaysList();
      for (int i = daily.items.length - 1; i >= 0; i--) {
        list?.incompleteDailies.remove(daily.items.elementAt(i));
        list?.completeDailies.remove(daily.items.elementAt(i));
      }
      (await isar).writeTxn(() async {
        await list?.incompleteDailies.save();
        await list?.completeDailies.save();
        (await isar).dailys.put(daily);
      });
      return true;
    } catch (e) { return false; }
  }

  static Future<bool> unarchiveDaily(Daily daily) async {
    try {
      daily.archived = false;
      TodoList? list = await getTodaysList();
      for (int i = daily.items.length - 1; i >= 0; i--) {
        list?.incompleteDailies.add(daily.items.elementAt(i));
      }
      (await isar).writeTxn(() async {
        await list?.incompleteDailies.save();
        (await isar).dailys.put(daily);
      });
      return true;
    } catch (e) { return false; }
  }
}