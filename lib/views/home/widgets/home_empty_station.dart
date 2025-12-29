import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../shared/spacer.dart';

class HomeEmptyStation extends StatelessWidget {
  const HomeEmptyStation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 60.w,
            color: AppColor.lightGray,
          ),
          VerticalSpacer(16),
          Text(
            'No nearby stations found',
            style: AppStyle.styleMedium14.copyWith(color: AppColor.lightGray),
          ),
        ],
      ),
    );
  }
}
