import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'dart:math';

class DayView extends StatelessWidget {

  final int day;
  final CompletionLevel completionLevel;

  const DayView({ super.key, required this.day, required this.completionLevel });

  Widget buildStamp() {
    switch (completionLevel) {
      case CompletionLevel.noData:
        return Center(
          child: Transform.rotate(
            angle: pi / 5,
            child: Container(
              height: 40,
              width: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2)
              ),
            ),
          ),
        );
      case CompletionLevel.low:
        return CircleAvatar();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("$day"),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white30
              ),
              padding: const EdgeInsets.all(10),
              child: buildStamp(),
            ),
          )
        ],
      ),
    );
  }
}
