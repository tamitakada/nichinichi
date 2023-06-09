import 'package:flutter/material.dart';

import 'package:nichinichi/models/item.dart';
import 'package:nichinichi/utils/extensions.dart';


class CompleteItemView extends StatelessWidget {

  final Item item;
  final void Function() onTap;

  const CompleteItemView({ super.key, required this.item, required this.onTap });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: item.daily.value != null || item.archivedDaily.value != null
            ? ColorConverter.parse(item.daily.value?.color ?? item.archivedDaily.value!.color).withAlpha(30)
            : Colors.white24,
        ),
        margin: const EdgeInsets.fromLTRB(0, 5, 20, 5),
        padding: const EdgeInsets.all(8),
        child: Text(
          item.description ?? "",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: item.daily.value != null || item.archivedDaily.value != null
              ? ColorConverter.parse(item.daily.value?.color ?? item.archivedDaily.value!.color)
              : Colors.white,
          )
        ),
      ),
    );
  }
}