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

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
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
