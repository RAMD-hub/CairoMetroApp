import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_details_card.dart';
import '../widgets/custom_text.dart';
import '../widgets/station_tile_list_view.dart';

class RouteDetailsLandScapeScreen extends StatelessWidget {
  const RouteDetailsLandScapeScreen({
    super.key,
    this.stations = const [],
    this.pathsCount = true,
    this.btnBackgroundColor = const Color(0xFFFEA613),
    required this.onPressedBigNext,
    required this.bigButtonName,
  });

  final List<String> stations;
  final bool pathsCount;
  final Color btnBackgroundColor;
  final Function() onPressedBigNext;
  final String bigButtonName;

  @override
  Widget build(BuildContext context) {
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
                pathsCount
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: CustomButton(
                              onPressed: () {},
                              btnName: 'Back',
                            ),
                          ),
                          Flexible(
                            child: CustomText(
                              text: '1 / 5',
                              txtFontWeight: FontWeight.bold,
                              txtFontSize: screenWidth * 0.018,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: CustomButton(
                              onPressed: () {},
                              btnName: 'Next',
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                pathsCount ? SizedBox(height: screenHeight * 0.02) : SizedBox(),
                CustomDetailsCard(text: 'Stations no: 21'),
                CustomDetailsCard(text: 'Time: 1 hrs 54 min'),
                CustomDetailsCard(
                  text: 'Price: 15',
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
            child: StationTileListView(stations: stations),
          ),
        ],
      ),
    );
  }
}
