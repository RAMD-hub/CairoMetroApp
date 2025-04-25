import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constant.dart';

customSnackBar(final int pathIndex) {
  Future.delayed(Duration.zero, () {
    Get.snackbar(
      'SHORT PATH',
      'This route is the shortest path',
      colorText: Colors.white,
      backgroundColor: kPrimaryColor,
    );
  });
}
