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
    final double screenWidth = (MediaQuery.sizeOf(context).width);
    final double screenHeight = (MediaQuery.sizeOf(context).height);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'All routes',
          txtColor: const Color(0xFFFEA613),
          txtFontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: CustomButton(onPressed: () {}, btnName: 'Back')),
                  Expanded(
                    child: Center(
                      child: CustomText(
                        text: '1 / 5',
                        txtFontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      child: CustomButton(onPressed: () {}, btnName: 'Next')),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: (screenHeight + screenWidth) * 0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CustomDetailsCard(text: 'Stations no : 21')),
                    Expanded(
                        child: CustomDetailsCard(text: 'Time : 1 hrs 54 min')),
                    Expanded(child: CustomDetailsCard(text: 'Price : 15')),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 16,
              child: StationTileListView(
                stations: stations,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomButton(onPressed: () {}, btnName: 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
