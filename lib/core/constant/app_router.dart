import 'package:go_router/go_router.dart';
import '../../views/login/signup_screen.dart';
import '../config.dart';
import '../service/storage_service.dart';
import '../../views/login/login_screen.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/splash/splash_screen.dart';

abstract class AppRouter {
  static const String splash = '/';
  static const String onBoarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/sign-up';
  static const String home = '/home';

  static final router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final hasSeenOnboarding =
          StorageService.instance.getBool(Config.onboardingSeenKey) ?? false;
      final isOnboarding = state.matchedLocation == onBoarding;
      if (hasSeenOnboarding && isOnboarding) {
        return login;
      }
      return null;
    },

    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onBoarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
    ],
  );
}
