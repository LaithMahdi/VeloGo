import '../core/config.dart';
import '../core/constant/app_image.dart';
import 'model/onboarding_model.dart';

List<OnboardingModel> onboardingData = [
  OnboardingModel(
    title: "Enable Location Services",
    description:
        "Allow ${Config.appName} to access your location so we can show nearby bikes.",
    image: AppImage.imagesOnboardingOnboarding1,
  ),
  OnboardingModel(
    title: "Scan & Unlock",
    description:
        "Simply scan the QR code on any bike to unlock it instantly and start your ride.",
    image: AppImage.imagesOnboardingOnboarding3,
  ),
  OnboardingModel(
    title: "Ride, Park & Finish",
    description:
        "Enjoy your ride! Park the bike in a safe place, then end your trip directly from the app.",
    image: AppImage.imagesOnboardingOnboarding2,
  ),
];
