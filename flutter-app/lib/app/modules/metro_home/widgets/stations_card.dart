import 'package:cairo_metro_flutter/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_icon.dart';
import '../../../../core/shared/widgets/custom_radio_button.dart';
import 'custom_drop_down_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StationsCard extends StatelessWidget {
  StationsCard({
    super.key,
    required this.nearestStationDropDownKey,
  });

  final MetroController metroController = Get.find();
  final isSwap = false.obs;
  final startCont = TextEditingController();
  final endCont = TextEditingController();
  final temp = ''.obs;
  final isGetNearestStation = false.obs;
  final GlobalKey nearestStationDropDownKey;
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
      shadowColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomDropDownMenu(
                      isSwap: isSwap,
                      startCont: startCont,
                      hint: AppLocalizations.of(context)!.startStation),
                ),
                Showcase(
                  key: nearestStationDropDownKey,
                  description:
                      AppLocalizations.of(context)!.nearestStationDescription,
                  child: CustomIcon(
                    icon: Icons.location_on_outlined,
                    onPressed: () {
                      metroController.getNearestStation(true.obs);
                    },
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                if (startCont.text.isNotEmpty || endCont.text.isNotEmpty) {
                  swapStation();
                }
              },
              icon: CustomIcon(icon: Icons.swap_vert_circle_outlined),
            ),
            CustomDropDownMenu(
                isStart: false,
                isSwap: isSwap,
                endCont: endCont,
                hint: AppLocalizations.of(context)!.arriveStation),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomRadioButton(
                    text: AppLocalizations.of(context)!.lessStation,
                    value: 0,
                    groupValue: metroController.selectedTransfers,
                    onChanged: (newValue) =>
                        metroController.updateSelectedTransfer(newValue),
                  ),
                  CustomRadioButton(
                    text: AppLocalizations.of(context)!.lessTransfer,
                    value: 1,
                    groupValue: metroController.selectedTransfers,
                    onChanged: (newValue) =>
                        metroController.updateSelectedTransfer(newValue),
                  ),
                ],
              ),
            ),
            CustomButton(
              onPressed: () {
                final startText = startCont.text.toLowerCase().trim();
                final endText = endCont.text.toLowerCase().trim();

                final startInStations =
                    metroController.stationsNames.contains(startText);
                final endInStations =
                    metroController.stationsNames.contains(endText);

                // Validation logic
                if (startText.isEmpty || endText.isEmpty) {
                  Get.snackbar(
                    AppLocalizations.of(context)!.missingInput,
                    AppLocalizations.of(context)!.missingInputMessage,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (!startInStations || !endInStations) {
                  Get.snackbar(
                    AppLocalizations.of(context)!.invalidStation,
                    AppLocalizations.of(context)!.invalidStationMessage,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (startText == endText) {
                  Get.snackbar(
                    AppLocalizations.of(context)!.sameStation,
                    AppLocalizations.of(context)!.sameStationMessage,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Set the stations after successful validation
                metroController.startStation.value = startText;
                metroController.endStation.value = endText;

                // Navigate to the next screen
                Get.toNamed('/MetroRouteScreen');
              },
              btnName: AppLocalizations.of(context)!.start,
            ),
          ],
        ),
      ),
    );
  }

  void swapStation() {
    temp.value = startCont.text;
    startCont.text = endCont.text;
    endCont.text = temp.value;
    isSwap.value = true;
  }
}
