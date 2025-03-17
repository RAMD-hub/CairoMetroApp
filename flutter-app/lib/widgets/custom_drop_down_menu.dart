import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import 'custom_text.dart';

class CustomDropDownMenu extends StatelessWidget {
  CustomDropDownMenu({
    super.key,
    this.isStart = true,
    required this.isSwap,
  });

  final bool isStart;
  final RxBool isSwap;
  final MetroController metroController = Get.put(MetroController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownMenu<String>(
        width: double.infinity,
        label: CustomText(text: 'Please Selected Station'),
        menuHeight: 200,
        onSelected: (station) {
          station != null && isStart
              ? metroController.startStation.value = station
              : (station != null && !isStart)
                  ? metroController.endStation.value = station
                  : '';
          isSwap.value && isStart
              ? station = metroController.startStation.value
              : isSwap.value == true && !isStart
                  ? station = metroController.endStation.value
                  : null;
        },
        enableFilter: true,
        requestFocusOnTap: true,
        dropdownMenuEntries: [
          for (var stationName in metroController.stationsNames)
            DropdownMenuEntry<String>(
              value: stationName,
              label: stationName,
            ),
        ],
        initialSelection: isStart
            ? metroController.startStation.value
            : metroController.endStation.value,
      );
    });
  }
}
