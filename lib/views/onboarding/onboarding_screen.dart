import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/config.dart';
import '../../core/constant/app_router.dart';
import '../../core/service/storage_service.dart';
import '../../data/dummy.dart';
import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_column_dots.dart';
import 'widgets/onboarding_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    redirect();
    super.initState();
  }

  void redirect() {
    if (StorageService.instance.getBool(Config.onboardingSeenKey) == true) {
      GoRouter.of(context).go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            right: 24.w,
            left: 24.w,
            child: PageView.builder(
              controller: provider.controller,
              itemCount: onboardingData.length,
              onPageChanged: provider.onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  OnboardingItem(data: onboardingData[index]),
            ),
          ),
          Positioned(
            top: 20.h,
            right: 20.w,
            child: TextButton(onPressed: provider.skip, child: Text("Skip")),
          ),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: OnboardingColumnDots(provider: provider),
          ),
        ],
      ),
    );
  }
}
