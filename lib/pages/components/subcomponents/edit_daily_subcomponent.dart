import 'package:flutter/material.dart';
import 'package:nichinichi/data_manager.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/pages/components/widgets/todo_widgets/edit_widgets.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/constants.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:nichinichi/pages/components/widgets/base_widgets/component_header_view.dart';

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
  late List<Item> _items;

  Color _currentColor = Colors.white;

  @override
  void initState() {
    if (widget.daily != null) {
      _items = widget.daily!.getSortedItems();
      _currentColor = ColorConverter.parse(widget.daily!.color);
      _nameController.text = widget.daily!.title;
      _startController.text = widget.daily!.startDate.toString();
      _endController.text = widget.daily!.endDate.toString();
    } else {
      _items = [Item(description: "")];
      _currentColor = Colors.white;
    }
    super.initState();
  }

  Future<void> _saveData() async {
    widget.daily?.color = _currentColor.toHex();
    widget.daily?.endDate = DateTime.parse(_endController.text);
    widget.daily?.startDate = DateTime.parse(_startController.text);
    widget.daily?.title = _nameController.text;
    Daily daily = widget.daily
      ?? Daily(
        title: _nameController.text,
        startDate: DateTime.parse(_startController.text),
        endDate: DateTime.parse(_endController.text),
        color: _currentColor.toHex()
      );
    await DataManager.setDailyItems(daily, _items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComponentHeaderView(
          title: "MANAGE DAILY",
          leadingAction: IconButton(onPressed: widget.close, icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18,)),
          actions: [
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
                _items.add(Item(description: ""));
                _listKey.currentState!.insertItem(_items.length - 1);
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 14)
            )
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              return ItemEditView(
                item: _items[index],
                daily: widget.daily,
                animation: animation,
                onChanged: (String updated) => _items[index].description = updated,
                onDismissed: () {
                  _items.removeAt(index);
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
