import 'package:nichinichi/models/models.dart';
import '../constants.dart';


mixin DailyStats {
  CompletionLevel getDailyCompletionLevel(TodoList? list, Daily daily) {
    if (list != null) {
      int incomplete = 0;
      for (int i = 0; i < list.incompleteDailies.length; i++) {
        if (list.incompleteDailies.elementAt(i).daily.value?.id == daily.id) { incomplete++; }
      }
      int complete = 0;
      for (int i = 0; i < list.completeDailies.length; i++) {
        if (list.completeDailies.elementAt(i).daily.value?.id == daily.id) { complete++; }
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