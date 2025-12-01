import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/dummy.dart';

import '../../providers/onboarding_provider.dart';
import 'widgets/onboarding_column_dots.dart';
import 'widgets/onboarding_item.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
