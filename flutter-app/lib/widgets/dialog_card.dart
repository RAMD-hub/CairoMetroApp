import 'package:cairo_metro_flutter/widgets/line_shape.dart';
import 'package:flutter/material.dart';

import 'circle_shape.dart';
import 'custom_text.dart';

class DialogCard extends StatelessWidget {
  final String previousStation;
  final String currentStation;
  final String nextStation;
  final bool isCurrent;

  const DialogCard({
    super.key,
    required this.previousStation,
    required this.currentStation,
    required this.nextStation,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 22,
                ),
                CustomText(
                  text: 'Stations',
                  txtColor: Color(0xFFFEA613),
                ),
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: CustomText(
                      text: 'View All',
                      txtColor: Color(0xFFFEA613),
                    ))
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    LineShape(),
                    CircleShape(
                      circleColor: isCurrent ? Colors.orange : Colors.grey,
                    ),
                    LineShape(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 11,
                  children: [
                    CustomText(
                      text: previousStation,
                      txtColor: Colors.black,
                    ),
                    CustomText(
                      text: currentStation,
                      txtFontWeight: FontWeight.bold,
                      txtColor: Color(0xFFFEA613),
                    ),
                    CustomText(
                      text: nextStation,
                      txtColor: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
