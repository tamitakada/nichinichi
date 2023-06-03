import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';

import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/utils/error_management.dart';

import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_management/data_manager.dart';

import '../../widgets/todo_widgets/edit_widgets.dart';
import 'package:nichinichi/pages/components/widgets/base_widgets/component_header_view.dart';


class EditTodoSubcomponent extends StatefulWidget with ErrorMixin {

  final TodoList list;
  final OverlayManager manager;
  final void Function() updateList;

  const EditTodoSubcomponent({ super.key, required this.list,required this.manager, required this.updateList });

  @override
  State<EditTodoSubcomponent> createState() => _EditTodoSubcomponentState();
}

class _EditTodoSubcomponentState extends State<EditTodoSubcomponent> with ErrorMixin {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Item> _dailyItems = [];
  List<Item> _singleItems = [];

  @override
  void initState() {
    _dailyItems = widget.list.getSortedIncompleteDailies();
    _singleItems = widget.list.getSortedIncompleteSingles();
    super.initState();
  }

  Future<void> _saveData() async {
    if (!await DataManager.setDailies(widget.list, _dailyItems) ||
        !await DataManager.setSingles(widget.list, _singleItems)) {
      showError(widget.manager, ErrorType.save);
    } else { widget.updateList(); }
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
                leadingAction: IconButton(
                  onPressed: () { Navigator.of(context).pop(); },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
                ),
                title: "EDIT TODOS",
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
                    onPressed: () { _saveData().then((_) => Navigator.of(context).pop()); },
                    icon: const Icon(Icons.done_rounded, color: Colors.white, size: 14,)
                  )
                ],
              ),
              _dailyItems.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("DAILY", style: Theme.of(context).textTheme.headlineSmall),
                ) : Container()
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
