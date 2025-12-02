import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../core/constant/app_router.dart';
import '../../providers/bike_provider.dart';
import '../../shared/spacer.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _qrCodeController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _qrCodeController.dispose();
    super.dispose();
  }

  Future<void> _simulateScan() async {
    if (_qrCodeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a bike ID')));
      return;
    }

    setState(() => _isScanning = true);

    final bikeProvider = context.read<BikeProvider>();
    final bike = await bikeProvider.getBikeByQRCode(_qrCodeController.text);

    setState(() => _isScanning = false);

    if (bike != null && mounted) {
      GoRouter.of(context).push(AppRouter.bikeProfile);
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bike not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Bike',
          style: AppStyle.styleSemiBold20.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, size: 120.w, color: AppColor.primary),
              VerticalSpacer(32),
              Text(
                'Scan QR Code',
                style: AppStyle.styleBold24,
                textAlign: TextAlign.center,
              ),
              VerticalSpacer(12),
              Text(
                'Point your camera at the bike\'s QR code to start renting',
                style: AppStyle.styleRegular14.copyWith(
                  color: AppColor.lightGray,
                ),
                textAlign: TextAlign.center,
              ),
              VerticalSpacer(40),
              // Simulated QR Scanner (for demo purposes)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.greyDD),
                ),
                child: Column(
                  children: [
                    Text(
                      'Demo Mode: Enter Bike ID',
                      style: AppStyle.styleMedium14.copyWith(
                        color: AppColor.lightGray,
                      ),
                    ),
                    VerticalSpacer(12),
                    TextField(
                      controller: _qrCodeController,
                      decoration: InputDecoration(
                        hintText: 'Enter bike ID (e.g., BIKE-001)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    VerticalSpacer(16),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _isScanning ? null : _simulateScan,
                        child: _isScanning
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
                                'Scan Bike',
                                style: AppStyle.styleSemiBold16.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSpacer(24),
              Text(
                'Note: In production, this would use the camera to scan actual QR codes',
                style: AppStyle.styleRegular12.copyWith(
                  color: AppColor.lightGray,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
