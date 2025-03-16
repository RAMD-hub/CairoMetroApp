import 'package:cairo_metro_flutter/services/exchange_stations.dart';
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
    this.pathIndex = 0,
  });

  final List<List<String>> paths;
  final bool isMetroRouteScreen;
  final Color btnBackgroundColor;
  final Function() onPressedBigNext;
  final String bigButtonName;
  final Function()? onPressedCounterNext;
  final Function()? onPressedCounterBack;
  final int pathIndex;
  final MetroController metroController = Get.put(MetroController());
  @override
  Widget build(BuildContext context) {
    final int stationsNumbers = paths[pathIndex].length;
    final double screenWidth = (MediaQuery.sizeOf(context).width);
    final double screenHeight = (MediaQuery.sizeOf(context).height);
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
                        child: CustomText(
                          text: '${pathIndex + 1}/${paths.length}',
                          txtFontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: CustomButton(
                              onPressed: onPressedCounterNext ?? () {},
                              btnName: 'Next')),
                    ],
                  ),
                )
              : SizedBox(),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: (screenHeight + screenWidth) * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: CustomDetailsCard(
                          text: 'Stations no : $stationsNumbers')),
                  Flexible(
                      child: CustomDetailsCard(
                          text:
                              'Time : ${(stationsNumbers * 3) ~/ 60} hrs ${(stationsNumbers * 3) % 60} min')),
                  Flexible(
                      child: CustomDetailsCard(
                          text:
                              'Price : ${metroController.getTicketPrice(stationsNumbers)}')),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: StationTileListView(
              path: paths[pathIndex],
            ),
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
