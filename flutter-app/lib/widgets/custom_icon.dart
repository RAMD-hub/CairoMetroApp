import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    this.color = const Color(0xFFFEA613),
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
      size: iconSize == 0
          ? (MediaQuery.sizeOf(context).width * 0.07).clamp(14.0, 36.0)
          : iconSize,
    );
  }
}
