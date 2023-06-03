import 'package:flutter/material.dart';

abstract class OverlayManager {
  void updateOverlay(Widget? overlay, [Color? color]);
  void closeOverlay();
  bool isOverlayOpen();
}