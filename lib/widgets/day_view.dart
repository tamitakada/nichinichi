import 'package:flutter/material.dart';
import 'dart:math';

class DayView extends StatelessWidget {

  final int day;
  final int? completionLevel;

  const DayView({ super.key, required this.day, required this.completionLevel });

  Widget buildStamp() {
    switch (completionLevel) {
      case null:
        return Transform.rotate(
          angle: pi / 4,
          child: Container(
            height: 20,
            width: 10,
            color: Colors.white,
          ),
        );
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
