import 'package:flutter/material.dart';

import 'package:nichinichi/global_widgets/confirmation_view.dart';
import 'abstract_classes/overlay_manager.dart';


mixin ConfirmationMixin {

  void showConfirmation(
    String message,
    OverlayManager manager,
    void Function() onConfirm,
    [void Function()? onCancel]
  ) {
    if (!manager.isOverlayOpen()) {
      manager.updateOverlay(
        ConfirmationView(
          message: message,
          onConfirm: () {
            manager.closeOverlay();
            onConfirm();
          },
          onCancel: onCancel ?? manager.closeOverlay,
        ), Colors.black45
      );
    }
  }

}