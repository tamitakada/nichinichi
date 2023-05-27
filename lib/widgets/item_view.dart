import 'package:flutter/material.dart';
import 'package:nichinichi/models/models.dart';
import 'package:nichinichi/extensions.dart';
import 'package:nichinichi/data_manager.dart';

class IncompleteItemView extends StatelessWidget {

  final Item item;
  final void Function() onTap;
  final void Function(String)? onSubmitted;
  
  IncompleteItemView({ super.key, required this.item, required this.onTap, this.onSubmitted });

  late final TextEditingController _controller = TextEditingController(
    text: item.description
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.all(8),
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
            Expanded(
              child: (item.daily.value != null)
                ? Text(item.description ?? "", style: Theme.of(context).textTheme.bodySmall,)
                : TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodySmall,
                  decoration: null,
                  onSubmitted: onSubmitted,
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompleteItemView extends StatelessWidget {

  final Daily? daily;
  final Item item;
  final void Function() onTap;

  const CompleteItemView({ super.key, required this.item, required this.onTap, this.daily });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: daily != null ? ColorConverter.parse(daily?.color ?? "33CCD6") : Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: daily != null ? ColorConverter.parse(daily?.color ?? "33CCD6").withAlpha(30) : Colors.white24,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(8),
        child: Text(
          item.description ?? "",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: daily != null ? ColorConverter.parse(daily?.color ?? "33CCD6") : Colors.white,
          )
        ),
      ),
    );
  }
}