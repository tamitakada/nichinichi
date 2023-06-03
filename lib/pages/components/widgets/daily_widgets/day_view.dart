import 'dart:math';

import 'package:flutter/material.dart';

import 'package:nichinichi/constants.dart';
import 'package:nichinichi/data_management/stamp_manager.dart';
import 'package:nichinichi/global_widgets/stamp_view.dart';


class DayView extends StatelessWidget {

  final int day;
  final CompletionLevel level;

  const DayView({ super.key, required this.day, required this.level });

  Widget _buildStamp() {
    switch (level) {
      case CompletionLevel.noData:
        return Center(
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
        );
      case CompletionLevel.none:
        return Center(
          child: Icon(Icons.close, color: Constants.getLevelColor(level)),
        );
      default:
        return FutureBuilder<Image?>(
          future: StampManager.getStampImage(level),
          builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
            if (snapshot.hasData) {
              return StampView(
                level: level,
                image: snapshot.data ?? StampManager.getDefaultStampImage(level),
              );
            } else {
              return Container();
            }
          }
        );
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
          children: [
            Text("$day"),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.getLevelColor(level).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: _buildStamp(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
