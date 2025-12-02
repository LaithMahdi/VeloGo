import 'package:flutter/material.dart';
import '../data/model/rental_model.dart';
import '../data/model/bike_model.dart';

class RentalProvider extends ChangeNotifier {
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
  Future<void> startRental(BikeModel bike, String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to start rental
      // For now, create a mock rental
      final rental = RentalModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        bikeId: bike.id,
        bike: bike,
        startTime: DateTime.now(),
        status: RentalStatus.active,
        startLocation: bike.currentLocation,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
  Future<void> endRental(double totalCost) async {
    if (_activeRental == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to end rental
      final endTime = DateTime.now();
      final duration = endTime.difference(_activeRental!.startTime).inMinutes;

      final completedRental = _activeRental!.copyWith(
        endTime: endTime,
        duration: duration,
        totalCost: totalCost,
        status: RentalStatus.completed,
        updatedAt: endTime,
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
      // TODO: Implement API call to fetch rental history
      // For now, use existing history
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
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
    return _activeRental!.calculateCurrentCost(
      _activeRental!.bike!.pricePerHour,
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
