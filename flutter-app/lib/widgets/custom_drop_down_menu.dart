import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../controllers/metro_controller.dart';

class CustomDropDownMenu extends StatelessWidget {
  CustomDropDownMenu({
    super.key,
    this.isStart = true,
    required this.isSwap,
  });

  final bool isStart;
  final RxBool isSwap;
  final MetroController metroController = Get.find();
  final FocusNode dropMenuFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownMenu<String>(
        width: Get.width,
        hintText: 'Please Selected Station',
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
          dropMenuFocusNode.unfocus();
        },
        enableFilter: true,
        requestFocusOnTap: true,
        focusNode: dropMenuFocusNode,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 2,
            ),
          ),
        ),
        menuHeight: Get.height * 0.25,
        menuStyle: MenuStyle(
          alignment: Alignment.bottomCenter,
          elevation: WidgetStatePropertyAll(2),
          side: WidgetStatePropertyAll(
            BorderSide(color: kPrimaryColor, width: 2),
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
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
