import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constant.dart';
import 'custom_text.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final String value;
  final RxString groupValue;
  final Function(String)? onChanged;

  const CustomRadioButton({
    super.key,
    required this.text,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected = (groupValue.value == value);

      return GestureDetector(
        onTap: () {
          groupValue.value = value;
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor, width: 2),
                color: isSelected ? kPrimaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            SizedBox(width: 8),
            CustomText(
              text: text,
              txtColor: isSelected ? kPrimaryColor : kSecondaryTextColor,
            ),
          ],
        ),
      );
    });
  }
}
