import 'package:flutter/material.dart';
import 'package:nichinichi/painters/half_border.dart';

class BaseComponent extends StatelessWidget {

  final Widget child;

  const BaseComponent({ super.key, required this.child });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: HalfBorder(),
          );
        }),
        child,
      ]
    );
  }
}
