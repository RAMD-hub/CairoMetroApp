import 'package:flutter/material.dart';

import '../constant.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.btnBackgroundColor = kPrimaryColor,
    required this.btnName,
    this.txtColor = Colors.white,
  });
  final Function() onPressed;
  final Color btnBackgroundColor;
  final Color txtColor;
  final String btnName;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnBackgroundColor,
        minimumSize: Size(double.infinity, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: CustomText(
        text: btnName,
        txtColor: txtColor,
      ),
    );
  }
}
