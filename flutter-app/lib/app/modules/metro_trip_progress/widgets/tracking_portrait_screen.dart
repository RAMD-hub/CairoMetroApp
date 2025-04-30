import 'package:cairo_metro_flutter/app/modules/metro_trip_progress/widgets/tracking_tile_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/algorithms/timeCalculate.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/appbar/custom_appbar.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_details_card.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackingPortraitScreen extends StatelessWidget {
  TrackingPortraitScreen({
    super.key,
    required this.paths,
    this.btnBackgroundColor = kPrimaryColor,
    required this.onPressedBigNext,
    required this.bigButtonName,
    RxInt? pathIndex,
  }) : pathIndex = pathIndex ?? 0.obs;

  final List<String> paths;
  final Color btnBackgroundColor;
  final Function() onPressedBigNext;
  final String bigButtonName;
  final RxInt pathIndex;
  final MetroController metroController = Get.find();

  @override
  Widget build(BuildContext context) {
    final stationsNumbers = paths.length;
    return paths.isNotEmpty
        ? Stack(
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 20,
                  children: [
                    CustomAppBar(
                      title: CustomText(
                        text: AppLocalizations.of(context)!.tripProgress,
                        txtColor: kPrimaryColor,
                        txtFontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: CustomDetailsCard(
                                text: CustomText(
                                  text: AppLocalizations.of(context)!
                                      .stationNumber(stationsNumbers),
                                  txtColor: kSecondaryTextColor,
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: CustomDetailsCard(
                                  text: CustomText(
                                text: TimeCalculate()
                                    .time(context, stationsNumbers),
                                txtColor: kSecondaryTextColor,
                              ))),
                          Expanded(
                              flex: 1,
                              child: CustomDetailsCard(
                                  text: CustomText(
                                text: AppLocalizations.of(context)!.price(
                                    metroController
                                        .getTicketPrice(stationsNumbers)),
                                txtColor: kSecondaryTextColor,
                              ))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 13,
                      child: TackingTileListView(
                        pathIndex: pathIndex,
                        path: paths.obs,
                      ),
                    ),
                    Expanded(
                        child: CustomButton(
                      onPressed: onPressedBigNext,
                      btnName: bigButtonName,
                      btnBackgroundColor: btnBackgroundColor,
                    )),
                  ],
                ),
              ),
            ],
          )
        : Center(child: CustomText(text: 'No paths found.'));
  }
}
