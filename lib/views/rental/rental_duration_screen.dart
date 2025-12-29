import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../core/constant/app_router.dart';
import '../../data/model/bike_model.dart';
import '../../providers/rental_provider.dart';
import '../../providers/auth_provider.dart';
import '../../shared/spacer.dart';

class RentalDurationScreen extends StatefulWidget {
  final BikeModel bike;

  const RentalDurationScreen({super.key, required this.bike});

  @override
  State<RentalDurationScreen> createState() => _RentalDurationScreenState();
}

class _RentalDurationScreenState extends State<RentalDurationScreen> {
  int _selectedDuration = 60; // Default 1 hour in minutes
  final double _pricePerHour = 5.0;

  final List<Map<String, dynamic>> _durations = [
    {'label': '30 minutes', 'minutes': 30},
    {'label': '1 hour', 'minutes': 60},
    {'label': '2 hours', 'minutes': 120},
    {'label': '3 hours', 'minutes': 180},
    {'label': '4 hours', 'minutes': 240},
    {'label': '6 hours', 'minutes': 360},
    {'label': '12 hours', 'minutes': 720},
    {'label': '24 hours', 'minutes': 1440},
  ];

  double get _totalCost {
    return (_selectedDuration / 60) * _pricePerHour;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Duration',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bike Info
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: AppColor.greyDD,
                              borderRadius: BorderRadius.circular(8.r),
                              image: widget.bike.imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        widget.bike.imageUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: widget.bike.imageUrl == null
                                ? Icon(
                                    Icons.pedal_bike,
                                    size: 30.w,
                                    color: AppColor.lightGray,
                                  )
                                : null,
                          ),
                          const HorizontalSpacer(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.bike.model,
                                  style: AppStyle.styleSemiBold16,
                                ),
                                VerticalSpacer(4),
                                Text(
                                  widget.bike.qrCode,
                                  style: AppStyle.styleRegular12.copyWith(
                                    color: AppColor.lightGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalSpacer(24),

                    // Duration Selection
                    Text('Select Rental Duration', style: AppStyle.styleBold18),
                    VerticalSpacer(16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _durations.length,
                      separatorBuilder: (context, index) => VerticalSpacer(12),
                      itemBuilder: (context, index) {
                        final duration = _durations[index];
                        final minutes = duration['minutes'] as int;
                        final label = duration['label'] as String;
                        final cost = (minutes / 60) * _pricePerHour;
                        final isSelected = _selectedDuration == minutes;

                        return InkWell(
                          onTap: () =>
                              setState(() => _selectedDuration = minutes),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColor.primary.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.primary
                                    : AppColor.greyDD,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? AppColor.primary
                                      : AppColor.lightGray,
                                ),
                                const HorizontalSpacer(16),
                                Expanded(
                                  child: Text(
                                    label,
                                    style: AppStyle.styleSemiBold16.copyWith(
                                      color: isSelected
                                          ? AppColor.primary
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${cost.toStringAsFixed(2)}',
                                  style: AppStyle.styleBold16.copyWith(
                                    color: AppColor.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    VerticalSpacer(24),

                    // Price Breakdown
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColor.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price per hour',
                                style: AppStyle.styleRegular14,
                              ),
                              Text(
                                '\$${_pricePerHour.toStringAsFixed(2)}',
                                style: AppStyle.styleSemiBold14,
                              ),
                            ],
                          ),
                          VerticalSpacer(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Duration', style: AppStyle.styleRegular14),
                              Text(
                                _durations.firstWhere(
                                  (d) => d['minutes'] == _selectedDuration,
                                )['label'],
                                style: AppStyle.styleSemiBold14,
                              ),
                            ],
                          ),
                          VerticalSpacer(12),
                          Divider(color: AppColor.greyDD),
                          VerticalSpacer(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Cost', style: AppStyle.styleBold16),
                              Text(
                                '\$${_totalCost.toStringAsFixed(2)}',
                                style: AppStyle.styleBold18.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confirm Button
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
                  onPressed: () => _confirmRental(context),
                  child: Text(
                    'Confirm Rental',
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

  Future<void> _confirmRental(BuildContext context) async {
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
      await rentalProvider.startRental(
        widget.bike,
        user.id,
        durationMinutes: _selectedDuration,
        pricePerHour: _pricePerHour,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bike rented successfully!')),
        );
        GoRouter.of(context).go(AppRouter.mainNavigation);
        GoRouter.of(context).push(AppRouter.activeRental);
      }
    } catch (e) {
      print("Error renting bike: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
