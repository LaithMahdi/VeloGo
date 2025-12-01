import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../data/model/onboarding_model.dart';
import '../../../shared/spacer.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({super.key, required this.data});

  final OnboardingModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(data.image, width: double.infinity, height: 300.h),
        VerticalSpacer(20),
        Text(data.title, style: AppStyle.styleSemiBold20),
        VerticalSpacer(14),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: AppStyle.styleRegular14.copyWith(color: AppColor.lightGray),
        ),
      ],
    );
  }
}
