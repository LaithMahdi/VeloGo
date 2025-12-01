import 'package:go_router/go_router.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/splash/splash_screen.dart';

abstract class AppRouter {
  static const String splash = '/';
  static const String onBoarding = '/onBoarding';
  static const String home = '/home';

  static final router = GoRouter(
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onBoarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}
