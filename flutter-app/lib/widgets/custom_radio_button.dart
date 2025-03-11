import 'package:cairo_metro_flutter/widgets/custom_icon.dart';
import 'package:cairo_metro_flutter/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final String value;
  final RxString groupValue;

  const CustomRadioButton({
    super.key,
    required this.text,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected = (groupValue.value == value);

      return GestureDetector(
        onTap: () {
          groupValue.value = value;
        },
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: (MediaQuery.sizeOf(context).width * 0.04),
              height: (MediaQuery.sizeOf(context).height * 0.04),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFFEA613), width: 2),
                color: isSelected ? Color(0xFFFEA613) : Colors.transparent,
              ),
              child: isSelected
                  ? CustomIcon(
                      icon: Icons.check,
                      color: Colors.white,
                      iconSize: 16,
                    )
                  : null,
            ),
            CustomText(
              text: text,
              txtColor: isSelected ? Color(0xFFFEA613) : Colors.black,
            )
          ],
        ),
      );
    });
  }
}
