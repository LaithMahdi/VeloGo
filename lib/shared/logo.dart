import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constant/app_color.dart';
import '../core/constant/app_image.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.color, this.width, this.height});

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImage.imagesLogoLogo,
      width: width ?? 80.w,
      height: height ?? 80.h,
      colorFilter: ColorFilter.mode(
        color ?? AppColor.background,
        BlendMode.srcIn,
      ),
    );
  }
}
