import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constant.dart';
import '../circle_shape.dart';
import '../custom_text.dart';
import '../line_shape.dart';

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
      color: kOpacityCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Column(
            children: [
              if (!isFirst && !isLast)
                LineShape(
                  color: isInterSection ? kAlertImportantColor : kPrimaryColor,
                ),
              CircleShape(
                circleColor: isInterSection
                    ? kAlertImportantColor
                    : isLast || isFirst
                        ? kPrimaryColor
                        : Colors.white,
              ),
              if (!isLast && !isFirst)
                LineShape(
                  color: isInterSection ? kAlertImportantColor : kPrimaryColor,
                ),
            ],
          ),
          Expanded(
            child: CustomText(
              text: isInterSection
                  ? '$stationName => Exchanged Station.'
                  : stationName,
              txtFontWeight: isFirst || isLast || isInterSection
                  ? FontWeight.w700
                  : FontWeight.normal,
              txtFontSize: isFirst || isLast || isInterSection
                  ? (Get.width * 0.08).clamp(12.0, 18.0)
                  : (Get.width * 0.45).clamp(12.0, 18.0),
              txtColor: isFirst || isLast
                  ? kPrimaryColor
                  : isInterSection
                      ? kAlertImportantColor
                      : kSecondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
