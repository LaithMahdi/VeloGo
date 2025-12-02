import 'package:flutter/material.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';

class AuthTextLine extends StatelessWidget {
  const AuthTextLine({
    super.key,
    required this.text,
    required this.subText,
    required this.onPressed,
  });

  final String text;
  final String subText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppStyle.styleRegular14.copyWith(color: AppColor.darkGray),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            subText,
            style: AppStyle.styleSemiBold14.copyWith(color: AppColor.primary),
          ),
        ),
      ],
    );
  }
}
