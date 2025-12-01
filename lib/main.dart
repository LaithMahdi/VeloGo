import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/config.dart';
import 'core/constant/app_color.dart';
import 'core/constant/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852),
      child: MaterialApp.router(
        title: Config.appName,
        theme: ThemeData(
          fontFamily: Config.appFontFamily,
          primaryColor: AppColor.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
          scaffoldBackgroundColor: AppColor.background,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
