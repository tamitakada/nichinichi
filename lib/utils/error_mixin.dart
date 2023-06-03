import 'abstract_classes/overlay_manager.dart';
import 'package:nichinichi/constants.dart';
import 'package:nichinichi/global_widgets/error_view.dart';
import 'package:flutter/material.dart';

mixin ErrorMixin {

  void showError(OverlayManager manager, ErrorType type) {
    if (!manager.isOverlayOpen()) {
      manager.updateOverlay(ErrorView(close: manager.closeOverlay, type: type), Colors.black45);
    }
  }

}