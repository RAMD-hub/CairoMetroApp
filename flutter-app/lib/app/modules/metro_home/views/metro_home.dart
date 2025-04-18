import 'package:cairo_metro_flutter/app/modules/metro_home/widgets/dialog_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constant.dart';
import '../../../shared/widgets/custom_icon.dart';
import '../widgets/address_card.dart';
import '../../../shared/widgets/custom_text.dart';
import '../../../shared/widgets/appbar/custom_appbar.dart';
import '../widgets/stations_card.dart';

class MetroHome extends StatelessWidget {
  const MetroHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
            child: Image.asset(
              kBackgroundImage,
              fit: BoxFit.fill,
              width: Get.width,
              height: Get.height,
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: const CustomAppBar(
                leading: CustomIcon(icon: Icons.location_on_outlined),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child:
                        CustomIcon(icon: Icons.language, color: Colors.black),
                  ),
                ],
              )),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: CustomText(
                            text: 'Welcome', txtColor: kPrimaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomText(
                          text: 'Where are you going Today?',
                          txtColor: kSecondaryTextColor,
                        ),
                      ),
                      DialogCard(),
                      StationsCard(),
                      const AddressCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
