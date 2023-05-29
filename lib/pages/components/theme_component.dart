import 'package:flutter/material.dart';
import 'base_component.dart';
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
      child: Column(
        children: [
          Text("THEME", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Text("COMPLETION STAMPS", style: Theme.of(context).textTheme.headlineSmall),
          Column(
            children: _sortedKeys.map(
              (value) => StampSettingView(level: value)
            ).toList(),
          )
        ],
      )
    );
  }
}
