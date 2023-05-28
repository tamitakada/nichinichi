import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class Stamp extends CustomPainter {

  final Color color;
  final int vertexCount;

  Stamp({ required this.color, this.vertexCount = 10 });

  Offset _getRotatedPoint(double angle, Offset point, Offset center) {
    double x = (point.dx - center.dx) * cos(angle) - (point.dy - center.dy) * sin(angle) + center.dx;
    double y = (point.dx - center.dx) * sin(angle) + (point.dy - center.dy) * cos(angle) + center.dy;
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double theta = (2 * pi) / vertexCount;
    double offset = size.width / 2 * tan(theta / 2);

    Offset initialMidpoint = Offset(size.width / 2, -6);
    Offset initialMidpoint1 = Offset(size.width / 2 - 4, -2);
    Offset initialMidpoint2 = Offset(size.width / 2 + 4, -2);
    Offset initialEndpoint = Offset(size.width / 2 + offset, 0);

    Path path = Path()..moveTo(size.width / 2 - offset, 0);

    for (int i = 0; i < vertexCount; i++) {
      Offset midpoint = _getRotatedPoint(theta * i, initialMidpoint, size.center(const Offset(0, 0)));
      Offset midpoint1 = _getRotatedPoint(theta * i, initialMidpoint1, size.center(const Offset(0, 0)));
      Offset midpoint2 = _getRotatedPoint(theta * i, initialMidpoint2, size.center(const Offset(0, 0)));
      Offset endpoint = _getRotatedPoint(theta * i, initialEndpoint, size.center(const Offset(0, 0)));

      path.lineTo(midpoint1.dx, midpoint1.dy);
      path.conicTo(midpoint.dx, midpoint.dy, midpoint2.dx, midpoint2.dy, 2);
      path.lineTo(endpoint.dx, endpoint.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}