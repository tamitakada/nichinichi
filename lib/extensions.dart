import 'dart:ui';

extension ColorConverter on Color {
  static Color parse(String hexColor) {
    return Color(int.parse(hexColor, radix: 16) + 0xFF000000);
  }
}