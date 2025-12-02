import 'package:flutter/material.dart';
import '../data/model/bike_model.dart';
import '../data/model/station_model.dart';

class BikeProvider extends ChangeNotifier {
  List<BikeModel> _bikes = [];
  List<StationModel> _nearbyStations = [];
  BikeModel? _selectedBike;
  bool _isLoading = false;
  String? _error;

  List<BikeModel> get bikes => _bikes;
  List<StationModel> get nearbyStations => _nearbyStations;
  BikeModel? get selectedBike => _selectedBike;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch available bikes
  Future<void> fetchBikes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch bikes
      // For now, create mock bikes
      _bikes = [
        BikeModel(
          id: '1',
          bikeNumber: 'BIKE-001',
          name: 'City Cruiser',
          imageUrl: 'https://via.placeholder.com/300x200',
          pricePerHour: 5.0,
          status: BikeStatus.available,
          currentLocation: 'Downtown Station',
          latitude: 40.7128,
          longitude: -74.0060,
          stationId: 'station-1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        BikeModel(
          id: '2',
          bikeNumber: 'BIKE-002',
          name: 'Mountain Explorer',
          imageUrl: 'https://via.placeholder.com/300x200',
          pricePerHour: 8.0,
          status: BikeStatus.available,
          currentLocation: 'Central Park Station',
          latitude: 40.7829,
          longitude: -73.9654,
          stationId: 'station-2',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch nearby stations
  Future<void> fetchNearbyStations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to fetch nearby stations
      // For now, create mock stations
      _nearbyStations = [
        StationModel(
          id: 'station-1',
          name: 'Downtown Station',
          address: '123 Main Street',
          latitude: 40.7128,
          longitude: -74.0060,
          totalSlots: 20,
          availableSlots: 8,
          availableBikes: 12,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        StationModel(
          id: 'station-2',
          name: 'Central Park Station',
          address: '456 Park Avenue',
          latitude: 40.7829,
          longitude: -73.9654,
          totalSlots: 15,
          availableSlots: 5,
          availableBikes: 10,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get bike by QR code
  Future<BikeModel?> getBikeByQRCode(String qrCode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement API call to get bike by QR code
      // For now, simulate fetching a bike
      await Future.delayed(const Duration(seconds: 1));

      final bike = BikeModel(
        id: qrCode,
        bikeNumber: qrCode,
        name: 'City Cruiser',
        imageUrl: 'https://via.placeholder.com/300x200',
        pricePerHour: 5.0,
        status: BikeStatus.available,
        currentLocation: 'Downtown Station',
        latitude: 40.7128,
        longitude: -74.0060,
        stationId: 'station-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _selectedBike = bike;
      _isLoading = false;
      notifyListeners();
      return bike;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void setSelectedBike(BikeModel? bike) {
    _selectedBike = bike;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
