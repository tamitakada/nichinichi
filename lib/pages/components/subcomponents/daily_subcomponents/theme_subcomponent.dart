import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/pages/components/widgets/theme_widgets/stamp_setting_view.dart';
import 'package:nichinichi/utils/abstract_classes/overlay_manager.dart';


class ThemeSubcomponent extends StatelessWidget {

  final OverlayManager manager;

  const ThemeSubcomponent({ super.key, required this.manager});

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
            children: [
              CompletionLevel.perfect,
              CompletionLevel.high,
              CompletionLevel.medium,
              CompletionLevel.low
            ].map(
              (value) => Expanded(
                child: StampSettingView(manager: manager, level: value)
              )
            ).toList(),
          )
        ],
      ),
    );
  }
}
