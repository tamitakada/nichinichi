import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/utils/error_management.dart';

import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_management/data_manager.dart';

import '../../widgets/todo_widgets/static_widgets.dart';
import 'package:nichinichi/pages/components/widgets/base_widgets/component_header_view.dart';


class TodoSubcomponent extends StatefulWidget {

  final TodoList list;
  final OverlayManager manager;

  const TodoSubcomponent({ super.key, required this.list, required this.manager });

  @override
  State<TodoSubcomponent> createState() => _TodoSubcomponentState();
}

class _TodoSubcomponentState extends State<TodoSubcomponent> with ErrorMixin {

  late List<Item> _sortedCompleteDailies;
  late List<Item> _sortedIncompleteDailies;
  late List<Item> _sortedCompleteSingles;
  late List<Item> _sortedIncompleteSingles;

  void _setSortedLists() {
    _sortedCompleteDailies = widget.list.getSortedCompletedDailies();
    _sortedIncompleteDailies = widget.list.getSortedIncompleteDailies();
    _sortedCompleteSingles = widget.list.getSortedCompletedSingles();
    _sortedIncompleteSingles = widget.list.getSortedIncompleteSingles();
  }

  void _upsertList() {
    DataManager.upsertList(widget.list).then(
      (success) {
        if (success) { setState(() {}); }
        else { showError(widget.manager, ErrorType.save); }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _setSortedLists();
    return ListView.builder(
      itemCount: _sortedCompleteDailies.length + _sortedIncompleteDailies.length + _sortedCompleteSingles.length + _sortedIncompleteSingles.length + 4,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComponentHeaderView(
                title: "TODAY'S TODOS",
                actions: [
                  IconButton(
                    onPressed: () {Navigator.of(context).pushNamed('todo/edit'); },
                    icon: const Icon(Icons.edit, color: Colors.white, size: 14)
                  )
                ],
              ),
              _sortedIncompleteDailies.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("DAILY", style: Theme.of(context).textTheme.headlineSmall,),
                ) : Container()
            ],
          );
        } else if (index <= _sortedIncompleteDailies.length) {
          return IncompleteItemView(
            item: _sortedIncompleteDailies[index - 1],
            onTap: () {
              Item toComplete = _sortedIncompleteDailies[index - 1];
              widget.list.completeDailies.add(toComplete);
              widget.list.incompleteDailies.remove(toComplete);
              _upsertList();
            }
          );
        } else if (index == _sortedIncompleteDailies.length + 1) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("FOR TODAY", style: Theme.of(context).textTheme.headlineSmall),
                _sortedIncompleteSingles.isEmpty ? const EmptyItemView() : Container()
              ],
            )
          );
        } else if (index < _sortedIncompleteDailies.length + _sortedIncompleteSingles.length + 2) {
          return IncompleteItemView(
            item: _sortedIncompleteSingles[index - widget.list.incompleteDailies.length - 2],
            onTap: () {
              Item toComplete = _sortedIncompleteSingles[index - widget.list.incompleteDailies.length - 2];
              widget.list.completeSingles.add(toComplete);
              widget.list.incompleteSingles.remove(toComplete);
              _upsertList();
            },
          );
        } else if (index == _sortedIncompleteDailies.length + _sortedIncompleteSingles.length + 2) {
          return _sortedCompleteSingles.isNotEmpty || _sortedCompleteDailies.isNotEmpty ?
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text("COMPLETE", style: Theme.of(context).textTheme.headlineSmall,),
            ) : Container();
        } else if (index < _sortedIncompleteDailies.length + _sortedIncompleteSingles.length + _sortedCompleteDailies.length + 3) {
          return CompleteItemView(
            item:  _sortedCompleteDailies[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - 3],
            onTap: () {
              Item toUncomplete = _sortedCompleteDailies[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - 3];
              widget.list.incompleteDailies.add(toUncomplete);
              widget.list.completeDailies.remove(toUncomplete);
              _upsertList();
            },
          );
        } else if (index < _sortedCompleteDailies.length + _sortedIncompleteDailies.length + _sortedCompleteSingles.length + _sortedIncompleteSingles.length + 3) {
          return CompleteItemView(
            item: _sortedCompleteSingles[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - _sortedCompleteDailies.length - 3],
            onTap: () {
              Item toUncomplete = _sortedCompleteSingles[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - _sortedCompleteDailies.length - 3];
              widget.list.incompleteSingles.add(toUncomplete);
              widget.list.completeSingles.remove(toUncomplete);
              _upsertList();
            },
          );
        } else { return const SizedBox(height: 20); }
      }
    );
  }
}
