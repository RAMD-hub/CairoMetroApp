import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/custom_text_field.dart';

class AddressCard extends StatelessWidget {
  AddressCard({
    super.key,
  });
  final addressCont = TextEditingController();
  final MetroController metroController = Get.find();
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
              textController: addressCont,
            ),
            CustomButton(
              onPressed: () {
                if (addressCont.text.isEmpty) {
                  Get.snackbar('Error', 'The address is Empty');
                }
                if (addressCont.text.isNotEmpty) {
                  metroController.locationFromAddress(addressCont.text);
                }
              },
              btnName: 'Search',
            )
          ],
        ),
      ),
    );
  }
}
