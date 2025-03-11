import 'package:cairo_metro_flutter/widgets/custom_button.dart';
import 'package:cairo_metro_flutter/widgets/custom_text_field.dart';
import 'package:cairo_metro_flutter/widgets/dialog_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/address_card.dart';
import '../widgets/custom_icon.dart';
import '../widgets/custom_text.dart';
import '../widgets/stations_card.dart';

class MetroHome extends StatelessWidget {
  MetroHome({super.key});
  final selectedTransfers = 'Less Stations'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            floating: false,
            leading: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: CustomIcon(icon: Icons.location_on_outlined),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CustomIcon(icon: Icons.language, color: Colors.black),
              ),
            ],
          ),
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
                  const DialogCard(
                    previousStation: 'New ElMarg',
                    currentStation: 'El Marg',
                    nextStation: 'Sakanat El-Maadi',
                  ),
                  StationsCard(selectedTransfers: selectedTransfers),
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
