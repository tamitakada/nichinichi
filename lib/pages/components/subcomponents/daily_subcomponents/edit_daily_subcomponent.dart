import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/utils/error_management.dart';
import 'package:nichinichi/utils/confirmation_mixin.dart';

import 'package:nichinichi/data_management/data_manager.dart';
import 'package:nichinichi/models/models.dart';

import 'package:nichinichi/pages/components/widgets/todo_widgets/edit_widgets.dart';
import 'package:nichinichi/pages/components/widgets/base_widgets/component_header_view.dart';


class EditDailySubcomponent extends StatefulWidget {

  final Daily? daily;
  final OverlayManager manager;
  final void Function() close;

  const EditDailySubcomponent({ super.key, required this.manager, required this.close, this.daily });

  @override
  State<EditDailySubcomponent> createState() => _EditDailySubcomponentState();
}

class _EditDailySubcomponentState extends State<EditDailySubcomponent> with ErrorMixin, ConfirmationMixin {

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

  Future<void> _archive() async {
    if (widget.daily != null) {
      if (!await DataManager.archiveDaily(widget.daily!)) {
        showError(widget.manager, ErrorType.save);
      }
    }
  }

  Future<void> _unarchive() async {
    if (widget.daily != null) {
      if (!await DataManager.unarchiveDaily(widget.daily!)) {
        showError(widget.manager, ErrorType.save);
      }
    }
  }

  Future<void> _saveData() async {
    widget.daily?.color = _currentColor.toHex();
    widget.daily?.title = _nameController.text;
    Daily daily = widget.daily
      ?? Daily(title: _nameController.text, color: _currentColor.toHex());
    if (!await DataManager.upsertDaily(daily) ||
        !await DataManager.setDailyItems(daily, _items)) {
      showError(widget.manager, ErrorType.save);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComponentHeaderView(
          title: "MANAGE DAILY",
          leadingAction: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.arrow_back_ios, color: Colors.white, size: 18,
            )
          ),
          actions: [
            widget.daily != null ? IconButton(
              onPressed: () {
                showConfirmation(
                  "Deleting will also remove all past records.",
                  widget.manager,
                  () => DataManager.deleteDaily(widget.daily!).then((_) => widget.close()),
                );
              },
              icon: const Icon(Icons.delete_outline_rounded, color: Constants.red, size: 20)
            ) : Container(),
            widget.daily != null ? IconButton(
              onPressed: () {
                if (widget.daily!.archived) {
                  _unarchive().then((_) => widget.close());
                }
                else {
                  showConfirmation(
                    "Archiving will keep past records available but will stop adding these tasks to your to do lists.",
                    widget.manager,
                    () => _archive().then((_) => widget.close()),
                  );
                }
              },
              icon: Icon(
                widget.daily!.archived ? Icons.unarchive_outlined : Icons.archive_outlined,
                color: widget.daily!.archived ? Constants.yellow : Constants.red,
                size: 20
              )
            ) : Container(),
            IconButton(
              onPressed: () => _saveData().then((_) => widget.close()),
              icon: const Icon(Icons.save_alt_rounded, color: Colors.white, size: 20)
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
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(hintText: "DAILY TITLE"),
                ),
              )
            ],
          ),
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
                },
                color: _currentColor,
              );
            },
          ),
        )
      ],
    );
  }
}
