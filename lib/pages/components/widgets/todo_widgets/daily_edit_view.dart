import 'package:flutter/material.dart';
import 'package:nichinichi/models/item.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/constants.dart';

class DailyEditView extends StatelessWidget {

  final Item item;
  final Animation<double> animation;
  final void Function() onDismissed;

  const DailyEditView({ super.key, required this.item, required this.animation, required this.onDismissed });

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
                    color: ColorConverter.parse(item.daily.value?.color ?? ""),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.description ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
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