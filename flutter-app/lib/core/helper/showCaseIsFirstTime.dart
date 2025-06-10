import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';

void showShowcaseIfFirstTime({
  required BuildContext context,
  required List<GlobalKey> keys,
  required String storageKey,
  ScrollController? scrollController,
}) async {
  final storage = GetStorage();
  final hasShown = storage.read(storageKey) ?? false;

  if (!hasShown) {
    if (scrollController != null && scrollController.hasClients) {
      await scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase(keys);
      storage.write(storageKey, true);
    });
  }
}
