import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/pages/components/widgets/theme_widgets/stamp_setting_view.dart';

class ThemeComponent extends StatelessWidget {

  ThemeComponent({ super.key });

  final List<CompletionLevel> _sortedKeys = [
    CompletionLevel.perfect,
    CompletionLevel.high,
    CompletionLevel.medium,
    CompletionLevel.low
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () { Navigator.of(context).pop(); },
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
    );
  }
}
