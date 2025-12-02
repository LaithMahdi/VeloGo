import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../providers/rental_provider.dart';
import '../../shared/spacer.dart';
import '../../data/model/rental_model.dart';

class RentalHistoryScreen extends StatefulWidget {
  const RentalHistoryScreen({super.key});

  @override
  State<RentalHistoryScreen> createState() => _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends State<RentalHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch rental history when screen loads
    // TODO: Uncomment when backend is ready
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final rentalProvider = context.read<RentalProvider>();
    //   final authProvider = context.read<AuthProvider>();
    //   rentalProvider.fetchRentalHistory(authProvider.currentUser?.id ?? '');
    // });
  }

  @override
  Widget build(BuildContext context) {
    final rentalProvider = context.watch<RentalProvider>();
    final rentals = rentalProvider.rentalHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rental History',
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: rentalProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : rentals.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                padding: EdgeInsets.all(24.w),
                itemCount: rentals.length,
                separatorBuilder: (context, index) => VerticalSpacer(16),
                itemBuilder: (context, index) {
                  return _RentalCard(rental: rentals[index]);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80.w, color: AppColor.lightGray),
          VerticalSpacer(16),
          Text(
            'No rental history yet',
            style: AppStyle.styleMedium16.copyWith(color: AppColor.lightGray),
          ),
          VerticalSpacer(8),
          Text(
            'Your completed rentals will appear here',
            style: AppStyle.styleRegular14.copyWith(color: AppColor.lightGray),
          ),
        ],
      ),
    );
  }
}

class _RentalCard extends StatelessWidget {
  final RentalModel rental;

  const _RentalCard({required this.rental});

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
            blurRadius: 10,
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
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColor.greyDD,
                  borderRadius: BorderRadius.circular(8.r),
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
                        size: 30.w,
                        color: AppColor.lightGray,
                      )
                    : null,
              ),
              const HorizontalSpacer(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.bike?.name ?? 'Bike',
                      style: AppStyle.styleSemiBold16,
                    ),
                    VerticalSpacer(4),
                    Text(
                      rental.bike?.bikeNumber ?? '',
                      style: AppStyle.styleRegular12.copyWith(
                        color: AppColor.lightGray,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: rental.status),
            ],
          ),
          VerticalSpacer(16),
          Divider(color: AppColor.greyDD, height: 1),
          VerticalSpacer(16),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.access_time,
                  label: 'Duration',
                  value: rental.durationFormatted,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  icon: Icons.attach_money,
                  label: 'Cost',
                  value: '\$${rental.totalCost?.toStringAsFixed(2) ?? '0.00'}',
                ),
              ),
            ],
          ),
          VerticalSpacer(12),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: _formatDate(rental.startTime),
                ),
              ),
              Expanded(
                child: _InfoItem(
                  icon: Icons.schedule,
                  label: 'Time',
                  value: _formatTime(rental.startTime),
                ),
              ),
            ],
          ),
          if (rental.startLocation != null) ...[
            VerticalSpacer(12),
            _InfoItem(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: rental.startLocation!,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusBadge extends StatelessWidget {
  final RentalStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case RentalStatus.active:
        color = Colors.green;
        text = 'Active';
        break;
      case RentalStatus.completed:
        color = AppColor.primary;
        text = 'Completed';
        break;
      case RentalStatus.cancelled:
        color = AppColor.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(text, style: AppStyle.styleSemiBold10.copyWith(color: color)),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.w, color: AppColor.lightGray),
        const HorizontalSpacer(6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyle.styleRegular10.copyWith(
                  color: AppColor.lightGray,
                ),
              ),
              Text(
                value,
                style: AppStyle.styleMedium12,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
