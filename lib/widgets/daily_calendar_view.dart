import 'package:flutter/material.dart';
import 'package:nichinichi/data_manager.dart';
import 'calendar.dart';
import 'package:nichinichi/models/models.dart';

class DailyCalendarView extends StatefulWidget {

  const DailyCalendarView({Key? key}) : super(key: key);

  @override
  State<DailyCalendarView> createState() => _DailyCalendarViewState();
}

class _DailyCalendarViewState extends State<DailyCalendarView> {

  Daily? _currentDaily;
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 2),
          right: BorderSide(color: Colors.white, width: 2),
        )
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: FutureBuilder<List<Daily>?>(
        future: DataManager.getAllDailies(),
        builder: (BuildContext context, AsyncSnapshot<List<Daily>?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List<Daily> dailies = snapshot.data!;
              _currentDaily = dailies.first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("DAILY CALENDAR", style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 20),
                  // DropdownButton<Daily>(
                  //   value: dailies.first,
                  //   items: dailies.map((e) => DropdownMenuItem<Daily>(child: Text(e.title))).toList(),
                  //   onChanged: (Daily? daily) {}
                  // ),
                  (_currentDaily != null)
                    ? FutureBuilder<Map<int, TodoList>?>(
                      future: DataManager.getListsForDaily(_currentYear, _currentMonth, _currentDaily!),
                      builder: (BuildContext context, AsyncSnapshot<Map<int, TodoList>?> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            return Expanded(
                              child: CalendarView(date: DateTime.now(), completionData: snapshot.data!, daily: _currentDaily!,)
                            );
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
