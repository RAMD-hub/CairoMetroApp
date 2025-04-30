import 'package:cairo_metro_flutter/core/controllers/metro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/shared/widgets/circle_shape.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/line_shape.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogCard extends StatelessWidget {
  final MetroController metroController = Get.find();

  DialogCard({
    super.key,
    required this.currentStation,
    required this.nextStation,
    required this.previousStation,
  });

  final RxString currentStation;
  final RxString nextStation;
  final RxString previousStation;

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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 22,
                ),
                CustomText(
                  text: AppLocalizations.of(context)!.stations,
                  txtColor: kPrimaryColor,
                ),
                Spacer(),
                TextButton(
                    onPressed: () {
                      Get.toNamed(
                        '/MetroTripProgress',
                      );
                    },
                    child: CustomText(
                      text: AppLocalizations.of(context)!.viewAll,
                      txtColor: kPrimaryColor,
                    )),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    LineShape(),
                    CircleShape(
                      circleColor: kPrimaryColor,
                    ),
                    LineShape(),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 11,
                    children: [
                      Obx(() {
                        return CustomText(
                          text: previousStation.value.isNotEmpty
                              ? AppLocalizations.of(context)!.startStationLabel(
                                  metroController.previousStation.value)
                              : '',
                          txtColor: Colors.white70,
                          txtFontWeight: FontWeight.bold,
                        );
                      }),
                      Obx(() {
                        return CustomText(
                          text: currentStation.value.isNotEmpty
                              ? AppLocalizations.of(context)!
                                  .currentStationLabel(currentStation.value)
                              : '',
                          txtFontWeight: FontWeight.bold,
                          txtColor: kPrimaryColor,
                        );
                      }),
                      Obx(() {
                        return CustomText(
                          text: nextStation.value.isNotEmpty
                              ? AppLocalizations.of(context)!
                                  .arrivalStationLabel(
                                      metroController.nextStation.value)
                              : '',
                          txtColor: Colors.white70,
                          txtFontWeight: FontWeight.bold,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
