import 'package:cairo_metro_flutter/core/algorithms/exchange_stations.dart';
import 'package:cairo_metro_flutter/core/controllers/metro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/shared/widgets/circle_shape.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/line_shape.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackStationTile extends StatelessWidget {
  final String stationName;
  final RxBool isFirst;
  final RxBool isLast;
  final RxBool isInterSection;

  TrackStationTile({
    super.key,
    required this.stationName,
    required this.isFirst,
    required this.isLast,
    required this.isInterSection,
  });

  final MetroController metroController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isCurrent = metroController.currentStation;
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
              if (!isFirst.value && !isLast.value)
                LineShape(
                  color: isInterSection.value
                      ? kAlertImportantColor
                      : kPrimaryColor,
                ),
              Obx(() {
                final isCurrent = metroController.currentStation;
                return CircleShape(
                  circleColor: isInterSection.value
                      ? kAlertImportantColor
                      : isLast.value ||
                              isFirst.value ||
                              stationName == isCurrent.value
                          ? kPrimaryColor
                          : Colors.white,
                );
              }),
              if (!isLast.value && !isFirst.value)
                LineShape(
                  color: isInterSection.value
                      ? kAlertImportantColor
                      : kPrimaryColor,
                ),
            ],
          ),
          Expanded(
            child: Obx(() {
              final isCurrent = metroController.currentStation;
              return CustomText(
                text: isInterSection.value
                    ? AppLocalizations.of(context)!.exchange(stationName)
                    : stationName,
                txtFontWeight: isFirst.value ||
                        isLast.value ||
                        isInterSection.value ||
                        stationName == isCurrent.value
                    ? FontWeight.w700
                    : FontWeight.normal,
                txtFontSize: isFirst.value ||
                        isLast.value ||
                        isInterSection.value ||
                        stationName == isCurrent.value
                    ? (Get.width * 0.08).clamp(12.0, 18.0)
                    : (Get.width * 0.45).clamp(12.0, 18.0),
                txtColor: isFirst.value ||
                        isLast.value ||
                        stationName == isCurrent.value
                    ? kPrimaryColor
                    : isInterSection.value
                        ? kAlertImportantColor
                        : kSecondaryTextColor,
              );
            }),
          ),
        ],
      ),
    );
  }
}
