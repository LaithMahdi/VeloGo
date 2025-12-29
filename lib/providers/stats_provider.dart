import 'package:flutter/foundation.dart';
import '../data/service/stats_service.dart';

class StatsProvider with ChangeNotifier {
  final StatsService _statsService = StatsService();

  int _totalProfiles = 0;
  double _totalBalance = 0.0;
  int _totalRentals = 0;
  bool _isLoading = false;
  String? _error;

  int get totalProfiles => _totalProfiles;
  double get totalBalance => _totalBalance;
  int get totalRentals => _totalRentals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch all statistics
  Future<void> fetchAllStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final stats = await _statsService.getAllStats();
      _totalProfiles = stats['totalProfiles'] as int;
      _totalBalance = stats['totalBalance'] as double;
      _totalRentals = stats['totalRentals'] as int;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch total profiles
  Future<void> fetchTotalProfiles() async {
    try {
      _totalProfiles = await _statsService.getTotalProfiles();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Fetch total balance
  Future<void> fetchTotalBalance() async {
    try {
      _totalBalance = await _statsService.getTotalBalance();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Fetch total rentals
  Future<void> fetchTotalRentals() async {
    try {
      _totalRentals = await _statsService.getTotalRentals();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
