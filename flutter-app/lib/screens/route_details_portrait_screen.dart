import 'package:cairo_metro_flutter/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_details_card.dart';
import '../widgets/custom_text.dart';
import 'station_tile_list_view.dart';

class RouteDetailsPortraitScreen extends StatelessWidget {
  RouteDetailsPortraitScreen({
    super.key,
    required this.paths,
    this.isMetroRouteScreen = true,
    this.btnBackgroundColor = const Color(0xFFFEA613),
    required this.onPressedBigNext,
    required this.bigButtonName,
    this.onPressedCounterNext,
    this.onPressedCounterBack,
    RxInt? pathIndex,
  }) : pathIndex = pathIndex ?? 0.obs;

  final List<List<String>> paths;
  final bool isMetroRouteScreen;
  final Color btnBackgroundColor;
  final Function() onPressedBigNext;
  final String bigButtonName;
  final Function()? onPressedCounterNext;
  final Function()? onPressedCounterBack;
  final RxInt pathIndex;
  final MetroController metroController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (isMetroRouteScreen && pathIndex.value == 0) {
      customSnackBar(pathIndex.value);
    }
    // final RxInt stationsNumbers = paths[pathIndex.value].length.obs;
    final double screenWidth = Get.width;
    final double screenHeight = Get.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 20,
        children: [
          isMetroRouteScreen
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: CustomButton(
                            onPressed: onPressedCounterBack ?? () {},
                            btnName: 'Back'),
                      ),
                      Flexible(
                        child: Obx(() {
                          return CustomText(
                            text: '${pathIndex.value + 1}/${paths.length}',
                            txtFontWeight: FontWeight.bold,
                          );
                        }),
                      ),
                      Flexible(
                          flex: 2,
                          child: CustomButton(
                              onPressed: onPressedCounterNext ?? () {},
                              btnName: 'Next')),
                    ],
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: (screenHeight + screenWidth) * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: CustomDetailsCard(text: Obx(() {
                    final stationsNumbers = paths[pathIndex.value].length.obs;
                    return CustomText(
                        text: 'Stations no : ${stationsNumbers.value}');
                  }))),
                  Flexible(child: CustomDetailsCard(text: Obx(() {
                    final stationsNumbers = paths[pathIndex.value].length.obs;
                    return CustomText(
                        text:
                            'Time : ${(stationsNumbers.value * 3) ~/ 60} hrs ${(stationsNumbers.value * 3) % 60} min');
                  }))),
                  Flexible(child: CustomDetailsCard(text: Obx(() {
                    final stationsNumbers = paths[pathIndex.value].length.obs;
                    return CustomText(
                        text:
                            'Price : ${metroController.getTicketPrice(stationsNumbers.value)}');
                  }))),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: Obx(() {
              return StationTileListView(
                pathIndex: pathIndex,
                path: paths[pathIndex.value].obs,
              );
            }),
          ),
          Expanded(
              child: CustomButton(
            onPressed: onPressedBigNext,
            btnName: bigButtonName,
            btnBackgroundColor: btnBackgroundColor,
          )),
        ],
      ),
    );
  }
}
