import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_bike/core/config.dart';
import '../core/constant/app_router.dart';
import '../core/service/storage_service.dart';

class OnboardingProvider extends ChangeNotifier {
  int currentPage = 0;
  PageController controller = PageController();

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage(BuildContext context) {
    if (!isLastPage) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      GoRouter.of(context).go(AppRouter.login);
      StorageService.instance.setBool(Config.onboardingSeenKey, true);
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skip() {
    controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool get isLastPage => currentPage == 2;
}
