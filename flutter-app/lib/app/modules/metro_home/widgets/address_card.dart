import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressCard extends StatelessWidget {
  AddressCard({
    super.key,
    required this.addressSearchKey,
  });
  final addressCont = TextEditingController();
  final MetroController metroController = Get.find();
  final GlobalKey addressSearchKey;
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
              text: AppLocalizations.of(context)!.addressMessage,
              txtColor: kSecondaryTextColor,
            ),
            CustomTextField(
              hint: AppLocalizations.of(context)!.address,
              suffixIcon: Icons.location_city_outlined,
              textController: addressCont,
            ),
            Showcase(
              key: addressSearchKey,
              description:
                  AppLocalizations.of(context)!.searchButtonDescription,
              child: CustomButton(
                  onPressed: () {
                    if (addressCont.text.isEmpty) {
                      Get.snackbar(
                        AppLocalizations.of(context)!.error,
                        AppLocalizations.of(context)!.errorMessage,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                    if (addressCont.text.isNotEmpty) {
                      metroController.locationFromAddress(addressCont.text);
                    }
                  },
                  btnName: (AppLocalizations.of(context)!.search)),
            )
          ],
        ),
      ),
    );
  }
}
