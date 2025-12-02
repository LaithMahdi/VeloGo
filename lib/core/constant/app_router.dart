import 'package:go_router/go_router.dart';
import '../../views/home/home_screen.dart';
import '../../views/login/signup_screen.dart';
import '../config.dart';
import '../service/storage_service.dart';
import '../service/supabase_service.dart';
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
      final supabaseService = SupabaseService();
      final isAuthenticated = supabaseService.isAuthenticated;
      final hasSeenOnboarding =
          StorageService.instance.getBool(Config.onboardingSeenKey) ?? false;

      final isOnOnboarding = state.matchedLocation == onBoarding;
      final isOnLogin = state.matchedLocation == login;
      final isOnSignup = state.matchedLocation == signup;
      final isOnHome = state.matchedLocation == home;

      // If user is authenticated and trying to access auth pages, redirect to home
      if (isAuthenticated && (isOnLogin || isOnSignup)) {
        return home;
      }

      // If user is not authenticated and trying to access home, redirect to login
      if (!isAuthenticated && isOnHome) {
        return login;
      }

      // If user has seen onboarding and is on onboarding page, redirect to login
      if (hasSeenOnboarding && isOnOnboarding) {
        return login;
      }

      // Allow all other navigation
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
      GoRoute(path: home, builder: (context, state) => const HomeScreen()),
    ],
  );
}
