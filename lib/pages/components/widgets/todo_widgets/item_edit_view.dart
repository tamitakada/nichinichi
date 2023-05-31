import 'package:flutter/material.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/constants.dart';

class ItemEditView extends StatelessWidget {

  final Item item;
  final Daily? daily;
  final Animation<double> animation;
  final void Function(String) onChanged;
  final void Function() onDismissed;

  ItemEditView({ super.key, required this.item, required this.animation, required this.onChanged, required this.onDismissed, this.daily });

  late final TextEditingController _controller = TextEditingController(text: item.description);

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
              borderRadius: BorderRadius.circular(6)
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15, height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: daily != null ? ColorConverter.parse(daily!.color) : Colors.white30,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: null,
                    onChanged: onChanged,
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