import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/error_management.dart';

import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'widgets/base_widgets/component_header_view.dart';
import 'widgets/todo_widgets/todo_widgets.dart';

import 'base_component.dart';


class TodoComponent extends StatefulWidget {

  final TodoList list;
  final OverlayManager manager;
  final void Function() updateList;

  const TodoComponent({
    super.key,
    required this.list,
    required this.manager,
    required this.updateList
  });

  @override
  State<TodoComponent> createState() => _TodoComponentState();
}

class _TodoComponentState extends State<TodoComponent> with ErrorMixin {

  List<Item> _dailyItems = [];
  List<Item> _singleItems = [];

  List<Item> _completeDailyItems = [];
  List<Item> _completeSingleItems = [];

  int? _toAnimate;

  @override
  void initState() {
    _setSortedItems();
    super.initState();
  }

  void _setSortedItems() {
    _dailyItems = widget.list.getSortedIncompleteDailies();
    _singleItems = widget.list.getSortedIncompleteSingles();
    _completeDailyItems = widget.list.getSortedCompletedDailies();
    _completeSingleItems = widget.list.getSortedCompletedSingles();
  }

  void _updateSingles([int? toAnimate]) {
    // DataManager.setSingles(widget.list, _singleItems).then(
    //         (success) {
    //       if (success) {
    //         setState(() {
    //           _toAnimate = toAnimate;
    //           _singleItems = widget.list.getSortedIncompleteSingles();
    //         });
    //       }
    //       else { showError(widget.manager, ErrorType.save); }
    //     }
    // );
  }

  /* INSERTING ============================================================== */

  void _addSingle() {
    _singleItems.add(Item(description: "")); // Add empty item
    // Update database
    DataManager.setSingles(widget.list, _singleItems).then(
      (success) {
        if (success) {
          setState(() { // Trigger animation for added item
            _toAnimate = _singleItems.length - 1;
            _singleItems = widget.list.getSortedIncompleteSingles();
          });
        }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  /* ITEM DESCRIPTION UPDATE ================================================ */

  void _updateSingleDescription(Item item, String description) {
    item.description = description; // Change description
    DataManager.upsertItems([item]).then( // Update item in database
      (success) {
        if (success) { // DON'T setState; no reload needed
          widget.list.incompleteSingles.load().then(
            (_) => _singleItems = widget.list.getSortedIncompleteSingles()
          );
        }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  /* REORDERING ============================================================= */

  void _reorderDaily(int oldIndex, int newIndex) {
    // Reorder the daily items
    Item item = _dailyItems[oldIndex];
    _dailyItems.removeAt(oldIndex);
    _dailyItems.insert(newIndex - (oldIndex < newIndex ? 1 : 0), item);

    // Update database with newly ordered dailies
    DataManager.setDailies(widget.list, _dailyItems).then(
      (success) {
        if (success) {
          setState(() { _dailyItems = widget.list.getSortedIncompleteDailies(); });
        }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  void _reorderSingle(int oldIndex, int newIndex) {
    // Reorder the single items
    Item item = _singleItems[oldIndex];
    _singleItems.removeAt(oldIndex);
    _singleItems.insert(newIndex - (oldIndex < newIndex ? 1 : 0), item);

    // Update database with newly ordered singles
    DataManager.setSingles(widget.list, _singleItems).then(
      (success) {
        if (success) {
          setState(() {
            _toAnimate = null;
            _singleItems = widget.list.getSortedIncompleteSingles();
          });
        }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  /* COMPLETION STATUS UPDATES ============================================== */

  void _changeSingleCompletion(Item item, bool toComplete) {
    DataManager.changeSingleCompletion(widget.list, item, toComplete).then(
      (success) {
        if (success) {
          setState(() { // Update single items
            _singleItems = widget.list.getSortedIncompleteSingles();
            _completeSingleItems = widget.list.getSortedCompletedSingles();
          });
        }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  void _changeDailyCompletion(Item item, bool toComplete) {
    DataManager.changeDailyCompletion(widget.list, item, toComplete).then(
      (success) {
        if (success) {
          setState(() { // Update daily items
            _dailyItems = widget.list.getSortedIncompleteDailies();
            _completeDailyItems = widget.list.getSortedCompletedDailies();
          });
        }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  /* REMOVING =============================================================== */

  void _removeDaily(Item item) {
    _dailyItems.remove(item); // Remove item from dailies
    // Update database entry for today's list
    DataManager.setDailies(widget.list, _dailyItems).then(
      (success) {
        if (success) {
          setState(() { _dailyItems = widget.list.getSortedIncompleteDailies(); });
        }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  void _removeSingle(Item item) {
    _singleItems.remove(item); // Remove item from singles
    // Delete item from database
    DataManager.deleteItem(item).then(
      (success) => {
        if (success) {
          widget.list.incompleteSingles.load().then(
            (_) => setState(() { _singleItems = widget.list.getSortedIncompleteSingles(); })
          )
        }
        else { showError(widget.manager, ErrorType.save) }
      }
    );
  }

  /* BUILD ================================================================== */

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      child: Container(
        color: Constants.bgColor,
        child: ListView(
          children: [
            ComponentHeaderView(
              title: "TO DO LIST",
              actions: [
                IconButton(
                  onPressed: _addSingle,
                  icon: const Icon(Icons.add, color: Colors.white, size: 16,)
                ),
              ],
            ),
            _dailyItems.isNotEmpty ? const TodoSubheading(title: "DAILY") : Container(),
            ReorderableListView.builder(
              buildDefaultDragHandles: false,
              physics: const NeverScrollableScrollPhysics(),
              proxyDecorator: (Widget child, _, __) => child,
              itemBuilder: (BuildContext context, int index) {
                return DailyEditView(
                  key: Key('$index'),
                  index: index,
                  item: _dailyItems[index],
                  animate: false,
                  onDismissed: () => _removeDaily(_dailyItems[index]),
                  onTap: () =>  _changeDailyCompletion(_dailyItems[index], true)
                );
              },
              itemCount: _dailyItems.length,
              shrinkWrap: true,
              onReorder: _reorderDaily
            ),
            const TodoSubheading(title: "FOR TODAY"),
            _singleItems.isEmpty ? const EmptyItemView() : Container(),
            ReorderableListView.builder(
              buildDefaultDragHandles: false,
              physics: const NeverScrollableScrollPhysics(),
              proxyDecorator: (child, _, __) => Material(color: Colors.transparent, child: child,),
              itemBuilder: (BuildContext context, int index) {
                return ItemView(
                  key: Key('$index'),
                  index: index,
                  item: _singleItems[index],
                  animate: index == _toAnimate,
                  onSubmitted: (updated) =>
                      _updateSingleDescription(_singleItems[index], updated),
                  onDismissed: () => _removeSingle(_singleItems[index]),
                  onTap: () => _changeSingleCompletion(_singleItems[index], true),
                );
              },
              itemCount: _singleItems.length,
              shrinkWrap: true,
              onReorder: _reorderSingle
            ),
            _completeDailyItems.isNotEmpty || _completeSingleItems.isNotEmpty
                ? const TodoSubheading(title: "COMPLETE") : Container(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _completeDailyItems.length + _completeSingleItems.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < _completeDailyItems.length) {
                  return CompleteItemView(
                    item:  _completeDailyItems[index],
                    onTap: () =>
                        _changeDailyCompletion(_completeDailyItems[index], false),
                  );
                } else {
                  return CompleteItemView(
                    item: _completeSingleItems[index - _completeDailyItems.length],
                    onTap: () =>
                        _changeSingleCompletion(
                            _completeSingleItems[index - _completeDailyItems.length],
                            false
                        ),
                  );
                }
              }
            ),
            const SizedBox(height: 20)
          ],
        )
      ),
    );
  }
}