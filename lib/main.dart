import 'package:flutter/material.dart';
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
    return MaterialApp.router(
      title: Config.appName,
      theme: ThemeData(
        primaryColor: AppColor.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        scaffoldBackgroundColor: AppColor.background,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
