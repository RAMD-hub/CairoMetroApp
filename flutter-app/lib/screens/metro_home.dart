import 'package:cairo_metro_flutter/controller/metro_controller.dart';
import 'package:cairo_metro_flutter/widgets/dialog_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/address_card.dart';
import '../widgets/custom_text.dart';
import '../widgets/home_appbar.dart';
import '../widgets/stations_card.dart';

class MetroHome extends StatelessWidget {
  MetroHome({super.key});
  final selectedTransfers = 'Less Stations'.obs;
  final MetroController metroController = Get.put(MetroController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: CustomScrollView(
        slivers: [
          HomeAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const CustomText(
                        text: 'Welcome', txtColor: Color(0xFFFEA613)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const CustomText(text: 'Where are you going Today?'),
                  ),
                  DialogCard(),
                  StationsCard(
                    selectedTransfers: selectedTransfers,
                  ),
                  AddressCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
