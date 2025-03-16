import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import 'custom_text.dart';

class CustomDropDownMenu extends StatelessWidget {
  CustomDropDownMenu({
    super.key,
    this.isStart = true,
  });
  final bool isStart;
  final MetroController metroController = Get.put(MetroController());
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: double.infinity,
      label: CustomText(text: 'Please Selected Station'),
      menuHeight: 200,
      onSelected: (station) {
        if (station != null && isStart) {
          metroController.startStation.value = station;
        }
        station != null && isStart
            ? metroController.startStation.value = station
            : (station != null && !isStart)
                ? metroController.endStation.value = station
                : '';
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
    );
  }
}
