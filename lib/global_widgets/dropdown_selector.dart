import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/abstract_classes/overlay_manager.dart';

class DropdownSelector<T> extends StatefulWidget {

  final List<T> options;
  final List<String> optionNames;
  final T? initialSelection;
  final void Function(T?) onChanged;
  final OverlayManager manager;

  final double maxWidth;
  final double maxHeight;

  const DropdownSelector({
    super.key,
    required this.manager,
    required this.options,
    required this.optionNames,
    required this.onChanged,
    this.initialSelection,
    this.maxHeight = 200,
    this.maxWidth = 200
  });

  @override
  State<DropdownSelector<T>> createState() => _DropdownSelectorState<T>();
}

class _DropdownSelectorState<T> extends State<DropdownSelector<T>> with TickerProviderStateMixin {

  late int _currentIndex;

  final GlobalKey _dropdownKey = GlobalKey();

  late AnimationController _overlayController;
  late Animation<double> _overlayAnimation;

  @override
  void initState() {
    if (widget.initialSelection != null) {
      _currentIndex = widget.options.indexOf(widget.initialSelection!);
    } else { _currentIndex = 0; }
    _overlayController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200)
    );
    _overlayAnimation = Tween<double>(begin: 0, end: 1)
      .animate(_overlayController);
    super.initState();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  Widget _buildOverlayDropdown(BuildContext context) {
    RenderBox? selectedBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = selectedBox.localToGlobal(Offset.zero);
    return Positioned(
      top: position.dy + selectedBox.size.height,
      left: position.dx,
      child: SizeTransition(
        sizeFactor: _overlayAnimation,
        child: Container(
          width: selectedBox.size.width,
          clipBehavior: Clip.antiAlias,
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          decoration: BoxDecoration(
              color: Constants.grey,
              borderRadius: BorderRadius.circular(10)
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.options.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  widget.manager.closeOverlay();
                  setState(() { _currentIndex = index; });
                  widget.onChanged(widget.options[_currentIndex]);
                },
                child: Container(
                  color: index == _currentIndex ? Constants.bgColor : Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white24, width: 0.6))
                    ),
                    child: Text(
                      widget.optionNames[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.manager.isOverlayOpen()) {
          widget.manager.closeOverlay();
        } else {
          widget.manager.updateOverlay(_buildOverlayDropdown(context));
          _overlayController.reset();
          _overlayController.forward();
        }
      },
      child: Container(
        clipBehavior: Clip.none,
        key: _dropdownKey,
        constraints: const BoxConstraints(maxHeight: 40),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Constants.grey
        ),
        child: Container(
          height: 40,
          width: widget.maxWidth,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.optionNames[_currentIndex] ?? "",
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                )
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


