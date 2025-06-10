import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final box = GetStorage();

  void _onIntroEnd(context) {
    box.write('onboarding_shown', true);
    Get.offAllNamed('/MetroHome');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: loc.onboardingPage1Title,
          body: loc.onboardingPage1Subtitle,
          image: Image.asset("assets/onboarding/logo.png", height: 250),
        ),
        PageViewModel(
          title: loc.onboardingPage2Title,
          body: loc.onboardingPage2Subtitle,
          image: Image.asset("assets/onboarding/routes.png", height: 250),
        ),
        PageViewModel(
          title: loc.onboardingPage3Title,
          body: loc.onboardingPage3Subtitle,
          image: Image.asset("assets/onboarding/tracking.png", height: 250),
        ),
        PageViewModel(
          title: loc.onboardingPage4Title,
          body: loc.onboardingPage4Subtitle,
          image: Image.asset("assets/onboarding/start.png", height: 250),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: Text(loc.onboardingNext),
      next: const Icon(Icons.arrow_forward),
      done: Text(loc.onboardingStart,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: const DotsDecorator(
        size: Size(8.0, 8.0),
        activeSize: Size(16.0, 8.0),
        activeColor: Colors.deepPurple,
        color: Colors.grey,
        spacing: EdgeInsets.symmetric(horizontal: 4.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
