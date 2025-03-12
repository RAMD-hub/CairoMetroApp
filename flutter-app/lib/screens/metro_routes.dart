import 'package:cairo_metro_flutter/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_details_card.dart';
import '../widgets/custom_text.dart';
import '../widgets/station_tile_list_view.dart';

class MetroRouteScreen extends StatelessWidget {
  MetroRouteScreen({super.key});

  final List<String> stations = [
    "helwan (start)",
    "ain helwan",
    "helwan university",
    "wadi hof",
    "hadayek helwan",
    "el maasraa (changed)",
    "el maasraa",
    "el maasraa",
    "el maasraa",
    "el maasraa",
    "el maasraa (end)",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'All routes',
          txtColor: const Color(0xFFFEA613),
          txtFontWeight: FontWeight.bold,
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return MetroRouteScreenPortrait(
            stations: stations,
          );
        } else {
          return MetroRouteScreenLandscape(stations: stations);
        }
      }),
    );
  }
}

class MetroRouteScreenPortrait extends StatelessWidget {
  const MetroRouteScreenPortrait({
    super.key,
    required this.stations,
  });

  final List<String> stations;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = (MediaQuery.sizeOf(context).width);
    final double screenHeight = (MediaQuery.sizeOf(context).height);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 20,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 2,
                    child: CustomButton(onPressed: () {}, btnName: 'Back')),
                Flexible(
                  child: CustomText(
                    text: '1 / 5',
                    txtFontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: CustomButton(onPressed: () {}, btnName: 'Next')),
              ],
            ),
          ),
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
          Expanded(child: CustomButton(onPressed: () {}, btnName: 'Next')),
        ],
      ),
    );
  }
}

class MetroRouteScreenLandscape extends StatelessWidget {
  const MetroRouteScreenLandscape({
    super.key,
    required this.stations,
  });

  final List<String> stations;

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
                Row(
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
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomDetailsCard(text: 'Stations no: 21'),
                CustomDetailsCard(text: 'Time: 1 hrs 54 min'),
                CustomDetailsCard(
                  text: 'Price: 15',
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomButton(
                  onPressed: () {},
                  btnName: 'Next',
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
