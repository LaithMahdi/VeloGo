import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rent_bike/core/constant/app_style.dart';
import 'core/config.dart';
import 'core/constant/app_color.dart';
import 'core/constant/app_router.dart';
import 'providers/onboarding_provider.dart';

void main() {
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
          ],
          child: MaterialApp.router(
            title: Config.appName,
            theme: ,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
