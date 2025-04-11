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
  });

  final MetroController metroController = Get.find();
  final isSwap = false.obs;

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
            ),
            Obx(() {
              return IconButton(
                onPressed: metroController.startStation.value.isNotEmpty &&
                        metroController.endStation.value.isNotEmpty
                    ? () {
                        metroController.swapStations();
                        isSwap.value = true;
                      }
                    : null,
                icon: CustomIcon(icon: Icons.swap_vert_circle_outlined),
              );
            }),
            CustomDropDownMenu(
              isStart: false,
              isSwap: isSwap,
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
                final RxList<List<String>> paths =
                    metroController.selectedTransfers.value == 'Less Stations'
                        ? metroController.allPaths
                        : metroController.allPathsByExchangedNum;

                if (metroController.startStation.value.isEmpty ||
                    metroController.endStation.value.isEmpty ||
                    metroController.startStation ==
                        metroController.endStation) {
                  Get.snackbar(
                    'Error',
                    'Please fill in both station correctly.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                Get.toNamed('/MetroRouteScreen', arguments: paths);
              },
              btnName: 'Start',
            ),
          ],
        ),
      ),
    );
  }
}
