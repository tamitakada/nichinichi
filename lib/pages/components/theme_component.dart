import 'package:flutter/material.dart';
import 'base_component.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/widgets/stamp_view.dart';

class ThemeComponent extends StatelessWidget {

  final void Function() close;

  ThemeComponent({ super.key, required this.close });

  final List<CompletionLevel> _sortedKeys = [
    CompletionLevel.perfect,
    CompletionLevel.high,
    CompletionLevel.medium,
    CompletionLevel.low
  ];
  final Map<CompletionLevel, String> _stamps = {
    CompletionLevel.low: "",
    CompletionLevel.medium: "",
    CompletionLevel.high: "",
    CompletionLevel.perfect: ""
  };

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
              (value) => StampView(level: value, currentStamp: _stamps[value] ?? "")
            ).toList(),
          )
        ],
      )
    );
  }
}
