import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Please enter your destination (optional)',
              txtColor: Colors.black87,
            ),
            CustomTextField(
              hint: 'Address',
              suffixIcon: Icons.location_city_outlined,
              textController: TextEditingController(),
            ),
            CustomButton(onPressed: () {}, btnName: 'Search')
          ],
        ),
      ),
    );
  }
}
