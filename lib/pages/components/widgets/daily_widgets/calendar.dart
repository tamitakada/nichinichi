import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/daily_stats_mixin.dart';

import 'package:nichinichi/models/models.dart';

import 'day_view.dart';


class CalendarView extends StatelessWidget with DailyStats {

  final DateTime date;
  final Daily daily;
  final Map<int, TodoList> completionData;
  final void Function(TodoList) onTap;

  const CalendarView({
    super.key, required this.date, required this.daily, required this.completionData, required this.onTap
  });

  List<Widget> buildWeek(BuildContext context, int firstWeekday, int firstDay, int lastWeekday) {
    DateTime now = DateTime.now();
    List<Widget> days = [];
    for (int i = 0; i < 7; i++) {
      if (i < firstWeekday || i > lastWeekday) {
        days.add(Expanded(child: Container()));
      } else {
        int day = firstDay - firstWeekday + i;
        CompletionLevel level;
        if (date.year == now.year && date.month == now.month && day == now.day) {
          level = CompletionLevel.noData;
        } else { level = getDailyCompletionLevel(completionData[day], daily); }
        days.add(
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (level != CompletionLevel.noData && completionData[day] != null) {
                  onTap(completionData[day]!);
                }
              },
              child: DayView(day: day, level: level)
            )
          )
        );
      }
    }
    return days;
  }

  List<Widget> buildWeeks(BuildContext context) {
    List<String> weekdayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    List<Widget> weekdayLabels = [];
    for (String name in weekdayNames) {
      weekdayLabels.add(
        Expanded(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Zen",
              fontSize: 10,
              letterSpacing: 2,
              color: Colors.white
            ),
          )
        )
      );
    }

    List<Widget> weeks = [
      Row(children: weekdayLabels),
      const SizedBox(height: 10)
    ];

    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int daysCounted = 1;

    while (daysCounted <= daysInMonth) {
      int firstWeekday = 0;
      int lastWeekday = 6;
      if (daysCounted == 1) {
        firstWeekday = DateTime(date.year, date.month).weekday;
        if (firstWeekday == 7) firstWeekday = 0; // Sunday -> 0th day
      } else if (daysInMonth - daysCounted < 7) { lastWeekday = daysInMonth - daysCounted; }
      weeks.add(Row(children: buildWeek(context, firstWeekday, daysCounted, lastWeekday)));
      daysCounted += 7 - firstWeekday;
    }
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: buildWeeks(context));
  }
}
