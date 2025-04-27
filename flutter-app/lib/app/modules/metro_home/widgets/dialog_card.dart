import 'package:cairo_metro_flutter/core/controllers/metro_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/shared/widgets/circle_shape.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/line_shape.dart';

class DialogCard extends StatelessWidget {
  final MetroController metroController = Get.find();

  DialogCard({
    super.key,
  });

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
                Obx(() {
                  return TextButton(
                      onPressed: metroController.userSelectedPath.isNotEmpty
                          ? () {
                              Get.toNamed(
                                '/MetroTripProgress',
                              );
                            }
                          : null,
                      child: CustomText(
                        text: 'View All',
                        txtColor: kPrimaryColor,
                      ));
                })
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
                      circleColor: kPrimaryColor,
                    ),
                    LineShape(),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 11,
                    children: [
                      Obx(() {
                        return CustomText(
                          text: metroController.startStation.value.isNotEmpty
                              ? '${metroController.startStation.value} => start station'
                              : '',
                          txtColor: Colors.white70,
                          txtFontWeight: FontWeight.bold,
                        );
                      }),
                      Obx(() {
                        return CustomText(
                          text: metroController.currentStation.value.isNotEmpty
                              ? '${metroController.currentStation.value} => You are here now'
                              : '',
                          txtFontWeight: FontWeight.bold,
                          txtColor: kPrimaryColor,
                        );
                      }),
                      Obx(() {
                        return CustomText(
                          text: metroController.endStation.value.isNotEmpty
                              ? '${metroController.endStation.value} => arrival station'
                              : '',
                          txtColor: Colors.white70,
                          txtFontWeight: FontWeight.bold,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
