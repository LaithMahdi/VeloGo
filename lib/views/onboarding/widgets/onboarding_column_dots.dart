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
        VerticalSpacer(20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Previous button
              TextButton(
                onPressed: provider.previousPage,
                child: const Text("Previous"),
              ),

              /// Next button
              ElevatedButton(
                onPressed: provider.nextPage,
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: AppColor.primary,
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 32.w,
                //     vertical: 14.h,
                //   ),
                // ),
                child: const Text("Next"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
