import 'package:flutter/material.dart';

import 'custom_icon.dart';
import 'custom_text.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.suffixIcon = Icons.train,
    required this.hint,
    required this.textController,
    this.onEditingComplete,
    this.focusNode,
  });
  final IconData suffixIcon;
  final String hint;
  final TextEditingController textController;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
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
