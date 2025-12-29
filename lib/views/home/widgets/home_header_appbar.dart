import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../data/model/user_model.dart';
import '../../../shared/spacer.dart';
import 'stat_card.dart';

class HomeHeaderAppbar extends StatelessWidget {
  const HomeHeaderAppbar({super.key, required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.primary, AppColor.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: AppStyle.styleMedium14.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          VerticalSpacer(4),
          Text(
            user?.fullName ?? user?.email ?? 'User',
            style: AppStyle.styleBold20.copyWith(color: Colors.white),
          ),
          VerticalSpacer(24),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Balance',
                  value: '\$${user?.balance.toStringAsFixed(2) ?? '0.00'}',
                  color: Colors.white,
                ),
              ),
              const HorizontalSpacer(16),
              Expanded(
                child: StatCard(
                  icon: Icons.pedal_bike,
                  title: 'Total Rentals',
                  value: '${user?.totalRentals ?? 0}',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
