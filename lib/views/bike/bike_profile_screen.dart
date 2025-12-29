import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../core/constant/app_router.dart';
import '../../providers/bike_provider.dart';
import '../../providers/rental_provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/spacer.dart';
import '../../data/model/bike_model.dart';

class BikeProfileScreen extends StatelessWidget {
  const BikeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bikeProvider = context.watch<BikeProvider>();
    final bike = bikeProvider.selectedBike;

    if (bike == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bike Profile'),
          backgroundColor: AppColor.primary,
        ),
        body: const Center(child: Text('No bike selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bike Profile',
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bike Image
                    Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.greyDD,
                        borderRadius: BorderRadius.circular(16.r),
                        image: bike.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(bike.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: bike.imageUrl == null
                          ? Icon(
                              Icons.pedal_bike,
                              size: 80.w,
                              color: AppColor.lightGray,
                            )
                          : null,
                    ),
                    VerticalSpacer(24),
                    // Bike Name & ID
                    Text(bike.model, style: AppStyle.styleBold24),
                    VerticalSpacer(8),
                    Row(
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 16.w,
                          color: AppColor.lightGray,
                        ),
                        const HorizontalSpacer(4),
                        Text(
                          bike.qrCode,
                          style: AppStyle.styleRegular14.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(24),
                    // Status Badge
                    _StatusBadge(status: BikeStatus.fromString(bike.status)),
                    VerticalSpacer(24),
                    // Details
                    _DetailRow(
                      icon: Icons.pedal_bike,
                      label: 'Bike Type',
                      value: bike.bikeType.toUpperCase(),
                    ),
                    VerticalSpacer(16),
                    _DetailRow(
                      icon: Icons.color_lens_outlined,
                      label: 'Color',
                      value: bike.color ?? 'Not specified',
                    ),
                    if (bike.batteryLevel != null) ...[
                      VerticalSpacer(16),
                      _DetailRow(
                        icon: Icons.battery_charging_full,
                        label: 'Battery Level',
                        value: '${bike.batteryLevel}%',
                      ),
                    ],
                    VerticalSpacer(24),
                    // Stats
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bike Statistics',
                            style: AppStyle.styleSemiBold16,
                          ),
                          VerticalSpacer(12),
                          Row(
                            children: [
                              Expanded(
                                child: _StatItem(
                                  label: 'Total Rentals',
                                  value: '${bike.totalRentals}',
                                ),
                              ),
                              Expanded(
                                child: _StatItem(
                                  label: 'Distance',
                                  value:
                                      '${bike.totalDistance.toStringAsFixed(1)} km',
                                ),
                              ),
                            ],
                          ),
                          if (bike.conditionScore != null) ...[
                            VerticalSpacer(12),
                            _StatItem(
                              label: 'Condition Score',
                              value: '${bike.conditionScore}/100',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Rent Button
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
                  onPressed: bike.status == BikeStatus.available
                      ? () => _handleRentBike(context, bike)
                      : null,
                  child: Text(
                    bike.status == BikeStatus.available
                        ? 'Rent This Bike'
                        : 'Not Available',
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

  Future<void> _handleRentBike(BuildContext context, BikeModel bike) async {
    final rentalProvider = context.read<RentalProvider>();
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to rent a bike')),
      );
      return;
    }

    if (rentalProvider.hasActiveRental) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already have an active rental')),
      );
      return;
    }

    try {
      await rentalProvider.startRental(bike, user.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bike rented successfully!')),
        );
        GoRouter.of(context).push(AppRouter.activeRental);
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

class _StatusBadge extends StatelessWidget {
  final BikeStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case BikeStatus.available:
        color = Colors.green;
        text = 'Available';
        break;
      case BikeStatus.rented:
        color = Colors.orange;
        text = 'Rented';
        break;
      case BikeStatus.maintenance:
        color = Colors.red;
        text = 'Maintenance';
        break;
      case BikeStatus.damaged:
        color = AppColor.red;
        text = 'Damaged';
        break;
      case BikeStatus.retired:
        color = AppColor.lightGray;
        text = 'Retired';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color),
      ),
      child: Text(text, style: AppStyle.styleSemiBold12.copyWith(color: color)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: AppColor.primary),
        const HorizontalSpacer(12),
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
              VerticalSpacer(2),
              Text(value, style: AppStyle.styleMedium14),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyle.styleRegular12.copyWith(color: AppColor.lightGray),
        ),
        VerticalSpacer(4),
        Text(value, style: AppStyle.styleSemiBold16),
      ],
    );
  }
}
