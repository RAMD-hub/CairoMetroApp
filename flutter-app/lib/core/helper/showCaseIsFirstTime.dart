import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

final box = GetStorage();

void showShowcaseIfFirstTime({
  required BuildContext context,
  required List<GlobalKey> keys,
  required String storageKey,
}) {
  final hasShown = box.read(storageKey) ?? false;

  if (!hasShown) {
    box.write(storageKey, true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase(keys);
    });
  }
}
