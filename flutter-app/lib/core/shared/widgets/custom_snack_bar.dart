import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constant.dart';

customSnackBar(final int pathIndex, String info, String message) {
  Future.delayed(Duration.zero, () {
    Get.snackbar(
      info,
      message,
      colorText: Colors.white,
      backgroundColor: kPrimaryColor,
    );
  });
}
