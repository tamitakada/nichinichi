import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_manager.dart';
import '../../widgets/item_view.dart';
import 'base_component.dart';
import 'subcomponents/edit_todo_subcomponent.dart';
import 'subcomponents/todo_subcomponent.dart';

class TodoComponent extends StatefulWidget {

  const TodoComponent({Key? key}) : super(key: key);

  @override
  State<TodoComponent> createState() => _TodoComponentState();
}

class _TodoComponentState extends State<TodoComponent> {

  late TodoList _list;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      child: FutureBuilder<TodoList?>(
        future: DataManager.getTodaysList(),
        builder: (BuildContext context, AsyncSnapshot<TodoList?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              _list = snapshot.data!;
              return _isEditing
                ? EditTodoSubcomponent(list: _list, close: () { setState(() { _isEditing = false; });})
                : TodoSubcomponent(list: _list, openEdit: () { setState(() { _isEditing = true; }); });
            } else {
              return Text("error!");
            }
          } else {
            return Text("loading...");
          }
        },
      )
    );
  }
}