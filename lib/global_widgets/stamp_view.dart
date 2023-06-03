import 'package:flutter/material.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/data_management/stamp_manager.dart';


class StampView extends StatelessWidget {

  final CompletionLevel level;
  final Image image;

  const StampView({ super.key, required this.level, required this.image });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          image,
          Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Constants.getLevelColor(level),
                width: 3
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          )
        ],
      ),
    );
  }
}
