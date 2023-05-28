import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/data_manager.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/extensions.dart';
import 'base_component.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddDailyComponent extends StatefulWidget {

  final void Function() close;

  const AddDailyComponent({ super.key, required this.close });

  @override
  State<AddDailyComponent> createState() => _AddDailyComponentState();
}

class _AddDailyComponentState extends State<AddDailyComponent> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  List<TextEditingController> _itemControllers = [TextEditingController()];

  Color _currentColor = Colors.white;
  Offset _currentPosition = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: widget.close, icon: Icon(Icons.arrow_back_ios)),
              Text("ADD NEW DAILY", style: Theme.of(context).textTheme.headlineMedium,),
              IconButton(
                  onPressed: () {
                    List<Item> items = _itemControllers.map((e) => Item(description: e.text)).toList();
                    DataManager.upsertItems(items).then(
                            (success) {
                          if (success) {
                            Daily daily = Daily(title: _nameController.text, startDate: DateTime.parse(_startController.text), endDate: DateTime.parse(_endController.text), color: _currentColor.toHex());
                            DataManager.upsertDaily(daily, items).then(
                                    (success) {
                                  if (success) {
                                    widget.close();
                                  } else {
                                    print("error");
                                  }
                                }
                            );
                          }
                        }
                    );
                  },
                  icon: Icon(Icons.save_alt_outlined, color: Colors.white,)
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: TextField(
              controller: _nameController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: "DAILY TITLE",
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _startController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                      hintText: "START DATE"
                  ),
                  onChanged: (String text) {

                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _endController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                      hintText: "END DATE"
                  ),
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
                          child: Container(
                            width: 250,
                            child: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: _currentColor,
                                paletteType: PaletteType.hueWheel,
                                portraitOnly: true,
                                labelTypes: [],
                                colorPickerWidth: 250,
                                enableAlpha: false,
                                onColorChanged: (color) {
                                  setState(() {
                                    _currentColor = color;
                                  });
                                },
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
                        CircleAvatar(
                          backgroundColor: _currentColor,
                          radius: 16,
                        ),
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
          Text("TASKS", style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: _itemControllers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _itemControllers[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                            onSubmitted: (String text) {
                              if (index == _itemControllers.length - 1 && text.isNotEmpty) {
                                setState(() { _itemControllers.add(TextEditingController()); });
                              }
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.add)
                            ),
                          ),
                        ),
                        _itemControllers.length > 1
                            ? IconButton(
                            onPressed: () { setState(() { _itemControllers.removeAt(index); }); },
                            icon: const Icon(Icons.delete_outline)
                        )
                            : Container()
                      ],
                    ),
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}
