import 'package:flutter/material.dart';

import '../widgets/circle_shape.dart';
import '../widgets/custom_text.dart';
import '../widgets/line_shape.dart';

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
              if (!isFirst)
                LineShape(
                  color: isInterSection ? Colors.red.shade600 : Colors.orange,
                ),
              CircleShape(
                circleColor: isInterSection ? Colors.red.shade600 : Colors.grey,
              ),
              if (!isLast)
                LineShape(
                  color: isInterSection ? Colors.red.shade600 : Colors.orange,
                ),
            ],
          ),
          Expanded(
            child: CustomText(
              text: isInterSection
                  ? '$stationName => Exchanged Station.'
                  : stationName,
              txtFontWeight: isFirst || isLast || isInterSection
                  ? FontWeight.bold
                  : FontWeight.normal,
              txtColor: isFirst || isLast
                  ? Colors.orange
                  : isInterSection
                      ? Colors.red.shade600
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
