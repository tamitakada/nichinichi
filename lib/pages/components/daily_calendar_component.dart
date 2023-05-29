import 'package:flutter/material.dart';
import 'package:nichinichi/data_manager.dart';
import '../../widgets/calendar.dart';
import 'package:nichinichi/models/models.dart';
import 'base_component.dart';

class DailyCalendarComponent extends StatefulWidget {

  const DailyCalendarComponent({Key? key}) : super(key: key);

  @override
  State<DailyCalendarComponent> createState() => _DailyCalendarComponentState();
}

class _DailyCalendarComponentState extends State<DailyCalendarComponent> {

  Daily? _currentDaily;
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;
  final _allMonths = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  List<DropdownMenuItem<int>> buildMonthItems() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 0; i < _allMonths.length; i++) {
      items.add(
        DropdownMenuItem(
          value: i + 1,
          child: Text(_allMonths[i]),
        )
      );
    }
    return items;
  }

  List<DropdownMenuItem<int>> buildYearItems() {
    List<DropdownMenuItem<int>> items = [];
    int currentYear = DateTime.now().year;
    for (int i = 2023; i <= currentYear; i++) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text("$i"),
        )
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      child: FutureBuilder<List<Daily>?>(
        future: DataManager.getAllDailies(),
        builder: (BuildContext context, AsyncSnapshot<List<Daily>?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List<Daily> dailies = snapshot.data!;
              _currentDaily ??= dailies.first;
              return Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: ListView(
                  children: [
                    Text("DAILY CALENDAR", style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        DropdownButton<Daily>(
                          value: _currentDaily,
                          items: dailies.map((e) => DropdownMenuItem<Daily>(value: e, child: Text(e.title))).toList(),
                          onChanged: (Daily? daily) {
                            setState(() {
                              _currentDaily = daily;
                            });
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          dropdownColor: Colors.white30,
                          elevation: 0,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          iconSize: 20,
                          iconEnabledColor: Colors.white,
                          underline: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white
                            ),
                          ),
                        ),
                        DropdownButton<int>(
                          value: _currentMonth,
                          items: buildMonthItems(),
                          onChanged: (int? month) {
                            if (month != null) {
                              setState(() { _currentMonth = month; });
                            }
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          dropdownColor: Colors.white30,
                          elevation: 0,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          iconSize: 20,
                          iconEnabledColor: Colors.white,
                          underline: Container(
                            height: 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white
                            ),
                          ),
                        ),
                        DropdownButton<int>(
                          value: _currentYear,
                          items: buildYearItems(),
                          onChanged: (int? year) {
                            if (year != null) {
                              setState(() { _currentYear = year; });
                            }
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          dropdownColor: Colors.white30,
                          elevation: 0,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          iconSize: 20,
                          iconEnabledColor: Colors.white,
                          underline: Container(
                            height: 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                    (_currentDaily != null)
                        ? FutureBuilder<Map<int, TodoList>?>(
                        future: DataManager.getListsForDaily(_currentYear, _currentMonth, _currentDaily!),
                        builder: (BuildContext context, AsyncSnapshot<Map<int, TodoList>?> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              return CalendarView(date: DateTime.now(), completionData: snapshot.data!, daily: _currentDaily!,);
                            } else {
                              return Text("error!!!");
                            }
                          } else {
                            return Text("loading...");
                          }
                        }
                    )
                        : Container(),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              return Text("ERROR Loading data");
            }
          } else {
            return Text("loading...");
          }
        },
      )
    );
  }
}
