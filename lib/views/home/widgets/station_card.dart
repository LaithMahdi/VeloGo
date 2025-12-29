import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../core/constant/app_router.dart';
import '../../../data/model/station_model.dart';
import '../../../shared/spacer.dart';
import 'station_info.dart';

class StationCard extends StatelessWidget {
  final StationModel station;

  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push(AppRouter.stationDetail, extra: station);
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
              color: Colors.black.withValues(alpha: .05),
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
                    color: AppColor.primary.withValues(alpha: 0.1),
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
                  child: StationInfo(
                    icon: Icons.pedal_bike,
                    label: 'Available Bikes',
                    value: '${station.availableBikes}',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: StationInfo(
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
      ),
    );
  }
}
