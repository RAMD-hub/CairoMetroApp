import 'package:cairo_metro_flutter/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_details_card.dart';
import '../widgets/custom_text.dart';
import 'station_tile_list_view.dart';

class RouteDetailsLandScapeScreen extends StatelessWidget {
  RouteDetailsLandScapeScreen({
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
  final MetroController metroController = Get.find();
  @override
  Widget build(BuildContext context) {
    customSnackBar(pathIndex);
    final int stationsNumbers = paths[pathIndex].length;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isMetroRouteScreen
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: CustomButton(
                              onPressed: onPressedCounterBack ?? () {},
                              btnName: 'Back',
                            ),
                          ),
                          Flexible(
                            child: CustomText(
                              text: '${pathIndex + 1}/${paths.length}',
                              txtFontWeight: FontWeight.bold,
                              txtFontSize: screenWidth * 0.018,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: CustomButton(
                              onPressed: onPressedCounterNext ?? () {},
                              btnName: 'Next',
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                isMetroRouteScreen
                    ? SizedBox(height: screenHeight * 0.02)
                    : SizedBox(),
                CustomDetailsCard(text: 'Stations no: $stationsNumbers'),
                CustomDetailsCard(
                    text:
                        'Time : ${(stationsNumbers * 3) ~/ 60} hrs ${(stationsNumbers * 3) % 60} min'),
                CustomDetailsCard(
                  text:
                      'Price : ${metroController.getTicketPrice(stationsNumbers)}',
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomButton(
                  onPressed: onPressedBigNext,
                  btnName: bigButtonName,
                  btnBackgroundColor: btnBackgroundColor,
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            flex: 5,
            child: StationTileListView(
              path: paths[pathIndex],
              pathIndex: pathIndex,
            ),
          ),
        ],
      ),
    );
  }
}
