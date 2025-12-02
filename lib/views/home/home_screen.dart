import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_router.dart';
import '../../core/constant/app_style.dart';
import '../../providers/auth_provider.dart';
import '../../shared/spacer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VeloGo',
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                GoRouter.of(context).go(AppRouter.login);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacer(20),
              Text('Welcome Back!', style: AppStyle.styleSemiBold20),
              VerticalSpacer(8),
              Text(
                user?.fullName ?? user?.email ?? 'User',
                style: AppStyle.styleMedium18.copyWith(color: AppColor.primary),
              ),
              VerticalSpacer(32),
              _buildInfoCard(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user?.email ?? 'N/A',
              ),
              VerticalSpacer(16),
              _buildInfoCard(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: user?.phoneNumber ?? 'Not provided',
              ),
              VerticalSpacer(32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pedal_bike,
                        size: 80.w,
                        color: AppColor.primary.withValues(alpha: 0.3),
                      ),
                      VerticalSpacer(16),
                      Text(
                        'Start your bike rental journey',
                        style: AppStyle.styleMedium16.copyWith(
                          color: AppColor.lightGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      VerticalSpacer(24),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to bike listing or rental screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Bike rental feature coming soon!',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Browse Bikes',
                            style: AppStyle.styleSemiBold16.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColor.greyDD, width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColor.primary, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyle.styleRegular12.copyWith(
                    color: AppColor.lightGray,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppStyle.styleMedium14.copyWith(
                    color: AppColor.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
