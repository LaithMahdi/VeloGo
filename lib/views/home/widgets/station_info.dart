import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../shared/spacer.dart';

class StationInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StationInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: color),
        const HorizontalSpacer(6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppStyle.styleSemiBold14.copyWith(color: color)),
            Text(
              label,
              style: AppStyle.styleRegular10.copyWith(
                color: AppColor.lightGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
