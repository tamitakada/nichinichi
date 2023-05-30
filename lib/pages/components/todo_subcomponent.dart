import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_manager.dart';
import 'widgets/todo_widgets/static_widgets.dart';

class TodoSubcomponent extends StatefulWidget {

  final TodoList list;
  final void Function() openEdit;

  const TodoSubcomponent({ super.key, required this.list, required this.openEdit });

  @override
  State<TodoSubcomponent> createState() => _TodoSubcomponentState();
}

class _TodoSubcomponentState extends State<TodoSubcomponent> {
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
                  onPressed: widget.openEdit,
                  icon: const Icon(Icons.edit, color: Colors.white, size: 14,)
                )
              ]
            )
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: widget.list.incompleteDailies.length + widget.list.completeDailies.length + widget.list.incompleteSingles.length + widget.list.completeSingles.length + 3,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("DAILIES", style: Theme.of(context).textTheme.headlineSmall,),
                );
              } else if (index <= widget.list.incompleteDailies.length) {
                return IncompleteItemView(
                  item: widget.list.incompleteDailies.elementAt(index - 1),
                  onTap: () {
                    widget.list.completeDailies.add(widget.list.incompleteDailies.elementAt(index - 1));
                    widget.list.incompleteDailies.remove(widget.list.incompleteDailies.elementAt(index - 1));
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() {}); });
                  }
                );
              } else if (index == widget.list.incompleteDailies.length + 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("SINGLES", style: Theme.of(context).textTheme.headlineSmall)
                );
              } else if (index < widget.list.incompleteDailies.length + widget.list.incompleteSingles.length + 2) {
                return IncompleteItemView(
                  item: widget.list.incompleteSingles.elementAt(index - widget.list.incompleteDailies.length - 2),
                  onTap: () {
                    widget.list.completeSingles.add(widget.list.incompleteSingles.elementAt(index - widget.list.incompleteDailies.length - 2));
                    widget.list.incompleteSingles.remove(widget.list.incompleteSingles.elementAt(index - widget.list.incompleteDailies.length - 2));
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() {}); });
                  },
                );
              } else if (index == widget.list.incompleteDailies.length + widget.list.incompleteSingles.length + 2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text("COMPLETE", style: Theme.of(context).textTheme.headlineSmall,),
                );
              } else if (index < widget.list.incompleteDailies.length + widget.list.incompleteSingles.length + widget.list.completeDailies.length + 3) {
                return CompleteItemView(
                  item: widget.list.completeDailies.elementAt(index - widget.list.incompleteDailies.length - widget.list.incompleteSingles.length - 3),
                  onTap: () {
                    widget.list.incompleteDailies.add(widget.list.completeDailies.elementAt(index - widget.list.incompleteDailies.length - widget.list.incompleteSingles.length - 3));
                    widget.list.completeDailies.remove(widget.list.completeDailies.elementAt(index - widget.list.incompleteDailies.length - widget.list.incompleteSingles.length - 2));
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() {}); });
                  },
                );
              } else {
                return CompleteItemView(
                  item: widget.list.completeSingles.elementAt(index - widget.list.incompleteDailies.length - widget.list.incompleteSingles.length - widget.list.completeDailies.length - 3),
                  onTap: () {
                    widget.list.incompleteSingles.add(widget.list.completeSingles.elementAt(index - widget.list.incompleteDailies.length - widget.list.incompleteSingles.length - widget.list.completeDailies.length - 3));
                    widget.list.completeSingles.remove(widget.list.completeSingles.elementAt(index - widget.list.incompleteDailies.length - widget.list.incompleteSingles.length - widget.list.completeDailies.length - 2));
                    DataManager.upsertList(widget.list).then((success) { if (success) setState(() {}); });
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
