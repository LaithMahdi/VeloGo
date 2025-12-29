import 'package:flutter/material.dart';
import '../data/model/rental_model.dart';
import '../data/model/bike_model.dart';
import '../data/service/rental_service.dart';

class RentalProvider extends ChangeNotifier {
  final RentalService _rentalService = RentalService();
  RentalModel? _activeRental;
  final List<RentalModel> _rentalHistory = [];
  bool _isLoading = false;
  String? _error;

  RentalModel? get activeRental => _activeRental;
  List<RentalModel> get rentalHistory => _rentalHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveRental => _activeRental != null;

  // Start a new rental
  Future<void> startRental(
    BikeModel bike,
    String userId, {
    required int durationMinutes,
    double pricePerHour = 5.0,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Call Supabase to insert rental in database
      print(
        "userId : $userId, bikeId: ${bike.id}, duration: $durationMinutes, pricePerHour: $pricePerHour",
      );
      final rental = await _rentalService.startRental(
        userId: userId,
        bikeId: bike.id,
        durationMinutes: durationMinutes,
        pricePerHour: pricePerHour,
      );

      _activeRental = rental;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // End the active rental
  Future<void> endRental(String stationId) async {
    if (_activeRental == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Call Supabase to complete rental in database
      final completedRental = await _rentalService.completeRental(
        rentalId: _activeRental!.id,
        stationId: stationId,
      );

      _rentalHistory.insert(0, completedRental);
      _activeRental = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch rental history
  Future<void> fetchRentalHistory(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch rental history from database
      final history = await _rentalService.getRentalHistory(userId);
      _rentalHistory.clear();
      _rentalHistory.addAll(history);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch active rental
  Future<void> fetchActiveRental(String userId) async {
    try {
      _activeRental = await _rentalService.getActiveRental(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get current rental duration
  Duration getCurrentRentalDuration() {
    if (_activeRental == null) return Duration.zero;
    return DateTime.now().difference(_activeRental!.startTime);
  }

  // Calculate current cost
  double getCurrentCost() {
    if (_activeRental == null || _activeRental!.bike == null) return 0.0;
    return _activeRental!.calculateCurrentCost();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
