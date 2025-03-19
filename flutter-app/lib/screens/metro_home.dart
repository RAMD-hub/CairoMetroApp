import 'package:cairo_metro_flutter/screens/dialog_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import 'address_card.dart';
import '../widgets/custom_text.dart';
import 'home_appbar.dart';
import 'stations_card.dart';

class MetroHome extends StatelessWidget {
  const MetroHome({super.key});

  @override
  Widget build(BuildContext context) {
    final MetroController metroController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: CustomScrollView(
        slivers: [
          const HomeAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: CustomText(
                        text: 'Welcome', txtColor: Color(0xFFFEA613)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: CustomText(text: 'Where are you going Today?'),
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
    );
  }
}
