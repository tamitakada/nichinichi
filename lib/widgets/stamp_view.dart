import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/painters/stamp.dart';

class StampView extends StatelessWidget {

  final CompletionLevel level;
  final String currentStamp;

  const StampView({ super.key, required this.level, required this.currentStamp });

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
          CustomPaint(
            painter: Stamp(
              color: Constants.getLevelColor(level),
            ),
            child: Container(
              height: 36,
              width: 36,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CircleAvatar(
                backgroundColor: Colors.pinkAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
