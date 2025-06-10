import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants/constant.dart';
import '../widgets/animated_onboarding_widget.dart';
import '../widgets/animated_onboarding_type.dart';
import '../widgets/custom_onboarding_image.dart';
import '../widgets/custom_onboarding_text.dart';

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
      globalBackgroundColor: kPrimaryColor,
      pages: [
        PageViewModel(
          titleWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.fade,
              child: CustomOnboardingText(
                  text: loc.onboardingPage1Title, type: CustomTextType.title)),
          bodyWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.fade,
              child: CustomOnboardingText(
                  text: loc.onboardingPage1Subtitle,
                  type: CustomTextType.body)),
          image: AnimatedOnboardingWidget(
            animationType: AnimationType.slideFromLeft,
            padding: const EdgeInsets.only(top: 42.0),
            child: CustomOnboardingImage(
              imagePath: 'assets/images/onboarding1.png',
            ),
          ),
        ),
        PageViewModel(
          titleWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.slideFromBottom,
              child: CustomOnboardingText(
                  text: loc.onboardingPage2Title, type: CustomTextType.title)),
          bodyWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.slideFromBottom,
              child: CustomOnboardingText(
                  text: loc.onboardingPage2Subtitle,
                  type: CustomTextType.body)),
          image: AnimatedOnboardingWidget(
            animationType: AnimationType.rotation,
            padding: const EdgeInsets.only(top: 42.0),
            child: CustomOnboardingImage(
              imagePath: 'assets/images/onboarding2.png',
            ),
          ),
        ),
        PageViewModel(
          titleWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.slideFromLeft,
              child: CustomOnboardingText(
                  text: loc.onboardingPage3Title, type: CustomTextType.title)),
          bodyWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.slideFromLeft,
              child: CustomOnboardingText(
                  text: loc.onboardingPage3Subtitle,
                  type: CustomTextType.body)),
          image: AnimatedOnboardingWidget(
            animationType: AnimationType.slideFromLeft,
            padding: const EdgeInsets.only(top: 42.0),
            child: CustomOnboardingImage(
              imagePath: 'assets/images/onboarding3.png',
            ),
          ),
        ),
        PageViewModel(
          titleWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.fade,
              child: CustomOnboardingText(
                  text: loc.onboardingPage4Title, type: CustomTextType.title)),
          bodyWidget: AnimatedOnboardingWidget(
              animationType: AnimationType.fade,
              child: CustomOnboardingText(
                  text: loc.onboardingPage4Subtitle,
                  type: CustomTextType.body)),
          image: AnimatedOnboardingWidget(
            animationType: AnimationType.rotation,
            padding: const EdgeInsets.only(top: 42.0),
            child: CustomOnboardingImage(
              imagePath: 'assets/images/onboarding4.png',
            ),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      back: const Icon(Icons.arrow_back, color: Colors.white),
      showBackButton: true,
      skip:
          Text(loc.onboardingSkip, style: const TextStyle(color: Colors.white)),
      next: const Icon(Icons.arrow_forward, color: Colors.white),
      done: Text(loc.onboardingStart,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white)),
      dotsDecorator: const DotsDecorator(
        size: Size(8.0, 8.0),
        activeSize: Size(16.0, 8.0),
        activeColor: Colors.white,
        color: Colors.white38,
        spacing: EdgeInsets.symmetric(horizontal: 4.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
