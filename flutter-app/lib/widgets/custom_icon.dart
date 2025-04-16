import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    this.color = kPrimaryColor,
    required this.icon,
    this.iconSize = 0,
  });

  final Color color;
  final IconData icon;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: iconSize == 0 ? (Get.width * 0.07).clamp(14.0, 36.0) : iconSize,
    );
  }
}
