import 'package:cairo_metro_flutter/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../screens/metro_routes.dart';
import 'custom_button.dart';
import 'custom_icon.dart';
import 'custom_radio_button.dart';
import 'custom_text_field.dart';

class StationsCard extends StatelessWidget {
  const StationsCard({
    super.key,
    required this.selectedTransfers,
  });

  final RxString selectedTransfers;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      shadowColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            CustomTextField(
              suffixIcon: Icons.location_on_outlined,
              hint: 'Enter Start Station',
            ),
            CustomIcon(icon: Icons.swap_vert_circle_outlined),
            CustomTextField(
              hint: 'Enter Arrival Station',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomRadioButton(
                  text: 'Less Stations',
                  value: 'Less Stations',
                  groupValue: selectedTransfers,
                ),
                CustomRadioButton(
                  text: 'Less Transfer',
                  value: 'Less Transfer',
                  groupValue: selectedTransfers,
                ),
              ],
            ),
            CustomButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MetroRouteScreen()));
              },
              btnName: 'Start',
            ),
          ],
        ),
      ),
    );
  }
}
