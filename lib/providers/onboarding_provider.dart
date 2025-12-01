import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rent_bike/core/config.dart';
import '../core/constant/app_router.dart';
import '../core/service/storage_service.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentPage = 0;
  final PageController _controller = PageController();

  // Getters
  int get currentPage => _currentPage;
  PageController get controller => _controller;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage(BuildContext context) {
    if (!isLastPage) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      GoRouter.of(context).go(AppRouter.login);
      StorageService.instance.setBool(Config.onboardingSeenKey, true);
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skip() {
    _controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool get isLastPage => _currentPage == 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
