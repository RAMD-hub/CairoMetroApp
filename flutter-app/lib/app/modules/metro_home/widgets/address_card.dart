import 'package:flutter/material.dart';

import '../../../../core/constants/constant.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text.dart';
import '../../../shared/widgets/custom_text_field.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kOpacityCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Please enter your destination (optional)',
              txtColor: kSecondaryTextColor,
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
