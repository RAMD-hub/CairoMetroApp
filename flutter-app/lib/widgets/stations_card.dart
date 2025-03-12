import 'package:cairo_metro_flutter/widgets/custom_auto_complete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/metro_controller.dart';
import '../screens/metro_routes.dart';
import 'custom_button.dart';
import 'custom_icon.dart';
import 'custom_radio_button.dart';

class StationsCard extends StatelessWidget {
  StationsCard({
    super.key,
    required this.selectedTransfers,
    required this.stations,
  });

  final MetroController metroController = Get.put(MetroController());
  final RxString selectedTransfers;
  final List<String> stations;

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
            CustomAutoComplete(isStart: true),
            CustomIcon(icon: Icons.swap_vert_circle_outlined),
            CustomAutoComplete(isStart: false),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomRadioButton(
                  text: 'Less Stations',
                  value: 'Less Stations',
                  groupValue: selectedTransfers,
                ),
                CustomRadioButton(
                  text: 'Less Transfer',
                  value: 'Less Transfer',
                  groupValue: selectedTransfers,
                ),
              ],
            ),
            CustomButton(
              onPressed: () {
                if (metroController.startStation.value.isEmpty ||
                    metroController.endStation.value.isEmpty ||
                    metroController.isSameStation().value) {
                  Get.snackbar(
                    'Error',
                    'Please fill in both station correctly.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                Get.to(() => MetroRouteScreen(
                      stations: stations,
                    ));
              },
              btnName: 'Start',
            )
          ],
        ),
      ),
    );
  }
}
