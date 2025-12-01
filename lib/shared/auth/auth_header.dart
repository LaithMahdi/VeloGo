import 'package:flutter/material.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../spacer.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyle.styleSemiBold18),
        VerticalSpacer(5),
        Text(
          description,
          style: AppStyle.styleRegular14.copyWith(color: AppColor.lightGray),
        ),
      ],
    );
  }
}
