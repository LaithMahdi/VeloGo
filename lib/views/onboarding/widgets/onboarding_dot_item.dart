import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_color.dart';

class OnboardingDotItem extends StatelessWidget {
  const OnboardingDotItem({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 60.w : 10.w,
      height: 10.h,
      decoration: BoxDecoration(
        color: isActive
            ? AppColor.primary
            : AppColor.primary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
