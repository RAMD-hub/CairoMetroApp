import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.txtFontSize = 0,
    this.txtColor = Colors.black,
    this.txtFontWeight = FontWeight.normal,
    this.txtLetterSpacing,
  });
  final String text;
  final double txtFontSize;
  final double? txtLetterSpacing;
  final Color txtColor;
  final FontWeight txtFontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: txtFontSize == 0
            ? (Get.width * 0.045).clamp(12.0, 18.0)
            : txtFontSize,
        color: txtColor,
        fontWeight: txtFontWeight,
        letterSpacing: txtLetterSpacing,
      ),
    );
  }
}
