import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomDetailsCard extends StatelessWidget {
  const CustomDetailsCard({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: CustomText(text: text)),
        ),
      ),
    );
  }
}
