import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_details_card.dart';
import '../widgets/custom_text.dart';
import '../widgets/station_tile_list_view.dart';

class RouteDetailsPortraitScreen extends StatelessWidget {
  const RouteDetailsPortraitScreen({
    super.key,
    required this.stations,
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
    final double screenWidth = (MediaQuery.sizeOf(context).width);
    final double screenHeight = (MediaQuery.sizeOf(context).height);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 20,
        children: [
          pathsCount
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 2,
                          child:
                              CustomButton(onPressed: () {}, btnName: 'Back')),
                      Flexible(
                        child: CustomText(
                          text: '1 / 5',
                          txtFontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child:
                              CustomButton(onPressed: () {}, btnName: 'Next')),
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
                  Flexible(child: CustomDetailsCard(text: 'Stations no : 21')),
                  Flexible(
                      child: CustomDetailsCard(text: 'Time : 1 hrs 54 min')),
                  Flexible(child: CustomDetailsCard(text: 'Price : 15')),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: StationTileListView(
              stations: stations,
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
