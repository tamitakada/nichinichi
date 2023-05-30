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

  static Future<Item?> getItem(Id id) async { return (await isar).items.get(id); }

  static Future<TodoList?> getTodaysList() async {
    try {
      DateTime now = DateTime.now();
      TodoList? list = await (await isar).todoLists.filter().dateEqualTo(DateTime(now.year, now.month, now.day)).findFirst();
      if (list != null) { return list; }
      else {
        List<Daily> dailies = await getActiveDailies() ?? [];
        TodoList toAdd = TodoList(date: DateTime(now.year, now.month, now.day));
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

  static Future<bool> upsertDaily(Daily daily, [List<Item>? itemsToAdd]) async {
    try {
      await (await isar).writeTxn(() async {
        daily.id = await (await isar).dailys.put(daily);
      });

      if (itemsToAdd != null) {
        daily.items.addAll(itemsToAdd);
        await (await isar).writeTxn(() async {
          await daily.items.save();
        });
      }

      DateTime now = DateTime.now();
      if (daily.startDate.isBefore(now) && (daily.endDate?.isAfter(now) ?? true)) {
        TodoList? list = await getTodaysList();
        if (list != null) {
          list.incompleteDailies.addAll(daily.items);
          return await upsertList(list);
        } else { return false; }
      }

      return true;
    } catch (e) {print(e); return false; }
  }

  static Future<bool> upsertItems(List<Item> items) async {
    for (int i = 0; i < items.length; i++) {
      try {
        await (await isar).writeTxn(() async {
          await (await isar).items.put(items.elementAt(i));
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