import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_manager.dart';
import 'widgets/todo_widgets/edit_widgets.dart';

class EditTodoSubcomponent extends StatefulWidget {

  final TodoList list;
  final void Function() close;

  const EditTodoSubcomponent({ super.key, required this.list, required this.close });

  @override
  State<EditTodoSubcomponent> createState() => _EditTodoSubcomponentState();
}

class _EditTodoSubcomponentState extends State<EditTodoSubcomponent> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Item> _dailyItems = [];
  List<Item> _singleItems = [];
  List<Item> _newSingleItems = [];

  @override
  void initState() {
    _dailyItems = widget.list.incompleteDailies.toList();
    _singleItems = widget.list.incompleteSingles.toList();
    super.initState();
  }

  Future<void> _saveData() async {
    try {
      widget.list.incompleteDailies.retainAll(_dailyItems);
      widget.list.incompleteSingles.retainAll(_singleItems);
      for (int i = 0; i < _newSingleItems.length; i++) {
        if (_newSingleItems[i].description?.isNotEmpty ?? false) {
          await DataManager.upsertItem(_newSingleItems[i]);
          widget.list.incompleteSingles.add(_newSingleItems[i]);
        }
      }
      if (!await DataManager.upsertList(widget.list)) {
       print("error saving data");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("TODAY'S TODOS", style: Theme.of(context).textTheme.headlineMedium),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _newSingleItems.add(Item(description: ""));
                    _listKey.currentState!.insertItem(
                      _dailyItems.length + _singleItems.length + _newSingleItems.length - 1,
                      duration: Duration(milliseconds: 300)
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 14,)
                ),
                IconButton(
                  onPressed: () { _saveData().then((_) => widget.close()); },
                  icon: const Icon(Icons.done_rounded, color: Colors.white, size: 14,)
                )
              ]
            )
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _dailyItems.length + _singleItems.length + _newSingleItems.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              if (index < _dailyItems.length) {
                return DailyEditView(
                  item: _dailyItems[index],
                  animation: animation,
                  onDismissed: () {
                    _dailyItems.removeAt(index);
                    _listKey.currentState!.removeItem(index, (context, animation) => Container());
                  }
                );
              } else {
                return SingleEditView(
                  item: (index - _dailyItems.length >= _singleItems.length)
                    ? _newSingleItems[index - _dailyItems.length - _singleItems.length]
                    : _singleItems[index - _dailyItems.length],
                  animation: animation,
                  onChanged: (String updated) {
                    if (index - _dailyItems.length >= _singleItems.length) {
                      _newSingleItems[index - _dailyItems.length - _singleItems.length].description = updated;
                    } else {
                      _singleItems[index - _dailyItems.length].description = updated;
                    }
                  },
                  onDismissed: () {
                    if (index - _dailyItems.length >= _singleItems.length) {
                      _newSingleItems.removeAt(index - _dailyItems.length - _singleItems.length);
                      _listKey.currentState!.removeItem(index, (context, animation) => Container());
                    } else {
                      _singleItems.removeAt(index - _dailyItems.length);
                      _listKey.currentState!.removeItem(index, (context, animation) => Container());
                    }
                  }
                );
              }
            }
          ),
        ),
      ],
    );
  }
}
