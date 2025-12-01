import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.white,
        foregroundColor: textColor ?? AppColor.darkGray,
        side: BorderSide(color: AppColor.greyDD, width: 1.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24.w, color: iconColor ?? AppColor.darkGray),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppStyle.styleMedium14.copyWith(
              color: textColor ?? AppColor.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}
