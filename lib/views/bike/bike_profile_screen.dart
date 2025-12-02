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
                    Text(bike.name, style: AppStyle.styleBold24),
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
                          bike.bikeNumber,
                          style: AppStyle.styleRegular14.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(24),
                    // Status Badge
                    _StatusBadge(status: bike.status),
                    VerticalSpacer(24),
                    // Details
                    _DetailRow(
                      icon: Icons.attach_money,
                      label: 'Price per hour',
                      value: '\$${bike.pricePerHour.toStringAsFixed(2)}',
                    ),
                    VerticalSpacer(16),
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'Current Location',
                      value: bike.currentLocation ?? 'Unknown',
                    ),
                    VerticalSpacer(24),
                    // Rental Cost Estimation
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
                            'Rental Cost Estimation',
                            style: AppStyle.styleSemiBold16,
                          ),
                          VerticalSpacer(12),
                          _CostRow(duration: '1 hour', cost: bike.pricePerHour),
                          VerticalSpacer(8),
                          _CostRow(
                            duration: '2 hours',
                            cost: bike.pricePerHour * 2,
                          ),
                          VerticalSpacer(8),
                          _CostRow(
                            duration: '1 day (24h)',
                            cost: bike.pricePerHour * 24,
                          ),
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
      case BikeStatus.inUse:
        color = Colors.orange;
        text = 'In Use';
        break;
      case BikeStatus.maintenance:
        color = Colors.red;
        text = 'Maintenance';
        break;
      case BikeStatus.unavailable:
        color = AppColor.lightGray;
        text = 'Unavailable';
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

class _CostRow extends StatelessWidget {
  final String duration;
  final double cost;

  const _CostRow({required this.duration, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(duration, style: AppStyle.styleRegular14),
        Text(
          '\$${cost.toStringAsFixed(2)}',
          style: AppStyle.styleSemiBold14.copyWith(color: AppColor.primary),
        ),
      ],
    );
  }
}
