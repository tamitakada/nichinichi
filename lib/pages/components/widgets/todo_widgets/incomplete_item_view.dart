import 'package:flutter/material.dart';
import 'package:nichinichi/models/item.dart';
import 'package:nichinichi/utils/extensions.dart';
import 'package:nichinichi/constants.dart';

class IncompleteItemView extends StatelessWidget {

  final Item item;
  final void Function() onTap;

  IncompleteItemView({ super.key, required this.item, required this.onTap });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  color: item.daily.value != null ? ColorConverter.parse(item.daily.value?.color ?? "33CCD6") : Colors.white30,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(item.description ?? "", style: Theme.of(context).textTheme.bodySmall)),
          ],
        ),
      ),
    );
  }
}