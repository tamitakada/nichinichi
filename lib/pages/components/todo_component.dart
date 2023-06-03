import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/abstract_classes/overlay_manager.dart';

import 'package:nichinichi/models/models.dart';

import 'base_component.dart';
import 'subcomponents/todo_subcomponents/todo_subcomponents.dart';


class TodoComponent extends StatelessWidget {

  final TodoList list;
  final OverlayManager manager;
  final void Function() updateList;

  const TodoComponent({ super.key, required this.list, required this.manager, required this.updateList });

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      initialRoute: 'todo/home',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'todo/home':
            builder = (BuildContext context) =>  Container(
              color: Constants.bgColor,
              child: TodoSubcomponent(list: list, manager: manager)
            );
            break;
          case 'todo/edit':
            builder = (BuildContext context) => Container(
              color: Constants.bgColor,
              child: EditTodoSubcomponent(
                list: list, updateList: updateList, manager: manager
              ),
            );
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      }
    );
  }
}