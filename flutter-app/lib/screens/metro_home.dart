import 'package:cairo_metro_flutter/screens/dialog_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import 'address_card.dart';
import '../widgets/custom_text.dart';
import 'home_appbar.dart';
import 'stations_card.dart';

class MetroHome extends StatefulWidget {
  const MetroHome({super.key});

  @override
  State<MetroHome> createState() => _MetroHomeState();
}

class _MetroHomeState extends State<MetroHome> {
  final MetroController metroController = Get.find();
  @override
  void initState() {
    metroController.playWelcomeUserInApp();
    super.initState();
  }

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
                  StationsCard(),
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
