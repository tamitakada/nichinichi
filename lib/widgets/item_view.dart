import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/data_manager.dart';

class IncompleteItemView extends StatelessWidget {

  final Item item;
  final bool isEditable;
  final Animation<double> animation;
  final void Function() onTap;
  final void Function(String)? onSubmitted;
  final void Function() onDismissed;
  
  IncompleteItemView({ super.key, required this.item, required this.isEditable, required this.animation, required this.onTap, required this.onDismissed,  this.onSubmitted });

  late final TextEditingController _controller = TextEditingController(
    text: item.description
  );

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0)
      ).animate(animation),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (_) { onDismissed(); },
        background: const Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 15, height: 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: item.daily.value != null ? ColorConverter.parse(item.daily.value?.color ?? "33CCD6") : Colors.white30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: isEditable
                    ? TextField(
                      controller: _controller,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: null,
                      onSubmitted: onSubmitted,
                    )
                    : Text(
                      item.description ?? "",
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 5
                    )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

