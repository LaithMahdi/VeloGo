import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    required this.text,
    this.color,
    this.textStyle,
  });

  final String text;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color ?? AppColor.greyDD,
            thickness: 1,
            height: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            text,
            style:
                textStyle ??
                AppStyle.styleRegular14.copyWith(color: AppColor.lightGray),
          ),
        ),
        Expanded(
          child: Divider(
            color: color ?? AppColor.greyDD,
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}
