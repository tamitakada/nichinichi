import 'package:flutter/material.dart';
import 'package:nichinichi/data_manager.dart';
import 'package:nichinichi/models/models.dart';
import 'base_component.dart';
import 'subcomponents/daily_calendar_subcomponent.dart';
import 'subcomponents/edit_daily_subcomponent.dart';

class DailyComponent extends StatefulWidget {

  final void Function() updateTodoList;

  const DailyComponent({ super.key, required this.updateTodoList });

  @override
  State<DailyComponent> createState() => _DailyComponentState();
}

class _DailyComponentState extends State<DailyComponent> {

  int _dailyPage = 0;
  Daily? _currentDaily;

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      child: FutureBuilder<List<Daily>?>(
        future: DataManager.getAllDailies(),
        builder: (BuildContext context, AsyncSnapshot<List<Daily>?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List<Daily> dailies = snapshot.data!;
              return _dailyPage == 0
                ? DailyCalendarSubcomponent(dailies: dailies, openEdit: (daily) { setState(() { _currentDaily = daily; _dailyPage = 1; });},)
                : EditDailySubcomponent(daily: _currentDaily, close: () { widget.updateTodoList(); setState(() { _dailyPage = 0; });},);
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