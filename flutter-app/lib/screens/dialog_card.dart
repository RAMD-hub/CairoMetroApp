import 'package:cairo_metro_flutter/widgets/line_shape.dart';
import 'package:flutter/material.dart';
import '../widgets/circle_shape.dart';
import '../widgets/custom_text.dart';

class DialogCard extends StatelessWidget {
  final bool isCurrent;

  DialogCard({
    super.key,
    this.isCurrent = false,
  });
  final List<String> path = [];
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
                    onPressed: () {
                      // Get.to(MetroTripProgress());
                    },
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
                      text: path.isNotEmpty ? path[0] : '',
                      txtColor: Colors.black,
                    ),
                    CustomText(
                      text: path.isNotEmpty ? path[path.length ~/ 2] : '',
                      txtFontWeight: FontWeight.bold,
                      txtColor: Color(0xFFFEA613),
                    ),
                    CustomText(
                      text: path.isNotEmpty ? path[path.length] : '',
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
