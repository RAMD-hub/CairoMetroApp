import 'package:flutter/material.dart';

class MetroHome extends StatelessWidget {
  const MetroHome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFFFEA613),
                size: screenWidth * 0.07,
              ),
              Icon(
                Icons.language,
                color: Color(0xFFFEA613),
                size: screenWidth * 0.07,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
