import 'package:cairo_metro_flutter/core/controllers/metro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/shared/widgets/circle_shape.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/line_shape.dart';

class StationTile extends StatelessWidget {
  final String stationName;
  final bool isFirst;
  final bool isLast;
  final bool isInterSection;
  StationTile({
    super.key,
    required this.stationName,
    required this.isFirst,
    required this.isLast,
    required this.isInterSection,
  });
  final MetroController metroController = Get.find();
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
                  ? AppLocalizations.of(context)!.exchange(stationName)
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
