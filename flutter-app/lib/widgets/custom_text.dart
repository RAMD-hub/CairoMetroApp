import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.txtFontSize = 0,
    this.txtColor = Colors.black,
    this.txtFontWeight = FontWeight.normal,
  });
  final String text;
  final double txtFontSize;
  final Color txtColor;
  final FontWeight txtFontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: txtFontSize == 0
            ? (MediaQuery.sizeOf(context).width * 0.034).clamp(12.0, 18.0)
            : txtFontSize,
        color: txtColor,
        fontWeight: txtFontWeight,
      ),
    );
  }
}
