import 'dart:math';

import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/global_widgets/stamp_view.dart';


class DayView extends StatelessWidget {

  final int day;
  final CompletionLevel level;

  const DayView({ super.key, required this.day, required this.level });

  Widget _buildStamp() {
    switch (level) {
      case CompletionLevel.noData:
        return Container(
          decoration: BoxDecoration(
            color: Constants.getLevelColor(level),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Center(
            child: Transform.rotate(
              angle: pi / 6,
              child: Container(
                height: 40,
                width: 2,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(2)
                ),
              ),
            ),
          ),
        );
      case CompletionLevel.none:
        return Container(
          decoration: BoxDecoration(
            color: Constants.getLevelColor(level).withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Center(
            child: Icon(Icons.close, color: Constants.getLevelColor(level)),
          ),
        );
      default:
        return StampView(level: level);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.75,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("$day"), Expanded(child: _buildStamp())],
        ),
      ),
    );
  }
}
