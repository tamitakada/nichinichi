import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_manager.dart';
import '../widgets/todo_widgets/static_widgets.dart';
import 'package:nichinichi/utils/extensions.dart';

class TodoSubcomponent extends StatefulWidget {

  final TodoList list;
  final void Function() openEdit;

  const TodoSubcomponent({ super.key, required this.list, required this.openEdit });

  @override
  State<TodoSubcomponent> createState() => _TodoSubcomponentState();
}

class _TodoSubcomponentState extends State<TodoSubcomponent> {

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

  @override
  void initState() {
    _setSortedLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("TODAY'S TODOS", style: Theme.of(context).textTheme.headlineMedium),
              Row(
                children: [
                  IconButton(
                    onPressed: widget.openEdit,
                    icon: const Icon(Icons.edit, color: Colors.white, size: 14,)
                  )
                ]
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _sortedCompleteDailies.length + _sortedIncompleteDailies.length + _sortedCompleteSingles.length + _sortedIncompleteSingles.length + 3,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("DAILY", style: Theme.of(context).textTheme.headlineSmall,),
                );
              } else if (index <= _sortedIncompleteDailies.length) {
                return IncompleteItemView(
                  item: _sortedIncompleteDailies[index - 1],
                  onTap: () {
                    Item toComplete = _sortedIncompleteDailies[index - 1];
                    widget.list.completeDailies.add(toComplete);
                    widget.list.incompleteDailies.remove(toComplete);
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() { _setSortedLists(); }); });
                  }
                );
              } else if (index == _sortedIncompleteDailies.length + 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("FOR TODAY", style: Theme.of(context).textTheme.headlineSmall)
                );
              } else if (index < _sortedIncompleteDailies.length + _sortedIncompleteSingles.length + 2) {
                return IncompleteItemView(
                  item: _sortedIncompleteSingles[index - widget.list.incompleteDailies.length - 2],
                  onTap: () {
                    Item toComplete = _sortedIncompleteSingles[index - widget.list.incompleteDailies.length - 2];
                    widget.list.completeSingles.add(toComplete);
                    widget.list.incompleteSingles.remove(toComplete);
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() {_setSortedLists();}); });
                  },
                );
              } else if (index == _sortedIncompleteDailies.length + _sortedIncompleteSingles.length + 2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("COMPLETE", style: Theme.of(context).textTheme.headlineSmall,),
                );
              } else if (index < _sortedIncompleteDailies.length + _sortedIncompleteSingles.length + _sortedCompleteDailies.length + 3) {
                return CompleteItemView(
                  item:  _sortedCompleteDailies[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - 3],
                  onTap: () {
                    Item toUncomplete = _sortedCompleteDailies[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - 3];
                    widget.list.incompleteDailies.add(toUncomplete);
                    widget.list.completeDailies.remove(toUncomplete);
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() { _setSortedLists(); }); });
                  },
                );
              } else {
                return CompleteItemView(
                  item: _sortedCompleteSingles[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - _sortedCompleteDailies.length - 3],
                  onTap: () {
                    Item toUncomplete = _sortedCompleteSingles[index - _sortedIncompleteDailies.length - _sortedIncompleteSingles.length - _sortedCompleteDailies.length - 3];
                    widget.list.incompleteSingles.add(toUncomplete);
                    widget.list.completeSingles.remove(toUncomplete);
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() { _setSortedLists(); }); });
                  },
                );
              }
            }
          ),
        )
      ],
    );
  }
}