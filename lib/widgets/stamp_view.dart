import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/utils/stamp_manager.dart';
import 'package:nichinichi/painters/stamp.dart';

class StampView extends StatelessWidget {

  final CompletionLevel level;

  const StampView({ super.key, required this.level });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: StampManager.getStampImage(level),
      builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
        if (snapshot.hasData) {
          ImageProvider image = snapshot.data ?? StampManager.getDefaultStampImage(level);
          return CustomPaint(
            painter: Stamp(color: Constants.getLevelColor(level)),
            child: Container(
              constraints: BoxConstraints(
                minWidth: 60
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CircleAvatar(backgroundImage: image),
            ),
          );
        } else {
          return Text("loading...");
        }
      }
    );
  }
}
