import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../providers/rental_provider.dart';
import '../../../shared/spacer.dart';

class ActiveRentalCard extends StatelessWidget {
  final VoidCallback onTap;

  const ActiveRentalCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final rentalProvider = context.watch<RentalProvider>();
    final rental = rentalProvider.activeRental;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.secondary, AppColor.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.pedal_bike, size: 30.w, color: Colors.white),
            ),
            const HorizontalSpacer(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rental?.bike?.name ?? 'Bike',
                    style: AppStyle.styleSemiBold16.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  VerticalSpacer(4),
                  Text(
                    'In progress...',
                    style: AppStyle.styleRegular12.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white, size: 24.w),
          ],
        ),
      ),
    );
  }
}
