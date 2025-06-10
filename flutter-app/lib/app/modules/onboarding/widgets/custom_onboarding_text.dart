import 'package:flutter/material.dart';

enum CustomTextType {
  title,
  body,
  custom,
}

class CustomOnboardingText extends StatelessWidget {
  final String text;
  final CustomTextType type;
  final TextStyle? customStyle;
  final TextAlign textAlign;

  const CustomOnboardingText({
    super.key,
    required this.text,
    this.type = CustomTextType.body,
    this.customStyle,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    switch (type) {
      case CustomTextType.title:
        style = const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );
        break;
      case CustomTextType.body:
        style = const TextStyle(
          fontSize: 16,
          color: Colors.white,
        );
        break;
      case CustomTextType.custom:
        style = customStyle ??
            const TextStyle(
              fontSize: 16,
              color: Colors.white,
            );
        break;
    }

    return Text(
      text,
      textAlign: textAlign,
      style: style,
    );
  }
}
