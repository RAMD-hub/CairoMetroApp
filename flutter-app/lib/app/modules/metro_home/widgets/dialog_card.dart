import 'package:cairo_metro_flutter/app/shared/widgets/line_shape.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constant.dart';
import '../../../shared/widgets/circle_shape.dart';
import '../../../shared/widgets/custom_text.dart';

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
      color: kOpacityCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
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
                  txtColor: kPrimaryColor,
                ),
                Spacer(),
                TextButton(
                    onPressed: () {
                      // Get.to(MetroTripProgress());
                    },
                    child: CustomText(
                      text: 'View All',
                      txtColor: kPrimaryColor,
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
                      circleColor: isCurrent ? kPrimaryColor : Colors.grey,
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
                      txtColor: kPrimaryColor,
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
