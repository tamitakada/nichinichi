import 'package:flutter/material.dart';

import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/constants.dart';

class ItemView extends StatefulWidget {

  final Item item;
  final int index;
  final Daily? daily;
  final bool animate;

  final void Function(String) onSubmitted;
  final void Function() onDismissed;
  final void Function()? onTap;

  final Color? color;

  const ItemView({
    Key? key,
    required this.item,
    required this.index,
    required this.onSubmitted,
    required this.onDismissed,
    this.onTap,
    this.daily,
    this.color,
    this.animate = false
  }) : super(key: key);

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late bool _animate;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300)
    );
    _animate = widget.animate;
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationController.reset();
        _animationController.forward();
        _animate = false;
      });
    }
    return _animate
     ? SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0)
        ).animate(_animationController),
        child: ItemEditView(
          key: UniqueKey(),
          item: widget.item,
          index: widget.index,
          onSubmitted: widget.onSubmitted,
          onDismissed: widget.onDismissed,
          onTap: widget.onTap,
          color: widget.color,
        )
      )
    : ItemEditView(
      key: UniqueKey(),
      item: widget.item,
      index: widget.index,
      onSubmitted: widget.onSubmitted,
      onDismissed: widget.onDismissed,
      onTap: widget.onTap,
      color: widget.color,
    );
  }
}

class ItemEditView extends StatefulWidget {

  final Item item;
  final int index;
  final void Function(String) onSubmitted;
  final void Function() onDismissed;
  final void Function()? onTap;
  final Color? color;

  const ItemEditView({
    Key? key,
    required this.item,
    required this.index,
    required this.onSubmitted,
    required this.onDismissed,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  State<ItemEditView> createState() => _ItemEditViewState();
}

class _ItemEditViewState extends State<ItemEditView> {

  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _controller = TextEditingController(text: widget.item.description);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) { widget.onSubmitted(_controller.text); }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDismissed(),
      background: const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
        child: Container(
          decoration: BoxDecoration(
            color: Constants.grey,
            borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: 15, height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: widget.color ??
                      (widget.item.daily.value != null
                        ? ColorConverter.parse(widget.item.daily.value!.color)
                        : Colors.white30
                      ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: null,
                  expands: true,
                  onSubmitted: widget.onSubmitted,
                  maxLines: null,
                  minLines: null,
                )
              ),
              const SizedBox(width: 10),
              ReorderableDragStartListener(
                index: widget.index,
                child: const Icon(
                  Icons.drag_handle_rounded,
                  color: Colors.white,
                  size: 14,
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
