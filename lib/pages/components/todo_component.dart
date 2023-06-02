import 'package:flutter/material.dart';

import 'package:nichinichi/models/models.dart';

import 'base_component.dart';
import 'subcomponents/edit_todo_subcomponent.dart';
import 'subcomponents/todo_subcomponent.dart';


class TodoComponent extends StatelessWidget {

  final TodoList list;
  final void Function() updateList;

  const TodoComponent({ super.key, required this.list, required this.updateList });

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      initialRoute: 'todo/home',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'todo/home':
            builder = (BuildContext context) =>  TodoSubcomponent(list: list);
              break;
          case 'todo/edit':
            builder = (BuildContext context) => EditTodoSubcomponent(
              list: list, updateList: updateList
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