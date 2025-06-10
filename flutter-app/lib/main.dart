import 'package:cairo_metro_flutter/core/services/location_service_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'core/bindings/metro_binding.dart';
import 'core/routes/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final binding = MetroBinding();
  binding.dependencies();
  await LocationServiceBackground().initialize();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: MetroBinding(),
        locale: Locale(GetStorage().read('language') ??
            Get.deviceLocale?.languageCode ??
            'ar'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ar', ''), // Arabic
        ],
        initialRoute: GetStorage().read('onboarding_shown') == true
            ? '/MetroHome'
            : '/Onboarding',
        getPages: AppRoutes.routes,
      ),
    );
  }
}
