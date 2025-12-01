import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config.dart';
import 'app_color.dart';
import 'app_style.dart';

abstract class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: Config.appFontFamily,
    primaryColor: AppColor.primary,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
    scaffoldBackgroundColor: AppColor.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.background,
        textStyle: AppStyle.styleSemiBold16.copyWith(
          color: AppColor.background,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.primary,
        textStyle: AppStyle.styleMedium14.copyWith(color: AppColor.primary),
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.all(8.w),
      ),
    ),
  );
}
