import 'package:flutter/material.dart';

class CustomOnboardingImage extends StatelessWidget {
  const CustomOnboardingImage({
    super.key,
    required this.imagePath,
  });
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Image.asset(imagePath, height: 250),
    );
  }
}
