import 'package:flutter/material.dart';

import 'custom_icon.dart';
import 'custom_text.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.suffixIcon = Icons.train,
    required this.hint,
  });
  final IconData suffixIcon;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: CustomIcon(icon: suffixIcon),
        label: CustomText(
          text: hint,
          txtColor: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
