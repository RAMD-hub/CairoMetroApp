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
                    Flexible(
                        child: CustomDetailsCard(text: 'Stations no : 21')),
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
      ),
    );
  }
}
