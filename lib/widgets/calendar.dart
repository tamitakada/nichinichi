import 'package:flutter/material.dart';
import 'day_view.dart';
import 'package:nichinichi/models/models.dart';

class CalendarView extends StatelessWidget {

  final DateTime date;
  final Map<int, TodoList> completionData;

  const CalendarView({ super.key, required this.date, required this.completionData });

  List<Widget> buildWeek(int firstWeekday, int firstDay, int numDays) {
    List<Widget> days = [];
    for (int i = 0; i < 7; i++) {
      if (i < firstWeekday || i > numDays) {
        days.add(Expanded(child: Container()));
      } else {
        days.add(Expanded(child: DayView(day: firstDay - firstWeekday + i, completionLevel: 0)));
      }
    }
    return days;
  }

  List<Widget> buildWeeks() {
    List<Widget> weeks = [];

    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int daysCounted = 1;

    while (daysCounted < daysInMonth) {
      int firstWeekday = 0;
      int daysInWeek = 7;
      if (daysCounted == 1) {
        firstWeekday = DateTime(date.year, date.month).weekday;
        if (firstWeekday == 7) firstWeekday = 0; // Sunday -> 0th day
        daysInWeek = 7 - firstWeekday;
      } else if (daysInMonth - daysCounted < 7) { daysInWeek = daysInMonth - daysCounted; }
      weeks.add(Expanded(child: Row(children: buildWeek(firstWeekday, daysCounted, daysInWeek))));
      daysCounted += daysInWeek;
    }
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildWeeks(),
    );
  }
}
