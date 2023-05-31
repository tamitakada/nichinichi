import 'package:flutter/material.dart';
import 'widgets/base_widgets/base_component.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/widgets/stamp_setting_view.dart';

class ThemeComponent extends StatelessWidget {

  final void Function() close;

  ThemeComponent({ super.key, required this.close });

  final List<CompletionLevel> _sortedKeys = [
    CompletionLevel.perfect,
    CompletionLevel.high,
    CompletionLevel.medium,
    CompletionLevel.low
  ];

  @override
  Widget build(BuildContext context) {
    return BaseComponent(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: close,
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                ),
                Text("THEME", style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            const SizedBox(height: 20),
            Text("COMPLETION STAMPS", style: Theme.of(context).textTheme.headlineSmall),
            Row(
              children: _sortedKeys.map(
                (value) => StampSettingView(level: value)
              ).toList(),
            )
          ],
        ),
      )
    );
  }
}
