import 'package:flutter/material.dart';

import '../../../core/constants/constant.dart';

class CustomDetailsCard extends StatelessWidget {
  const CustomDetailsCard({
    super.key,
    required this.text,
    this.width,
  });
  final Widget text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kOpacityCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Container(
        width: width,
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Center(child: text),
      ),
    );
  }
}
