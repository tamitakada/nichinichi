import 'package:nichinichi/models/models.dart';
import 'constants.dart';

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
      if (fractionComplete == 0) { return CompletionLevel.none; }
      else if (fractionComplete < 0.5) { return CompletionLevel.low; }
      else if (fractionComplete < 0.8) { return CompletionLevel.medium; }
      else if (fractionComplete < 1) { return CompletionLevel.high; }
      else { return CompletionLevel.perfect; }
    }
    return CompletionLevel.noData;
  }

}