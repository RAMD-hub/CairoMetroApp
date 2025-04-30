import 'package:cairo_metro_flutter/app/modules/metro_trip_progress/widgets/tracking_tile_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/algorithms/timeCalculate.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_details_card.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrackingLandScapeScreen extends StatelessWidget {
  TrackingLandScapeScreen({
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
    final double screenWidth = Get.width;
    final double screenHeight = Get.height;
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
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomDetailsCard(
                            text: CustomText(
                              text: AppLocalizations.of(context)!
                                  .stationNumber(stationsNumbers),
                              txtColor: kSecondaryTextColor,
                            ),
                          ),
                          CustomDetailsCard(
                              text: CustomText(
                            //time..............//
                            text:
                                TimeCalculate().time(context, stationsNumbers),
                            txtColor: kSecondaryTextColor,
                          )),
                          CustomDetailsCard(
                              text: CustomText(
                            text: AppLocalizations.of(context)!.price(
                                metroController
                                    .getTicketPrice(stationsNumbers)),
                            txtColor: kSecondaryTextColor,
                          )),
                          SizedBox(height: screenHeight * 0.02),
                          CustomButton(
                            onPressed: onPressedBigNext,
                            btnName: bigButtonName,
                            btnBackgroundColor: btnBackgroundColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      flex: 5,
                      child: TackingTileListView(
                        path: paths.obs,
                        pathIndex: pathIndex,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(child: CustomText(text: 'No paths found.'));
  }
}
