import 'package:cairo_metro_flutter/app/modules/metro_routes/widgets/station_tile_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/controllers/metro_controller.dart';
import '../../../../core/shared/widgets/custom_button.dart';
import '../../../../core/shared/widgets/custom_details_card.dart';
import '../../../../core/shared/widgets/custom_snack_bar.dart';
import '../../../../core/shared/widgets/custom_text.dart';

class RouteDetailsLandScapeScreen extends StatelessWidget {
  RouteDetailsLandScapeScreen({
    super.key,
    required this.paths,
    this.btnBackgroundColor = kPrimaryColor,
    required this.onPressedBigNext,
    required this.bigButtonName,
    this.onPressedCounterNext,
    this.onPressedCounterBack,
    RxInt? pathIndex,
  }) : pathIndex = pathIndex ?? 0.obs;

  final List<List<String>> paths;
  final Color btnBackgroundColor;
  final Function() onPressedBigNext;
  final String bigButtonName;
  final Function()? onPressedCounterNext;
  final Function()? onPressedCounterBack;
  final RxInt pathIndex;
  final MetroController metroController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (pathIndex.value == 0) {
      customSnackBar(pathIndex.value);
    }
    final double screenWidth = Get.width;
    final double screenHeight = Get.height;
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
          child: Image.asset(
            kBackgroundImage,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: CustomButton(
                            onPressed: onPressedCounterBack ?? () {},
                            btnName: 'Back',
                          ),
                        ),
                        Flexible(
                          child: Obx(() {
                            return CustomText(
                              text: '${pathIndex.value + 1}/${paths.length}',
                              txtFontWeight: FontWeight.bold,
                              txtFontSize: screenWidth * 0.018,
                              txtColor: kSecondaryTextColor,
                            );
                          }),
                        ),
                        Flexible(
                          flex: 2,
                          child: CustomButton(
                            onPressed: onPressedCounterNext ?? () {},
                            btnName: 'Next',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomDetailsCard(text: Obx(() {
                      final stationsNumbers = paths[pathIndex.value].length.obs;
                      return CustomText(
                        text: 'Stations no : ${stationsNumbers.value}',
                        txtColor: kSecondaryTextColor,
                      );
                    })),
                    CustomDetailsCard(text: Obx(() {
                      final stationsNumbers = paths[pathIndex.value].length.obs;
                      return CustomText(
                        text:
                            'Time : ${(stationsNumbers.value * 3) ~/ 60} hrs ${(stationsNumbers.value * 3) % 60} min',
                        txtColor: kSecondaryTextColor,
                      );
                    })),
                    CustomDetailsCard(text: Obx(() {
                      final stationsNumbers = paths[pathIndex.value].length.obs;
                      return CustomText(
                        text:
                            'Price : ${metroController.getTicketPrice(stationsNumbers.value)}',
                        txtColor: kSecondaryTextColor,
                      );
                    })),
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
                child: Obx(() {
                  return StationTileListView(
                    path: paths[pathIndex.value].obs,
                    pathIndex: pathIndex,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
