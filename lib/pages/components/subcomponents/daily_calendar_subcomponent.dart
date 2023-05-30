import 'package:flutter/material.dart';
import 'package:nichinichi/data_manager.dart';
import 'package:nichinichi/widgets/calendar.dart';
import 'package:nichinichi/models/models.dart';

class DailyCalendarSubcomponent extends StatefulWidget {

  final List<Daily> dailies;
  final void Function(Daily?) openEdit;

  const DailyCalendarSubcomponent({ super.key, required this.dailies, required this.openEdit });

  @override
  State<DailyCalendarSubcomponent> createState() => _DailyCalendarSubcomponentState();
}

class _DailyCalendarSubcomponentState extends State<DailyCalendarSubcomponent> {

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
  void initState() {
    _currentDaily = widget.dailies.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("DAILY CALENDAR", style: Theme.of(context).textTheme.headlineMedium),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {  widget.openEdit(null); },
                      icon: const Icon(Icons.add, color: Colors.white, size: 16)
                    ),
                    IconButton(
                      onPressed: () {  widget.openEdit(_currentDaily); },
                      icon: const Icon(Icons.edit, color: Colors.white, size: 16)
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              DropdownButton<Daily>(
                value: _currentDaily,
                items: widget.dailies.map((e) => DropdownMenuItem<Daily>(value: e, child: Text(e.title))).toList(),
                onChanged: (Daily? daily) { setState(() { _currentDaily = daily; }); },
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
                  if (month != null) { setState(() { _currentMonth = month; }); }
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
                  if (year != null) { setState(() { _currentYear = year; }); }
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
                    return CalendarView(date: DateTime(_currentYear, _currentMonth), completionData: snapshot.data!, daily: _currentDaily!,);
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
  }
}
