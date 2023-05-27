import 'package:flutter/material.dart';
import 'dart:math';

class HalfBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width - 10, 0),
      paint
    );

    canvas.drawArc(Rect.fromCenter(center: Offset(size.width - 10, 10), width: 20, height: 20), 3 * pi/2, pi/2, false, paint);

    canvas.drawLine(
      Offset(size.width, 10),
      Offset(size.width, size.height),
      paint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}