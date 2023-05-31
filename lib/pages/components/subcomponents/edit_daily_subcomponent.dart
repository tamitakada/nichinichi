import 'package:flutter/material.dart';
import 'package:nichinichi/data_manager.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/pages/components/widgets/todo_widgets/edit_widgets.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/constants.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditDailySubcomponent extends StatefulWidget {

  final Daily? daily;
  final void Function() close;

  const EditDailySubcomponent({ super.key, required this.close, this.daily });

  @override
  State<EditDailySubcomponent> createState() => _EditDailySubcomponentState();
}

class _EditDailySubcomponentState extends State<EditDailySubcomponent> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  List<Item> _initialItems = [];
  List<Item> _newItems = [];

  Color _currentColor = Colors.white;

  @override
  void initState() {
    if (widget.daily != null) {
      _initialItems = widget.daily!.items.toList();
      _currentColor = ColorConverter.parse(widget.daily!.color);
      _nameController.text = widget.daily!.title;
      _startController.text = widget.daily!.startDate.toString();
      _endController.text = widget.daily!.endDate.toString();
    } else {
      _newItems = [Item(description: "")];
      _currentColor = Colors.white;
    }
    super.initState();
  }

  Future<void> _saveData() async {
    int counter = 0;
    while (counter < _initialItems.length) {
      if (_initialItems[counter].description?.isNotEmpty ?? false) {
        _initialItems[counter].order = counter;
        counter++;
      } else {
        _initialItems.removeAt(counter);
      }
    }
    List<Item> items = [];
    int upsertCount = 0;
    for (int i = 0; i < _newItems.length; i++) {
      if (_newItems[i].description?.isNotEmpty ?? false) {
        items.add(Item(description: _newItems[i].description, order: upsertCount + _initialItems.length));
        upsertCount++;
      }
    }
    if (await DataManager.upsertItems(items)) {
      if (widget.daily != null) {
        DataManager.setItemsInDaily(widget.daily!, _initialItems, items);
        widget.daily?.color = _currentColor.toHex();
        widget.daily?.endDate = DateTime.parse(_endController.text);
        widget.daily?.startDate = DateTime.parse(_startController.text);
        widget.daily?.title =  _nameController.text;
      } else {
        Daily toUpsert = Daily(
          title: _nameController.text,
          startDate: DateTime.parse(_startController.text),
          endDate: DateTime.parse(_endController.text),
          color: _currentColor.toHex()
        );
        await DataManager.upsertDaily(toUpsert, true, items);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.close,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16)
                  ),
                  Text("MANAGE DAILY", style: Theme.of(context).textTheme.headlineMedium)
                ],
              ),
            ),
            Row(
              children: [
                widget.daily != null
                  ? IconButton(
                    onPressed: () => DataManager.deleteDaily(widget.daily!).then((_) => widget.close()),
                    icon: const Icon(Icons.delete_outline_rounded, color: Constants.red, size: 18)
                  ) : Container(),
                IconButton(
                  onPressed: () => _saveData().then((_) => widget.close()),
                  icon: const Icon(Icons.save_alt_rounded, color: Colors.white, size: 18)
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: TextField(
            controller: _nameController,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(hintText: "DAILY TITLE",),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _startController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(hintText: "START DATE"),
                onChanged: (String text) {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _endController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(hintText: "END DATE"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: SizedBox(
                          width: 250,
                          child: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: _currentColor,
                              paletteType: PaletteType.hueWheel,
                              portraitOnly: true,
                              labelTypes: const [],
                              colorPickerWidth: 250,
                              enableAlpha: false,
                              onColorChanged: (color) { setState(() { _currentColor = color; }); },
                            ),
                          ),
                        )
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2)
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: _currentColor, radius: 16),
                      const SizedBox(width: 10),
                      const Text("DAILY COLOR", style: TextStyle(fontFamily: "Zen", color: Colors.white, letterSpacing: 2),)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text("TASKS", style: Theme.of(context).textTheme.headlineSmall,),
            IconButton(
              onPressed: () {
                _newItems.add(Item(description: ""));
                _listKey.currentState!.insertItem(
                  _initialItems.length + _newItems.length - 1
                );
              },
              icon: Icon(Icons.add, color: Colors.white, size: 14)
            )
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _initialItems.length + _newItems.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              return ItemEditView(
                item: index < _initialItems.length ? _initialItems[index] : _newItems[index - _initialItems.length],
                daily: widget.daily,
                animation: animation,
                onChanged: (String updated) {
                  if (index < _initialItems.length) {
                    _initialItems[index].description = updated;
                  } else {
                    _newItems[index - _initialItems.length].description = updated;
                  }
                },
                onDismissed: () {
                  if (index < _initialItems.length) { _initialItems.removeAt(index); }
                  else { _newItems.removeAt(index - _initialItems.length); }
                  _listKey.currentState!.removeItem(index, (context, animation) => Container());
                }
              );
            },
          ),
        )
      ],
    );
  }
}
