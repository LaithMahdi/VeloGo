import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_router.dart';
import '../../core/constant/app_style.dart';
import '../../providers/auth_provider.dart';
import '../../shared/spacer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // User Info Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundColor: AppColor.primary,
                      backgroundImage: user?.avatarUrl != null
                          ? NetworkImage(user!.avatarUrl!)
                          : null,
                      child: user?.avatarUrl != null
                          ? null
                          : Icon(Icons.person, size: 40.w, color: Colors.white),
                    ),
                    VerticalSpacer(16),
                    Text(user?.fullName ?? 'User', style: AppStyle.styleBold20),
                    VerticalSpacer(4),
                    Text(
                      user?.email ?? '',
                      style: AppStyle.styleRegular14.copyWith(
                        color: AppColor.lightGray,
                      ),
                    ),
                    if (user?.phoneNumber != null) ...[
                      VerticalSpacer(4),
                      Text(
                        user!.phoneNumber!,
                        style: AppStyle.styleRegular14.copyWith(
                          color: AppColor.lightGray,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              VerticalSpacer(24),
              // Balance Card
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.primary, AppColor.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Balance',
                          style: AppStyle.styleMedium14.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        VerticalSpacer(8),
                        Text(
                          '\$${user?.balance.toStringAsFixed(2) ?? '0.00'}',
                          style: AppStyle.styleBold28.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to add balance screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add balance feature coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Add Balance',
                        style: AppStyle.styleSemiBold14,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSpacer(24),
              // Stats
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.pedal_bike,
                      title: 'Total Rentals',
                      value: '${user?.totalRentals ?? 0}',
                    ),
                  ),
                  const HorizontalSpacer(16),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.access_time,
                      title: 'Total Hours',
                      value: '0', // TODO: Calculate from rental history
                    ),
                  ),
                ],
              ),
              VerticalSpacer(24),
              // Menu Items
              _MenuItem(
                icon: Icons.history,
                title: 'Rental History',
                onTap: () {
                  GoRouter.of(context).push(AppRouter.rentalHistory);
                },
              ),
              VerticalSpacer(12),
              _MenuItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings feature coming soon!'),
                    ),
                  );
                },
              ),
              VerticalSpacer(12),
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help & Support feature coming soon!'),
                    ),
                  );
                },
              ),
              VerticalSpacer(12),
              _MenuItem(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: AppColor.red,
                titleColor: AppColor.red,
                onTap: () async {
                  await authProvider.signOut();
                  if (context.mounted) {
                    GoRouter.of(context).go(AppRouter.login);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.greyDD),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.w, color: AppColor.primary),
          VerticalSpacer(8),
          Text(
            value,
            style: AppStyle.styleBold20.copyWith(color: AppColor.primary),
          ),
          VerticalSpacer(4),
          Text(
            title,
            style: AppStyle.styleRegular12.copyWith(color: AppColor.lightGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.greyDD),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.w, color: iconColor ?? AppColor.darkGray),
            const HorizontalSpacer(16),
            Expanded(
              child: Text(
                title,
                style: AppStyle.styleMedium16.copyWith(
                  color: titleColor ?? AppColor.darkGray,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 24.w, color: AppColor.lightGray),
          ],
        ),
      ),
    );
  }
}
