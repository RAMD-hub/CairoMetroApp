import 'package:cairo_metro_flutter/app/modules/metro_home/widgets/dialog_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/helper/showCaseIsFirstTime.dart';
import '../../../../core/services/location_services.dart';
import '../../../../core/shared/widgets/appbar/custom_appbar.dart';
import '../../../../core/shared/widgets/custom_icon.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../widgets/address_card.dart';
import '../widgets/languageDialog.dart';
import '../widgets/stations_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MetroHome extends StatefulWidget {
  const MetroHome({super.key});

  @override
  State<MetroHome> createState() => _MetroHomeState();
}

class _MetroHomeState extends State<MetroHome> {
  final MetroController metroController = Get.find();

  final LocationService locationService = Get.find();

  final GlobalKey _locationIconKey = GlobalKey();

  final GlobalKey _languageIconKey = GlobalKey();

  final GlobalKey _nearestStationDropDownKey = GlobalKey();

  final GlobalKey _addressSearchKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    showShowcaseIfFirstTime(
      context: context,
      keys: [
        _locationIconKey,
        _languageIconKey,
        _nearestStationDropDownKey,
        _addressSearchKey,
      ],
      storageKey: 'hasShownShowcase_home',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (metroController.tracking.value && !LocationService().isTracking) {
      dynamic storedPath = GetStorage().read('path');
      if (storedPath != null && storedPath is List) {
        // Convert List<dynamic> to List<String>
        storedPath =
            List<String>.from(storedPath.map((item) => item.toString()));
      }
      LocationService().startTracking(storedPath);
    } else {
      LocationService().stopTracking();
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
            child: Image.asset(
              kBackgroundImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                  child: CustomAppBar(
                leading: Showcase(
                  key: _locationIconKey,
                  description:
                      AppLocalizations.of(context)!.locationIconDescription,
                  child: CustomIcon(
                    icon: Icons.location_on_outlined,
                    onPressed: () {
                      // metroController.isNearStation.value = false;
                      metroController.getNearestStation(false.obs);
                    },
                  ),
                ),
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Showcase(
                        key: _languageIconKey,
                        description: AppLocalizations.of(context)!
                            .languageIconDescription,
                        child: CustomIcon(
                            icon: Icons.language,
                            onPressed: () {
                              if (!metroController.tracking.value) {
                                LanguageDialog().show(context);
                              } else {
                                Get.snackbar(
                                    AppLocalizations.of(context)!.language,
                                    AppLocalizations.of(context)!
                                        .languageMessage);
                              }
                            },
                            color: Colors.orange),
                      )),
                ],
              )),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomText(
                            text: (AppLocalizations.of(context)!.welcome),
                            txtColor: kPrimaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CustomText(
                          text: AppLocalizations.of(context)!.welcomeMessage,
                          txtColor: kSecondaryTextColor,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Obx(() => metroController.tracking.value
                          ? DialogCard(
                              currentStation: metroController.currentStation,
                              nextStation: metroController.nextStation,
                              previousStation: metroController.previousStation,
                            )
                          : SizedBox()),
                      StationsCard(
                        nearestStationDropDownKey: _nearestStationDropDownKey,
                      ),
                      AddressCard(
                        addressSearchKey: _addressSearchKey,
                      ),
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
