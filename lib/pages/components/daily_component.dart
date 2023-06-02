import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/abstract_classes/error_management.dart';

import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/models/models.dart';

import 'base_component.dart';
import 'subcomponents/daily_subcomponents/daily_subcomponents.dart';

import 'package:nichinichi/global_widgets/logo_spinner.dart';


class DailyComponent extends StatefulWidget {

  final void Function() updateTodoList;
  final OverlayManager manager;

  const DailyComponent({ super.key, required this.updateTodoList, required this.manager });

  @override
  State<DailyComponent> createState() => _DailyComponentState();
}

class _DailyComponentState extends State<DailyComponent> with ErrorMixin {

  Daily? _currentDaily;

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      initialRoute: 'daily/calendar',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'daily/calendar':
            builder = (BuildContext context) =>
              FutureBuilder<List<Daily>?>(
                future: DataManager.getAllDailies(),
                builder: (BuildContext context, AsyncSnapshot<List<Daily>?> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      List<Daily> dailies = snapshot.data!;
                      return DailyCalendarSubcomponent(
                        dailies: dailies,
                        manager: widget.manager,
                        openEdit: (daily) {
                          setState(() { _currentDaily = daily; });
                          Navigator.of(context).pushNamed('daily/edit');
                        }
                      );
                    } else {
                      showError(widget.manager, ErrorType.fetch);
                      return Container();
                    }
                  } else { return const Center(child: LogoSpinner()); }
                },
              );
            break;
          case 'daily/edit':
            builder = (BuildContext context) => EditDailySubcomponent(
              daily: _currentDaily, manager: widget.manager, close: () { widget.updateTodoList(); Navigator.of(context).pop(); }
            );
            break;
          case 'daily/theme':
            builder = (BuildContext context) => ThemeSubcomponent(manager: widget.manager);
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}
