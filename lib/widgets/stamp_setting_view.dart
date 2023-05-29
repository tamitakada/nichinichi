import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'stamp_view.dart';

class StampSettingView extends StatelessWidget {

  final CompletionLevel level;

  const StampSettingView({ super.key, required this.level });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Constants.levelToString(level).toUpperCase(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                Constants.getLevelPercentageString(level).toUpperCase()
              ),
            ],
          ),
          StampView(level: level)
        ],
      ),
    );
  }
}
