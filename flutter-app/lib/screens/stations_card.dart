import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import 'metro_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_drop_down_menu.dart';
import '../widgets/custom_icon.dart';
import '../widgets/custom_radio_button.dart';

class StationsCard extends StatelessWidget {
  StationsCard({
    super.key,
    required this.selectedTransfers,
  });

  final MetroController metroController = Get.put(MetroController());
  final RxString selectedTransfers;

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
            CustomDropDownMenu(),
            CustomIcon(icon: Icons.swap_vert_circle_outlined),
            CustomDropDownMenu(
              isStart: false,
            ),
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
                final RxList<List<String>> paths =
                    selectedTransfers.value == 'Less Stations'
                        ? metroController.allPaths
                        : metroController.allPathsByExchanged;
                if (metroController.startStation.value.isEmpty ||
                    metroController.endStation.value.isEmpty ||
                    metroController.startStation ==
                        metroController.endStation ||
                    selectedTransfers.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please fill in both station correctly.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                Get.to(MetroRouteScreen(), arguments: paths);
              },
              btnName: 'Start',
            ),
          ],
        ),
      ),
    );
  }
}
