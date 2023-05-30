import 'package:flutter/material.dart';

extension ColorConverter on Color {
  static Color parse(String hexColor) {
    try { return Color(int.parse(hexColor, radix: 16) + 0xFF000000); }
    catch (e) { return Colors.white; }
  }

  String toHex() {
    return value.toRadixString(16);
  }
}