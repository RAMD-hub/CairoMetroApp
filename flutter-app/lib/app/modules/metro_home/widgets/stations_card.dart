import 'package:cairo_metro_flutter/core/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_icon.dart';
import '../../../../core/shared/widgets/custom_radio_button.dart';
import 'custom_drop_down_menu.dart';

class StationsCard extends StatelessWidget {
  StationsCard({
    super.key,
  });

  final MetroController metroController = Get.find();
  final isSwap = false.obs;
  final startCont = TextEditingController();
  final endCont = TextEditingController();
  final temp = ''.obs;
  final isGetNearestStation = false.obs;
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
          spacing: 16,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomDropDownMenu(
                    isSwap: isSwap,
                    startCont: startCont,
                  ),
                ),
                CustomIcon(
                  icon: Icons.location_on_outlined,
                  onPressed: () {
                    metroController.getNearestStation(true.obs);
                  },
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomRadioButton(
                  text: 'Less Stations',
                  value: 'Less Stations',
                  groupValue: metroController.selectedTransfers,
                  onChanged: (newValue) =>
                      metroController.updateSelectedTransfer(newValue),
                ),
                CustomRadioButton(
                  text: 'Less Transfer',
                  value: 'Less Transfer',
                  groupValue: metroController.selectedTransfers,
                  onChanged: (newValue) =>
                      metroController.updateSelectedTransfer(newValue),
                ),
              ],
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
                    'Missing Input',
                    'Please enter both the start and end stations.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (!startInStations || !endInStations) {
                  Get.snackbar(
                    'Invalid Station',
                    'One or both stations do not exist. Please check the station names.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (startText == endText) {
                  Get.snackbar(
                    'Same Station',
                    'Start and End stations cannot be the same.',
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
              btnName: 'Start',
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
