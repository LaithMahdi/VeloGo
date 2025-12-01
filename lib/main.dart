import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/config.dart';
import 'core/constant/app_router.dart';
import 'core/constant/app_theme.dart';
import 'core/service/storage_service.dart';
import 'providers/login_provider.dart';
import 'providers/onboarding_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
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
            ChangeNotifierProvider(create: (_) => OnboardingProvider()),
            ChangeNotifierProvider(create: (_) => LoginProvider()),
          ],
          child: MaterialApp.router(
            title: Config.appName,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
