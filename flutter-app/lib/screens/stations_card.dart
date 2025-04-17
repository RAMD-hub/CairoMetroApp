import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_drop_down_menu.dart';
import '../widgets/custom_icon.dart';
import '../widgets/custom_radio_button.dart';

class StationsCard extends StatelessWidget {
  StationsCard({
    super.key,
  });

  final MetroController metroController = Get.find();
  final isSwap = false.obs;
  final startCont = TextEditingController();
  final endCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      shadowColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            CustomDropDownMenu(
              isSwap: isSwap,
              startCont: startCont,
            ),
            IconButton(
              onPressed: () {
                metroController.startStation.value = startCont.text;
                metroController.endStation.value = endCont.text;
                metroController.swapStations();
                isSwap.value = true;
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
}
