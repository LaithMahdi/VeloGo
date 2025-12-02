import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_router.dart';
import '../../core/constant/app_style.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bike_provider.dart';
import '../../providers/rental_provider.dart';
import '../../shared/spacer.dart';
import '../../data/model/station_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch bikes and stations when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BikeProvider>().fetchNearbyStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bikeProvider = context.watch<BikeProvider>();
    final rentalProvider = context.watch<RentalProvider>();
    final user = authProvider.currentUser;
    final activeRental = rentalProvider.activeRental;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VeloGo',
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await bikeProvider.fetchNearbyStations();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Gradient
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.primary, AppColor.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: AppStyle.styleMedium14.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    VerticalSpacer(4),
                    Text(
                      user?.fullName ?? user?.email ?? 'User',
                      style: AppStyle.styleBold20.copyWith(color: Colors.white),
                    ),
                    VerticalSpacer(24),
                    // Balance & Rentals Stats
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.account_balance_wallet,
                            title: 'Balance',
                            value:
                                '\$${user?.balance.toStringAsFixed(2) ?? '0.00'}',
                            color: Colors.white,
                          ),
                        ),
                        const HorizontalSpacer(16),
                        Expanded(
                          child: _StatCard(
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
              ),

              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active Rental Card (if exists)
                    if (activeRental != null) ...[
                      Text('Active Rental', style: AppStyle.styleBold18),
                      VerticalSpacer(12),
                      _ActiveRentalCard(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.activeRental);
                        },
                      ),
                      VerticalSpacer(24),
                    ],

                    // Nearby Stations
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nearby Stations', style: AppStyle.styleBold18),
                        if (bikeProvider.nearbyStations.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              // TODO: Navigate to all stations
                            },
                            child: Text(
                              'View All',
                              style: AppStyle.styleSemiBold14.copyWith(
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    VerticalSpacer(12),
                    if (bikeProvider.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (bikeProvider.nearbyStations.isEmpty)
                      _buildEmptyStations()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bikeProvider.nearbyStations.length,
                        separatorBuilder: (context, index) =>
                            VerticalSpacer(12),
                        itemBuilder: (context, index) {
                          return _StationCard(
                            station: bikeProvider.nearbyStations[index],
                          );
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

  Widget _buildEmptyStations() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 60.w,
            color: AppColor.lightGray,
          ),
          VerticalSpacer(16),
          Text(
            'No nearby stations found',
            style: AppStyle.styleMedium14.copyWith(color: AppColor.lightGray),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
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
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
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
              color: color.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveRentalCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ActiveRentalCard({required this.onTap});

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
                color: Colors.white.withOpacity(0.2),
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
                      color: Colors.white.withOpacity(0.9),
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

class _StationCard extends StatelessWidget {
  final StationModel station;

  const _StationCard({required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppColor.primary,
                  size: 20.w,
                ),
              ),
              const HorizontalSpacer(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(station.name, style: AppStyle.styleSemiBold16),
                    VerticalSpacer(2),
                    Text(
                      station.address,
                      style: AppStyle.styleRegular12.copyWith(
                        color: AppColor.lightGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          VerticalSpacer(12),
          Row(
            children: [
              Expanded(
                child: _StationInfo(
                  icon: Icons.pedal_bike,
                  label: 'Available Bikes',
                  value: '${station.availableBikes}',
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: _StationInfo(
                  icon: Icons.local_parking,
                  label: 'Free Slots',
                  value: '${station.availableSlots}',
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StationInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StationInfo({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: color),
        const HorizontalSpacer(6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppStyle.styleSemiBold14.copyWith(color: color)),
            Text(
              label,
              style: AppStyle.styleRegular10.copyWith(
                color: AppColor.lightGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
