import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_manager.dart';
import '../widgets/todo_widgets/edit_widgets.dart';
import 'package:nichinichi/pages/components/widgets/base_widgets/component_header_view.dart';

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

  @override
  void initState() {
    _dailyItems = widget.list.incompleteDailies.toList();
    _singleItems = widget.list.incompleteSingles.toList();
    super.initState();
  }

  Future<void> _saveData() async {
    print(await DataManager.setDailies(widget.list, _dailyItems));
    print(await DataManager.setSingles(widget.list, _singleItems));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _dailyItems.length + _singleItems.length + 3,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComponentHeaderView(
                title: "TODAY'S TODOS",
                actions: [
                  IconButton(
                    onPressed: () {
                      _singleItems.add(Item(description: ""));
                      _listKey.currentState!.insertItem(
                        _dailyItems.length + _singleItems.length + 1,
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 14,)
                  ),
                  IconButton(
                    onPressed: () { _saveData().then((_) => widget.close()); },
                    icon: const Icon(Icons.done_rounded, color: Colors.white, size: 14,)
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text("DAILY", style: Theme.of(context).textTheme.headlineSmall),
              ),
            ],
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
        } else if (index <  _dailyItems.length + _singleItems.length + 2) {
          return ItemEditView(
            item: _singleItems[index - _dailyItems.length - 2],
            animation: animation,
            onChanged: (String updated) {
              _singleItems[index - _dailyItems.length - 2].description = updated;
            },
            onDismissed: () {
              _singleItems.removeAt(index - _dailyItems.length - 2);
              _listKey.currentState!.removeItem(index, (context, animation) => Container());
            }
          );
        } else { return const SizedBox(height: 20); }
      }
    );
  }
}
