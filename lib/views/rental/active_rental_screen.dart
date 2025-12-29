import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../providers/rental_provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/spacer.dart';

class ActiveRentalScreen extends StatefulWidget {
  const ActiveRentalScreen({super.key});

  @override
  State<ActiveRentalScreen> createState() => _ActiveRentalScreenState();
}

class _ActiveRentalScreenState extends State<ActiveRentalScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update timer every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rentalProvider = context.watch<RentalProvider>();
    final authProvider = context.watch<AuthProvider>();
    final rental = rentalProvider.activeRental;
    final user = authProvider.currentUser;

    if (rental == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Active Rental'),
          backgroundColor: AppColor.primary,
        ),
        body: const Center(child: Text('No active rental')),
      );
    }

    final duration = rentalProvider.getCurrentRentalDuration();
    final currentCost = rentalProvider.getCurrentCost();
    final remainingTime = rental.remainingTime;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Active Rental',
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    // Bike Image
                    Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.greyDD,
                        borderRadius: BorderRadius.circular(16.r),
                        image: rental.bike?.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(rental.bike!.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: rental.bike?.imageUrl == null
                          ? Icon(
                              Icons.pedal_bike,
                              size: 80.w,
                              color: AppColor.lightGray,
                            )
                          : null,
                    ),
                    VerticalSpacer(24),
                    // Bike Name
                    Text(
                      rental.bike?.model ?? 'Bike',
                      style: AppStyle.styleBold24,
                    ),
                    VerticalSpacer(8),
                    Text(
                      rental.bike?.qrCode ?? '',
                      style: AppStyle.styleRegular14.copyWith(
                        color: AppColor.lightGray,
                      ),
                    ),
                    VerticalSpacer(32),
                    // Countdown Timer Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: remainingTime.isNegative
                              ? [Colors.red.shade600, Colors.red.shade800]
                              : [AppColor.primary, AppColor.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (remainingTime.isNegative
                                        ? Colors.red
                                        : AppColor.primary)
                                    .withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            remainingTime.isNegative
                                ? 'TIME EXCEEDED!'
                                : 'Time Remaining',
                            style: AppStyle.styleMedium14.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          VerticalSpacer(12),
                          Text(
                            _formatDuration(remainingTime.abs()),
                            style: AppStyle.styleBold28.copyWith(
                              color: Colors.white,
                              fontSize: 36.sp,
                            ),
                          ),
                          if (remainingTime.isNegative) ...[
                            VerticalSpacer(8),
                            Text(
                              'Extra charges apply',
                              style: AppStyle.styleMedium12.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    VerticalSpacer(24),
                    // Elapsed Time Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.greyDD.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColor.greyDD, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: AppColor.primary,
                                size: 24.w,
                              ),
                              HorizontalSpacer(12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Elapsed Time',
                                    style: AppStyle.styleRegular12.copyWith(
                                      color: AppColor.lightGray,
                                    ),
                                  ),
                                  VerticalSpacer(4),
                                  Text(
                                    _formatDuration(duration),
                                    style: AppStyle.styleSemiBold16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Planned Duration',
                                style: AppStyle.styleRegular12.copyWith(
                                  color: AppColor.lightGray,
                                ),
                              ),
                              VerticalSpacer(4),
                              Text(
                                '${rental.durationMinutes} min',
                                style: AppStyle.styleSemiBold16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalSpacer(24),
                    // Cost Info
                    _InfoCard(
                      title: 'Current Cost',
                      value: '\$${currentCost.toStringAsFixed(2)}',
                      icon: Icons.attach_money,
                    ),
                    VerticalSpacer(16),
                    _InfoCard(
                      title: 'Price per Hour',
                      value: '\$${rental.pricePerHour.toStringAsFixed(2)}',
                      icon: Icons.price_change_outlined,
                    ),
                    VerticalSpacer(16),
                    _InfoCard(
                      title: 'Start Time',
                      value: _formatTime(rental.startTime),
                      icon: Icons.access_time,
                    ),
                    VerticalSpacer(16),
                    _InfoCard(
                      title: 'Start Location',
                      value: rental.startLocation ?? 'Unknown',
                      icon: Icons.location_on_outlined,
                    ),
                    VerticalSpacer(16),
                    _InfoCard(
                      title: 'Current Balance',
                      value: '\$${user?.balance.toStringAsFixed(2) ?? '0.00'}',
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ],
                ),
              ),
            ),
            // End Rental Button
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: rentalProvider.isLoading
                      ? null
                      : () => _endRental(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                  ),
                  child: rentalProvider.isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'End Rental',
                          style: AppStyle.styleSemiBold16.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _endRental(BuildContext context) async {
    final rentalProvider = context.read<RentalProvider>();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    final totalCost = rentalProvider.getCurrentCost();

    // Check if user has sufficient balance
    if (user != null && user.balance < totalCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Insufficient balance. Please add balance to your account.',
          ),
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Rental'),
        content: Text(
          'Total cost: \$${totalCost.toStringAsFixed(2)}\n\nAre you sure you want to end this rental?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // End rental - the station ID should be the bike's current station
      final stationId = rentalProvider.activeRental?.bike?.stationId ?? '';
      await rentalProvider.endRental(stationId);

      // Refresh user data to get updated balance and total rentals
      await authProvider.refreshUser();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rental ended successfully!')),
        );
        GoRouter.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColor.primary, size: 20.w),
          ),
          const HorizontalSpacer(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.styleRegular12.copyWith(
                    color: AppColor.lightGray,
                  ),
                ),
                VerticalSpacer(2),
                Text(value, style: AppStyle.styleMedium14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
