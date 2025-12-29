import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_style.dart';
import '../../../shared/spacer.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.w, color: color),
          VerticalSpacer(8),
          Text(value, style: AppStyle.styleBold20.copyWith(color: color)),
          VerticalSpacer(2),
          Text(
            title,
            style: AppStyle.styleRegular12.copyWith(
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
