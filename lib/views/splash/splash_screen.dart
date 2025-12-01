import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../../core/config.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_router.dart';
import '../../core/constant/app_style.dart';
import '../../shared/logo.dart';
import '../../shared/spacer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      GoRouter.of(context).go(AppRouter.onBoarding);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Logo(),
            VerticalSpacer(5),
            Text(
              Config.appName,
              style: AppStyle.styleSemiBold16.copyWith(
                color: AppColor.background,
              ),
            ),
            Spacer(),
            SpinKitCircle(color: AppColor.background),
            VerticalSpacer(30),
          ],
        ),
      ),
    );
  }
}
