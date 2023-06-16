import 'package:nichinichi/models/models.dart';
import '../constants.dart';
import 'extensions.dart';


mixin DailyStats {

  List<Item> getSortedCompleteDailyItems(TodoList list, Daily daily) {
    List<Item> items = list.getSortedCompletedDailies();
    List<Item> relevantItems = [];
    for (Item item in items) {
      if (item.daily.value == daily || item.archivedDaily.value == daily) relevantItems.add(item);
    }
    return relevantItems;
  }

  List<Item> getSortedIncompleteDailyItems(TodoList list, Daily daily) {
    List<Item> items = list.getSortedIncompleteDailies();
    List<Item> relevantItems = [];
    for (Item item in items) {
      if (item.daily.value == daily || item.archivedDaily.value == daily) relevantItems.add(item);
    }
    return relevantItems;
  }

  CompletionLevel getDailyCompletionLevel(TodoList? list, Daily daily) {
    if (list != null) {
      int incomplete = 0;
      for (int i = 0; i < list.incompleteDailies.length; i++) {
        if (list.incompleteDailies.elementAt(i).daily.value == daily
            || list.incompleteDailies.elementAt(i).archivedDaily.value == daily) {
          incomplete++;
        }
      }
      int complete = 0;
      for (int i = 0; i < list.completeDailies.length; i++) {
        if (list.completeDailies.elementAt(i).daily.value == daily
            || list.completeDailies.elementAt(i).archivedDaily.value == daily) {
          complete++;
        }
      }
      if (incomplete == 0 && complete == 0) return CompletionLevel.noData;
      double fractionComplete = complete / (incomplete + complete);
      for (CompletionLevel level in CompletionLevel.values.reversed) {
        double levelBar = Constants.levelToInt(level) / 100;
        if (level == CompletionLevel.noData) { continue; }
        else if (level == CompletionLevel.none || level == CompletionLevel.perfect) {
          if (fractionComplete == levelBar) return level;
        } else if (fractionComplete > levelBar) { return level; }
      }
    }
    return CompletionLevel.noData;
  }
}