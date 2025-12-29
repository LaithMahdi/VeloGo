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
import '../../providers/stats_provider.dart';
import '../../shared/spacer.dart';
import 'widgets/active_rental_card.dart';
import 'widgets/home_empty_station.dart';
import 'widgets/home_header_appbar.dart';
import 'widgets/station_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BikeProvider>().fetchNearbyStations();
      context.read<StatsProvider>().fetchAllStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bikeProvider = context.watch<BikeProvider>();
    final rentalProvider = context.watch<RentalProvider>();
    final statsProvider = context.watch<StatsProvider>();
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
          await Future.wait([
            bikeProvider.fetchNearbyStations(),
            statsProvider.fetchAllStats(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeaderAppbar(
                user: user,
                totalProfiles: statsProvider.totalProfiles,
                totalBalance: statsProvider.totalBalance,
                totalRentals: statsProvider.totalRentals,
                isLoadingStats: statsProvider.isLoading,
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
                      ActiveRentalCard(
                        onTap: () =>
                            GoRouter.of(context).push(AppRouter.activeRental),
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
                      HomeEmptyStation()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bikeProvider.nearbyStations.length,
                        separatorBuilder: (context, index) =>
                            VerticalSpacer(12),
                        itemBuilder: (context, index) {
                          return StationCard(
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
}
