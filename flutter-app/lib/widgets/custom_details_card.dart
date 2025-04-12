import 'package:flutter/material.dart';

class CustomDetailsCard extends StatelessWidget {
  const CustomDetailsCard({
    super.key,
    required this.text,
  });
  final Widget text;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: text),
      ),
    );
  }
}
