import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';

import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/utils/error_management.dart';
import 'package:nichinichi/utils/confirmation_mixin.dart';

import 'package:nichinichi/global_widgets/dropdown_selector.dart';
import 'package:nichinichi/global_widgets/logo_spinner.dart';
import 'package:nichinichi/pages/components/widgets/daily_widgets/calendar.dart';
import 'package:nichinichi/pages/components/widgets/base_widgets/component_header_view.dart';


class DailyCalendarSubcomponent extends StatefulWidget {

  final List<Daily> dailies;
  final void Function(Daily?) openEdit;
  final OverlayManager manager;

  const DailyCalendarSubcomponent({
    super.key, required this.dailies, required this.manager, required this.openEdit
  });

  @override
  State<DailyCalendarSubcomponent> createState() => _DailyCalendarSubcomponentState();
}

class _DailyCalendarSubcomponentState extends State<DailyCalendarSubcomponent> with ErrorMixin, ConfirmationMixin {

  Daily? _currentDaily;
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

  List<int> _getMonths() {
    List<int> months = [];
    for (int i = 0; i < Constants.monthNames.length; i++) { months.add(i + 1); }
    return months;
  }

  List<int> _getYears() {
    List<int> years = [];
    int currentYear = DateTime.now().year;
    for (int i = 2023; i <= currentYear; i++) { years.add(i); }
    return years;
  }
  
  void _goToRecord(DateTime date, TodoList? list) {
    if (_currentDaily != null) {
      if (list != null) {
        Navigator.of(context).pushNamed(
          'daily/record',
          arguments: {'daily': _currentDaily, 'list': list}
        ).then((_) => setState(() {}));
      } else {
        showConfirmation(
          "No data exists for this day. Create new record?",
          widget.manager,
          () {
            DataManager.insertList(date).then(
              (newList) {
                if (newList != null) {
                  Navigator.of(context).pushNamed(
                    'daily/record',
                    arguments: {'daily': _currentDaily, 'list': newList}
                  ).then((_) => setState(() {}));
                } else { showError(widget.manager, ErrorType.save); }
              }
            );
          }
        );
      }
    }
  }

  @override
  void initState() {
    _currentDaily = widget.dailies.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ComponentHeaderView(
          title: "DAILY CALENDAR",
          actions: [
            IconButton(
              onPressed: () => widget.openEdit(null),
              icon: const Icon(Icons.add, color: Colors.white, size: 16)
            ),
            IconButton(
              onPressed: () => widget.openEdit(_currentDaily),
              icon: const Icon(Icons.edit, color: Colors.white, size: 16)
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed("daily/theme"),
              icon: const Icon(Icons.format_paint, color: Colors.white, size: 16)
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: Row(
            children: [
              Container(
                width: 200,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: DropdownSelector<Daily>(
                  manager: widget.manager,
                  options: widget.dailies,
                  optionNames: widget.dailies.map((e) => e.title).toList(),
                  initialSelection: _currentDaily,
                  onChanged: (Daily? daily) => setState(() { _currentDaily = daily; })
                ),
              ),
              Container(
                width: 80,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: DropdownSelector<int>(
                  manager: widget.manager,
                  options: _getMonths(),
                  optionNames: Constants.monthNames,
                  initialSelection: _currentMonth,
                  onChanged: (int? month) => setState(() { _currentMonth = month ?? 0; })
                ),
              ),
              SizedBox(
                width: 80,
                child: DropdownSelector<int>(
                  manager: widget.manager,
                  options: _getYears(),
                  optionNames: _getYears().map((e) => e.toString()).toList(),
                  initialSelection: _currentYear,
                  onChanged: (int? year) => setState(() { _currentYear = year ?? DateTime.now().year; })
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 20),
          child: (_currentDaily != null)
            ? FutureBuilder<Map<int, TodoList>?>(
              future: DataManager.getListsForDaily(_currentYear, _currentMonth, _currentDaily!),
              builder: (BuildContext context, AsyncSnapshot<Map<int, TodoList>?> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return CalendarView(
                      date: DateTime(_currentYear, _currentMonth),
                      completionData: snapshot.data!,
                      daily: _currentDaily!,
                      onTap: _goToRecord,
                    );
                  } else {
                    showError(widget.manager, ErrorType.fetch);
                    return Container();
                  }
                } else { return const Center(child: LogoSpinner()); }
              }
            ) : Container(),
        ),
      ],
    );
  }
}
