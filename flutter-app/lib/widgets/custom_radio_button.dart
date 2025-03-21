import 'package:cairo_metro_flutter/widgets/custom_icon.dart';
import 'package:cairo_metro_flutter/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final String value;
  final RxString groupValue;
  final Function(String)? onChanged; // إضافة `onChanged` كـ callback

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
            onChanged!(value); // استدعاء `onChanged` إذا تم تمريره
          }
        },
        child: Row(
          children: [
            Container(
              width: (MediaQuery.sizeOf(context).width * 0.05),
              height: (MediaQuery.sizeOf(context).height * 0.05),
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
            const SizedBox(width: 8), // إضافة مسافة بين الدائرة والنص
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
