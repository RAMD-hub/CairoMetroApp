import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/controllers/metro_controller.dart'; // You need to import Get

class LanguageDialog {
  final MetroController metroController = Get.find();

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: const TextStyle(fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text(
                  '🇺🇸',
                  style: TextStyle(fontSize: 20),
                ),
                title: const Text('English'),
                onTap: () {
                  metroController.changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text(
                  '🇪🇬',
                  style: TextStyle(fontSize: 20),
                ),
                title: const Text('العربية'),
                onTap: () {
                  metroController.changeLanguage('ar');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
