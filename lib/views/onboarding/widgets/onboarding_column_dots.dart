import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/dummy.dart';
import '../../../providers/onboarding_provider.dart';
import '../../../shared/spacer.dart';
import 'onboarding_dot_item.dart';

class OnboardingColumnDots extends StatelessWidget {
  const OnboardingColumnDots({super.key, required this.provider});

  final OnboardingProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            onboardingData.length,
            (index) =>
                OnboardingDotItem(isActive: index == provider.currentPage),
          ),
        ),
        VerticalSpacer(40),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: provider.previousPage,
                child: const Text("Previous"),
              ),
              ElevatedButton(
                onPressed: () => provider.nextPage(context),
                child: const Text("Next"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
