import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_image.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImage.imagesLogoLogo,
              width: 80,
              colorFilter: ColorFilter.mode(
                AppColor.background,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
