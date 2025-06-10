import 'package:flutter/material.dart';

/// Scrolls the provided controller to the top (position 0)
/// with a smooth animation.
///
/// [controller] - the ScrollController attached to a scroll view.
/// [duration] - duration of the scroll animation.
/// [curve] - animation curve (default is [Curves.easeInOut]).
void customScrollToTop(
  ScrollController controller, {
  Duration duration = const Duration(milliseconds: 300),
  Curve curve = Curves.easeInOut,
}) {
  if (controller.hasClients) {
    controller.animateTo(
      0,
      duration: duration,
      curve: curve,
    );
  }
}
