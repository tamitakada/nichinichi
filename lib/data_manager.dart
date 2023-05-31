import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nichinichi/models/models.dart';
import 'utils/extensions.dart';

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

  static Future<Item?> getItem(Id id) async { return (await isar).items.get(id); }

  static Future<TodoList?> getTodaysList() async {
    try {
      DateTime now = DateTime.now();
      TodoList? list = await (await isar).todoLists.filter().dateEqualTo(DateTime(now.year, now.month, now.day)).findFirst();
      if (list != null) { return list; }
      else {
        List<Daily> dailies = await getActiveDailies() ?? [];
        TodoList toAdd = TodoList(date: DateTime(now.year, now.month, now.day));
        await upsertList(toAdd); // Put before adding items
        for (var daily in dailies) {
          for (var item in daily.items) { toAdd.incompleteDailies.add(item); }
        }
        await upsertList(toAdd);
        return toAdd;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Daily>?> getActiveDailies() async {
    try {
      DateTime now = DateTime.now();
      return await (await isar).dailys.filter()
        .startDateLessThan(now).or().startDateEqualTo(now)
        .endDateGreaterThan(now).or().endDateEqualTo(now)
        .findAll();
    } catch (e) { print(e); return null; }
  }

  static Future<List<Daily>?> getAllDailies() async {
    try { return await (await isar).dailys.where().findAll(); }
    catch (e) { return null; }
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

  static Future<bool> upsertDaily(Daily daily, bool addToToday, [List<Item>? itemsToAdd]) async {
    try {
      await (await isar).writeTxn(() async {
        daily.id = await (await isar).dailys.put(daily);
      });
      if (itemsToAdd != null) {
        for (int i = 0; i < itemsToAdd.length; i++) {
          daily.items.add(itemsToAdd[i]);
        }
        await (await isar).writeTxn(() async {
          await daily.items.save();
        });
      }
      if (addToToday) {
        DateTime now = DateTime.now();
        if (daily.startDate.isBefore(now) && (daily.endDate?.isAfter(now) ?? true)) {
          TodoList? list = await getTodaysList();
          if (list != null) {
            list.incompleteDailies.addAll(daily.items);
            return await upsertList(list);
          } else { return false; }
        }
      }
      return true;
    } catch (e) {print(e); return false; }
  }

  static Future<bool> upsertItems(List<Item> items) async {
    for (int i = 0; i < items.length; i++) {
      try {
        await (await isar).writeTxn(() async {
          await (await isar).items.put(items[i]);
        });
      } catch (e) { print(e); return false; }
    }
    return true;
  }

  static Future<bool> upsertItem(Item item) async {
    try {
      (await isar).writeTxn(() async {
        item.id = await (await isar).items.put(item);
      });
      return true;
    } catch (e) { print(e); return false; }
  }

  static Future<bool> setItemsInDaily(Daily daily, List<Item> toUpdate, List<Item> toAdd) async {
    TodoList? list = await getTodaysList();
    for (int i = daily.items.length - 1; i >= 0; i--) {
      Item item = daily.items.elementAt(i);
      if (!toUpdate.contains(item)) {
        daily.items.remove(item);
        list?.incompleteDailies.remove(item);
        list?.completeDailies.remove(item);
        List<TodoList> lists = await getListsWithDailyItem(item) ?? [];
        if (lists.isEmpty || (lists.length == 1 && lists[0].id == list?.id)) { await deleteItem(item); }
      } else { await upsertItem(item); }
    }
    return await upsertDaily(daily, true, toAdd) && (list != null ? await upsertList(list) : true);
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
    } catch (e) { print(e); return false; }
  }

  static Future<bool> deleteItem(Item item) async {
    try {
      (await isar).writeTxn(() async {
        (await isar).items.delete(item.id);
      });
      return true;
    } catch (e) { print(e); return false; }
  }

  static Future<bool> deleteDaily(Daily daily) async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      for (int i = daily.items.length - 1; i >= 0; i--) {
        List<TodoList> lists = await getListsWithDailyItem(daily.items.elementAt(i)) ?? [];
        if (lists.isEmpty || (lists.length == 1 && lists[0].date.isAtSameMomentAs(today))) {
          await deleteItem(daily.items.elementAt(i));
        }
      }
      (await isar).writeTxn(() async {
        (await isar).dailys.delete(daily.id);
      });
      return true;
    } catch (e) { print(e); return false; }
  }

  static Future<bool> deleteList(TodoList list) async {
    try {
      (await isar).writeTxn(() async {
        (await isar).todoLists.delete(list.id);
      });
      return true;
    } catch (e) { print(e); return false; }
  }

  static Future<bool> deleteItemFromList(Item item, TodoList list) async {
    try {
      if (item.daily.value != null) {
        list.incompleteDailies.remove(item);
        return await upsertList(list);
      } else {
        list.incompleteSingles.remove(item);
        (await isar).writeTxn(() async {
          (await isar).items.delete(item.id);
        });
        return true;
      }
    } catch (e) { print(e); return false; }
  }
}