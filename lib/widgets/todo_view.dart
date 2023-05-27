import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/data_manager.dart';
import 'item_view.dart';
import 'package:nichinichi/data_manager.dart';

class TodoView extends StatefulWidget {
  
  const TodoView({Key? key}) : super(key: key);

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  
  late TodoList _todaysList;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 2),
          right: BorderSide(color: Colors.white, width: 2),
        )
      ),
      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
      child: Column(
        children: [
          Text("TODAY'S TODOS", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<TodoList?>(
              future: DataManager.getTodaysList(),
              builder: (BuildContext context, AsyncSnapshot<TodoList?> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    _todaysList = snapshot.data!;
                    return ListView.builder(
                      itemCount: _todaysList.incompleteDailies.length + _todaysList.completeDailies.length + _todaysList.incompleteSingles.length + _todaysList.completeSingles.length + 3,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("DAILIES", style: Theme.of(context).textTheme.headlineSmall,),
                          );
                        } else if (index <= _todaysList.incompleteDailies.length) {
                          return IncompleteItemView(
                            item: _todaysList.incompleteDailies.elementAt(index - 1),
                            onTap: () {
                              _todaysList.completeDailies.add(_todaysList.incompleteDailies.elementAt(index - 1));
                              _todaysList.incompleteDailies.remove(_todaysList.incompleteDailies.elementAt(index - 1));
                              DataManager.upsertList(_todaysList).then(
                                (success) { if (success) setState(() {}); }
                              );
                            },
                          );
                        } else if (index == _todaysList.incompleteDailies.length + 1) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("SINGLES", style: Theme.of(context).textTheme.headlineSmall,),
                                IconButton(
                                  onPressed: () {
                                    Item newItem = Item(description: "", notes: "", order: _todaysList.incompleteSingles.length);
                                    DataManager.upsertItem(newItem).then(
                                      (success) {
                                        if (success) {
                                          _todaysList.incompleteSingles.add(newItem);
                                          DataManager.upsertList(_todaysList).then((success) { if (success) setState(() {}); });
                                        }
                                      }
                                    );
                                  },
                                  icon: const Icon(Icons.add, color: Colors.white, size: 18,)
                                )
                              ],
                            ),
                          );
                        } else if (index < _todaysList.incompleteDailies.length + _todaysList.incompleteSingles.length + 2) {
                          return IncompleteItemView(
                            item: _todaysList.incompleteSingles.elementAt(index - _todaysList.incompleteDailies.length - 2),
                            onTap: () {
                              _todaysList.completeSingles.add(_todaysList.incompleteSingles.elementAt(index - _todaysList.incompleteDailies.length - 2));
                              _todaysList.incompleteSingles.remove(_todaysList.incompleteSingles.elementAt(index - _todaysList.incompleteDailies.length - 2));
                              DataManager.upsertList(_todaysList).then((success) { if (success) setState(() {}); });
                            },
                            onSubmitted: (String text) {
                              DataManager.getItem(_todaysList.incompleteSingles.elementAt(index - _todaysList.incompleteDailies.length - 2).id).then(
                                (item) {
                                  if (item != null) {
                                    item.description = text;
                                    DataManager.upsertItem(item).then( (success) { if (success) { setState(() {}); } } );
                                  }
                                }
                              );
                            },
                          );
                        } else if (index == _todaysList.incompleteDailies.length + _todaysList.incompleteSingles.length + 2) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("COMPLETE", style: Theme.of(context).textTheme.headlineSmall,),
                          );
                        } else if (index < _todaysList.incompleteDailies.length + _todaysList.incompleteSingles.length + _todaysList.completeDailies.length + 3) {
                          return CompleteItemView(
                            item: _todaysList.completeDailies.elementAt(index - _todaysList.incompleteDailies.length - _todaysList.incompleteSingles.length - 3),
                            onTap: () {
                              _todaysList.incompleteDailies.add(_todaysList.completeDailies.elementAt(index - _todaysList.incompleteDailies.length - _todaysList.incompleteSingles.length - 3));
                              _todaysList.completeDailies.remove(_todaysList.completeDailies.elementAt(index - _todaysList.incompleteDailies.length - _todaysList.incompleteSingles.length - 2));
                              DataManager.upsertList(_todaysList).then(
                                (success) { if (success) setState(() {}); }
                              );
                            },
                          );
                        } else {
                          return CompleteItemView(
                            item: _todaysList.completeSingles.elementAt(index - _todaysList.incompleteDailies.length - _todaysList.incompleteSingles.length - _todaysList.completeDailies.length - 3),
                            onTap: () {
                              _todaysList.incompleteSingles.add(_todaysList.completeSingles.elementAt(index - _todaysList.incompleteDailies.length - _todaysList.incompleteSingles.length - _todaysList.completeDailies.length - 3));
                              _todaysList.completeSingles.remove(_todaysList.completeSingles.elementAt(index - _todaysList.incompleteDailies.length - _todaysList.incompleteSingles.length - _todaysList.completeDailies.length - 2));
                              DataManager.upsertList(_todaysList).then((success) { if (success) setState(() {}); });
                            },
                          );
                        }
                      }
                    );
                  } else { return const Text("error"); }
                } else {
                  return const Text("loading...");
                }
              }
            )
          )
        ],
      ),
    );
  }
}
