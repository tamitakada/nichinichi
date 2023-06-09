import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/models/item.dart';


class DailyEditView extends StatefulWidget {

  final Item item;
  final int index;
  final bool animate;
  final void Function() onDismissed;
  final void Function()? onTap;

  const DailyEditView({
    Key? key,
    required this.item,
    required this.index,
    required this.onDismissed,
    this.onTap,
    this.animate = false
  }) : super(key: key);

  @override
  State<DailyEditView> createState() => _DailyEditViewState();
}

class _DailyEditViewState extends State<DailyEditView> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300)
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.animate
      ? SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0)
        ).animate(_animationController),
        child: _DailyEditView(
          key: UniqueKey(),
          item: widget.item,
          index: widget.index,
          onDismissed: widget.onDismissed,
          onTap: widget.onTap,
        )
      )
      : _DailyEditView(
        key: UniqueKey(),
        item: widget.item,
        index: widget.index,
        onDismissed: widget.onDismissed,
        onTap: widget.onTap,
      );
  }
}

class _DailyEditView extends StatelessWidget {

  final Item item;
  final int index;
  final void Function() onDismissed;
  final void Function()? onTap;

  const _DailyEditView({
    Key? key,
    required this.item,
    required this.index,
    required this.onDismissed,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
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
                onTap: onTap,
                child: Container(
                  width: 15, height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConverter.parse(item.daily.value?.color ?? ""),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.description ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ),
              const SizedBox(width: 10),
              ReorderableDragStartListener(
                index: index,
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
