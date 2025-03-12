import 'package:flutter/material.dart';

import 'circle_shape.dart';
import 'custom_text.dart';
import 'line_shape.dart';

class StationTile extends StatelessWidget {
  final String stationName;
  final bool isFirst;
  final bool isLast;
  final bool isInterSection;

  const StationTile({
    super.key,
    required this.stationName,
    required this.isFirst,
    required this.isLast,
    required this.isInterSection,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Column(
            children: [
              if (!isFirst) LineShape(),
              CircleShape(
                circleColor: Colors.grey,
              ),
              if (!isLast) LineShape(),
            ],
          ),
          CustomText(
            text: stationName,
            txtFontWeight: isFirst || isLast || isInterSection
                ? FontWeight.bold
                : FontWeight.normal,
            txtColor: isFirst || isLast
                ? Colors.orange
                : isInterSection
                    ? Colors.red
                    : Colors.black,
          ),
        ],
      ),
    );
  }
}
