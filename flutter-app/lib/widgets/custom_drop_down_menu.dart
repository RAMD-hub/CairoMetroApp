import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../controllers/metro_controller.dart';
import 'custom_text.dart';

class CustomDropDownMenu extends StatelessWidget {
  CustomDropDownMenu({
    super.key,
    this.isStart = true,
    required this.isSwap,
    this.startCont,
    this.endCont,
  });

  final bool isStart;
  final TextEditingController? startCont;
  final TextEditingController? endCont;
  final RxBool isSwap;
  final MetroController metroController = Get.find();
  final FocusNode dropMenuFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownMenu<String>(
        width: Get.width,
        controller: isStart ? startCont : endCont,
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
          filled: true,
          fillColor: kTextFieldFillColor,
          hintStyle: TextStyle(
            color: kHintTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.8,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: kPrimaryColor.withOpacity(0.5),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: kPrimaryColor,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        menuHeight: Get.height * 0.25,
        textStyle: TextStyle(
          color: kSecondaryTextColor,
        ),
        menuStyle: MenuStyle(
          alignment: Alignment.bottomCenter,
          elevation: WidgetStatePropertyAll(8),
          backgroundColor:
              WidgetStatePropertyAll(Colors.black.withOpacity(0.5)),
          shadowColor: WidgetStatePropertyAll(kPrimaryColor.withOpacity(0.3)),
          side: WidgetStatePropertyAll(
            BorderSide(color: kPrimaryColor, width: 1.5),
          ),
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          visualDensity: VisualDensity.compact,
        ),
        dropdownMenuEntries: [
          for (var stationName in metroController.stationsNames)
            DropdownMenuEntry<String>(
              value: stationName,
              labelWidget: CustomText(
                text: stationName,
                txtColor: kSecondaryTextColor.withOpacity(0.7),
                txtFontWeight: FontWeight.w600,
                txtFontSize: 16,
              ),
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
