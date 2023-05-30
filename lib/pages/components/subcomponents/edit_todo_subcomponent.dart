import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_manager.dart';
import '../widgets/todo_widgets/edit_widgets.dart';

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
      int upsertCount = 0;
      for (int i = 0; i < _newSingleItems.length; i++) {
        if (_newSingleItems[i].description?.isNotEmpty ?? false) {
          Item upsertItem = Item(
            description: _newSingleItems[i].description,
            order: upsertCount + widget.list.incompleteSingles.length
          );
          await DataManager.upsertItem(upsertItem);
          widget.list.incompleteSingles.add(upsertItem);
          upsertCount++;
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
                      _dailyItems.length + _singleItems.length + _newSingleItems.length + 1,
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
            initialItemCount: _dailyItems.length + _singleItems.length + _newSingleItems.length + 2,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("DAILY", style: Theme.of(context).textTheme.headlineSmall),
                );
              } else if (index <= _dailyItems.length) {
                return DailyEditView(
                  item: _dailyItems[index - 1],
                  animation: animation,
                  onDismissed: () {
                    _dailyItems.removeAt(index - 1);
                    _listKey.currentState!.removeItem(index, (context, animation) => Container());
                  }
                );
              } else if (index == _dailyItems.length + 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("FOR TODAY", style: Theme.of(context).textTheme.headlineSmall,),
                );
              } else {
                return ItemEditView(
                  item: (index - _dailyItems.length - 2 >= _singleItems.length)
                    ? _newSingleItems[index - _dailyItems.length - _singleItems.length - 2]
                    : _singleItems[index - _dailyItems.length - 2],
                  animation: animation,
                  onChanged: (String updated) {
                    if (index - _dailyItems.length - 2 >= _singleItems.length) {
                      _newSingleItems[index - _dailyItems.length - _singleItems.length - 2].description = updated;
                    } else {
                      _singleItems[index - _dailyItems.length - 2].description = updated;
                    }
                  },
                  onDismissed: () {
                    if (index - _dailyItems.length - 2 >= _singleItems.length) {
                      _newSingleItems.removeAt(index - _dailyItems.length - _singleItems.length - 2);
                      _listKey.currentState!.removeItem(index, (context, animation) => Container());
                    } else {
                      _singleItems.removeAt(index - _dailyItems.length - 2);
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
