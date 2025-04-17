import 'package:flutter/material.dart';

class CircleShape extends StatelessWidget {
  const CircleShape({
    super.key,
    this.circleColor = Colors.white,
  });

  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: circleColor, // لون الدائرة
        shape: BoxShape.circle,
      ),
    );
  }
}
