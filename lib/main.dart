import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/config.dart';
import 'core/constant/app_router.dart';
import 'core/constant/app_theme.dart';
import 'core/service/storage_service.dart';
import 'core/service/supabase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/login_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/signup_provider.dart';
import 'providers/bike_provider.dart';
import 'providers/rental_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/stats_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await StorageService.init();
  await SupabaseService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => OnboardingProvider()),
            ChangeNotifierProvider(create: (_) => LoginProvider()),
            ChangeNotifierProvider(create: (_) => SignupProvider()),
            ChangeNotifierProvider(create: (_) => BikeProvider()),
            ChangeNotifierProvider(create: (_) => RentalProvider()),
            ChangeNotifierProvider(create: (_) => ProfileProvider()),
            ChangeNotifierProvider(create: (_) => StatsProvider()),
          ],
          child: MaterialApp.router(
            title: Config.appName,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            // builder: (context, child) {
            //   final padding = MediaQuery.of(context).padding;
            //   return Padding(
            //     padding: EdgeInsets.only(bottom: padding.bottom),
            //     child: child!,
            //   );
            // },
          ),
        );
      },
    );
  }
}
