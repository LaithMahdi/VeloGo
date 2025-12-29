import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../core/constant/app_router.dart';
import '../../data/model/station_model.dart';
import '../../data/model/bike_model.dart';
import '../../providers/bike_provider.dart';
import '../../shared/spacer.dart';

class StationDetailScreen extends StatefulWidget {
  final StationModel station;

  const StationDetailScreen({super.key, required this.station});

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BikeProvider>().fetchBikesByStation(widget.station.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bikeProvider = context.watch<BikeProvider>();
    final bikes = bikeProvider.bikes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.station.name,
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<BikeProvider>().fetchBikesByStation(
            widget.station.id,
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Station Image
              if (widget.station.imageUrl != null)
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.station.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Station Info
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColor.primary,
                          size: 20.w,
                        ),
                        const HorizontalSpacer(8),
                        Expanded(
                          child: Text(
                            widget.station.address,
                            style: AppStyle.styleRegular14.copyWith(
                              color: AppColor.lightGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: AppColor.primary,
                          size: 20.w,
                        ),
                        const HorizontalSpacer(8),
                        Text(
                          widget.station.city,
                          style: AppStyle.styleRegular14.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColor.primary,
                          size: 20.w,
                        ),
                        const HorizontalSpacer(8),
                        Text(
                          widget.station.operatingHours,
                          style: AppStyle.styleRegular14.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                    if (widget.station.description != null) ...[
                      VerticalSpacer(16),
                      Text(
                        widget.station.description!,
                        style: AppStyle.styleRegular14,
                      ),
                    ],
                    VerticalSpacer(24),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.pedal_bike,
                            label: 'Available Bikes',
                            value: '${widget.station.availableBikes}',
                            color: Colors.green,
                          ),
                        ),
                        const HorizontalSpacer(12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.local_parking,
                            label: 'Free Slots',
                            value: '${widget.station.availableSlots}',
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.storage,
                            label: 'Total Capacity',
                            value: '${widget.station.totalCapacity}',
                            color: AppColor.secondary,
                          ),
                        ),
                        const HorizontalSpacer(12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.check_circle,
                            label: 'Status',
                            value: widget.station.status.toUpperCase(),
                            color: widget.station.isActive
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(24),

                    // Available Bikes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Available Bikes', style: AppStyle.styleBold18),
                        Text(
                          '${bikes.length} bikes',
                          style: AppStyle.styleRegular14.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                    VerticalSpacer(12),

                    if (bikeProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (bikes.isEmpty)
                      _EmptyBikes()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bikes.length,
                        separatorBuilder: (context, index) =>
                            VerticalSpacer(12),
                        itemBuilder: (context, index) {
                          return _BikeCard(bike: bikes[index]);
                        },
                      ),
                  ],
                ),
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
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.w),
          VerticalSpacer(8),
          Text(value, style: AppStyle.styleBold20.copyWith(color: color)),
          VerticalSpacer(4),
          Text(
            label,
            style: AppStyle.styleRegular12.copyWith(color: AppColor.lightGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BikeCard extends StatelessWidget {
  final BikeModel bike;

  const _BikeCard({required this.bike});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<BikeProvider>().setSelectedBike(bike);
        GoRouter.of(context).push(AppRouter.bikeProfile);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.greyDD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Bike Image
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColor.greyDD,
                borderRadius: BorderRadius.circular(8.r),
                image: bike.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(bike.imageUrl!),
                        fit: BoxFit.fill,
                      )
                    : null,
              ),
              child: bike.imageUrl == null
                  ? Icon(
                      Icons.pedal_bike,
                      size: 40.w,
                      color: AppColor.lightGray,
                    )
                  : null,
            ),
            const HorizontalSpacer(16),
            // Bike Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bike.model, style: AppStyle.styleSemiBold16),
                  VerticalSpacer(4),
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: 14.w,
                        color: AppColor.lightGray,
                      ),
                      const HorizontalSpacer(4),
                      Text(
                        bike.qrCode,
                        style: AppStyle.styleRegular12.copyWith(
                          color: AppColor.lightGray,
                        ),
                      ),
                    ],
                  ),
                  VerticalSpacer(4),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8.w,
                        color: bike.isAvailable ? Colors.green : Colors.grey,
                      ),
                      const HorizontalSpacer(4),
                      Text(
                        bike.bikeType.toUpperCase(),
                        style: AppStyle.styleRegular12.copyWith(
                          color: AppColor.lightGray,
                        ),
                      ),
                      if (bike.batteryLevel != null) ...[
                        const HorizontalSpacer(8),
                        Icon(
                          Icons.battery_charging_full,
                          size: 14.w,
                          color: bike.hasLowBattery ? Colors.red : Colors.green,
                        ),
                        const HorizontalSpacer(4),
                        Text(
                          '${bike.batteryLevel}%',
                          style: AppStyle.styleRegular12.copyWith(
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColor.lightGray, size: 24.w),
          ],
        ),
      ),
    );
  }
}

class _EmptyBikes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(Icons.pedal_bike, size: 60.w, color: AppColor.lightGray),
          VerticalSpacer(16),
          Text(
            'No bikes available',
            style: AppStyle.styleMedium16.copyWith(color: AppColor.lightGray),
          ),
          VerticalSpacer(8),
          Text(
            'Check back later or try another station',
            style: AppStyle.styleRegular14.copyWith(color: AppColor.lightGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
