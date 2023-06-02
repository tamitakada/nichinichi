import 'package:flutter/material.dart';

abstract class OverlayManager {

  void updateOverlay(Widget? overlay);
  bool isOverlayOpen();

}