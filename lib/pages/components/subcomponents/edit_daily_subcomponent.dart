import 'package:flutter/material.dart';
import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/global_widgets/framed_button.dart';
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
  late List<Item> _items;

  Color _currentColor = Colors.white;

  @override
  void initState() {
    if (widget.daily != null) {
      _items = widget.daily!.getSortedItems();
      _currentColor = ColorConverter.parse(widget.daily!.color);
      _nameController.text = widget.daily!.title;
    } else {
      _items = [Item(description: "")];
      _currentColor = Colors.white;
    }
    super.initState();
  }

  Future<void> _saveData(bool archive) async {
    widget.daily?.archived = archive;
    widget.daily?.color = _currentColor.toHex();
    widget.daily?.title = _nameController.text;
    Daily daily = widget.daily
      ?? Daily(
        title: _nameController.text,
        color: _currentColor.toHex()
      );
    if (await DataManager.upsertDaily(daily)) {
      await DataManager.setDailyItems(daily, _items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComponentHeaderView(
          title: "MANAGE DAILY",
          leadingAction: IconButton(onPressed: widget.close, icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18,)),
          actions: [
            IconButton(
              onPressed: () => _saveData(false).then((_) => widget.close()),
              icon: const Icon(Icons.save_alt_rounded, color: Colors.white, size: 18)
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: Row(
            children: [
              GestureDetector(
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
                child: CircleAvatar(backgroundColor: _currentColor, radius: 10),
              ),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(hintText: "DAILY TITLE",),
                ),
              )
            ],
          ),
        ),
        widget.daily != null ?
          Row(
            children: [
              FramedButton(
                text: "Archive",
                onTap: () => _saveData(true)
              ),
              FramedButton(
                text: "Delete",
                onTap: () => DataManager.deleteDaily(widget.daily!).then((_) => widget.close())
              )
            ],
          ) : Container(),
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
