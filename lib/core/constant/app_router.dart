import 'package:go_router/go_router.dart';
import '../../views/home/home_screen.dart';
import '../../views/login/signup_screen.dart';
import '../../views/navigation/main_navigation_screen.dart';
import '../../views/bike/bike_profile_screen.dart';
import '../../views/rental/active_rental_screen.dart';
import '../../views/rental/rental_history_screen.dart';
import '../../views/station/station_detail_screen.dart';
import '../../data/model/station_model.dart';
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
  static const String mainNavigation = '/main';
  static const String bikeProfile = '/bike-profile';
  static const String activeRental = '/active-rental';
  static const String rentalHistory = '/rental-history';
  static const String stationDetail = '/station-detail';

  static final router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final supabaseService = SupabaseService();
      final isAuthenticated = supabaseService.isAuthenticated;
      final hasSeenOnboarding =
          StorageService.instance.getBool(Config.onboardingSeenKey) ?? false;

      final isOnSplash = state.matchedLocation == splash;
      final isOnOnboarding = state.matchedLocation == onBoarding;
      final isOnLogin = state.matchedLocation == login;
      final isOnSignup = state.matchedLocation == signup;
      final isOnHome = state.matchedLocation == home;

      // If user is authenticated, redirect to main navigation
      if (isAuthenticated &&
          (isOnSplash || isOnLogin || isOnSignup || isOnOnboarding)) {
        return mainNavigation;
      }

      // If user is not authenticated and trying to access protected routes
      if (!isAuthenticated &&
          (isOnHome || state.matchedLocation == mainNavigation)) {
        return hasSeenOnboarding ? login : onBoarding;
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
      GoRoute(
        path: mainNavigation,
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: bikeProfile,
        builder: (context, state) => const BikeProfileScreen(),
      ),
      GoRoute(
        path: activeRental,
        builder: (context, state) => const ActiveRentalScreen(),
      ),
      GoRoute(
        path: rentalHistory,
        builder: (context, state) => const RentalHistoryScreen(),
      ),
      GoRoute(
        path: stationDetail,
        builder: (context, state) {
          final station = state.extra as StationModel;
          return StationDetailScreen(station: station);
        },
      ),
    ],
  );
}
