import 'package:cairo_metro_flutter/core/algorithms/timeCalculate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/appbar/custom_appbar.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_details_card.dart';
import '../../../../core/shared/widgets/custom_snack_bar.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import 'station_tile_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RouteDetailsPortraitScreen extends StatelessWidget {
  RouteDetailsPortraitScreen({
    super.key,
    required this.paths,
    this.btnBackgroundColor = kPrimaryColor,
    required this.onPressedBigNext,
    required this.bigButtonName,
    this.onPressedCounterNext,
    this.onPressedCounterBack,
    RxInt? pathIndex,
    required this.startTripKey,
    this.scrollController,
  }) : pathIndex = pathIndex ?? 0.obs;

  final List<List<String>> paths;
  final Color btnBackgroundColor;
  final Function() onPressedBigNext;
  final String bigButtonName;
  final Function()? onPressedCounterNext;
  final Function()? onPressedCounterBack;
  final RxInt pathIndex;
  final MetroController metroController = Get.find();
  final GlobalKey startTripKey;
  final ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    if (pathIndex.value == 0 && paths.isNotEmpty) {
      customSnackBar(pathIndex.value, AppLocalizations.of(context)!.shortPath,
          AppLocalizations.of(context)!.shortPathMessage);
    }
    // final RxInt stationsNumbers = paths[pathIndex.value].length.obs;
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
                        text: AppLocalizations.of(context)!.allPaths,
                        txtColor: kPrimaryColor,
                        txtFontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: CustomButton(
                              onPressed: onPressedCounterBack ?? () {},
                              btnName: AppLocalizations.of(context)!.back,
                            ),
                          ),
                          Flexible(
                            child: Obx(() {
                              return CustomText(
                                text: '${pathIndex.value + 1}/${paths.length}',
                                txtFontWeight: FontWeight.bold,
                                txtColor: kSecondaryTextColor,
                              );
                            }),
                          ),
                          Flexible(
                              flex: 2,
                              child: CustomButton(
                                onPressed: onPressedCounterNext ?? () {},
                                btnName: AppLocalizations.of(context)!.next,
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: CustomDetailsCard(text: Obx(() {
                            final stationsNumbers =
                                paths[pathIndex.value].length.obs;
                            return FittedBox(
                              child: CustomText(
                                text: AppLocalizations.of(context)!
                                    .stationNumber(stationsNumbers.value),
                                txtColor: kSecondaryTextColor,
                              ),
                            );
                          }))),
                          Expanded(child: CustomDetailsCard(text: Obx(() {
                            final stationsNumbers =
                                paths[pathIndex.value].length.obs;
                            return FittedBox(
                              child: CustomText(
                                //time..............................//
                                text: TimeCalculate()
                                    .time(context, stationsNumbers.value),
                                txtColor: kSecondaryTextColor,
                              ),
                            );
                          }))),
                          Expanded(child: CustomDetailsCard(text: Obx(() {
                            final stationsNumbers =
                                paths[pathIndex.value].length.obs;
                            return FittedBox(
                              child: CustomText(
                                text: AppLocalizations.of(context)!.price(
                                    metroController
                                        .getTicketPrice(stationsNumbers.value)),
                                txtColor: kSecondaryTextColor,
                              ),
                            );
                          }))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Obx(() {
                        return StationTileListView(
                          pathIndex: pathIndex,
                          path: paths[pathIndex.value].obs,
                          scrollController: scrollController,
                        );
                      }),
                    ),
                    Expanded(
                      child: Showcase(
                        key: startTripKey,
                        description: AppLocalizations.of(context)!
                            .liveTrackingDescription,
                        child: CustomButton(
                          onPressed: onPressedBigNext,
                          btnName: bigButtonName,
                          btnBackgroundColor: btnBackgroundColor,
                        ),
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
