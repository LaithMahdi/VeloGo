import 'package:flutter/material.dart';
import '../data/model/bike_model.dart';
import '../data/model/station_model.dart';
import '../data/service/bike_service.dart';
import '../data/service/station_service.dart';

class BikeProvider extends ChangeNotifier {
  final BikeService _bikeService = BikeService();
  final StationService _stationService = StationService();

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
  Future<void> fetchBikes({String? status = 'available'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bikes = await _bikeService.fetchBikes(status: status);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch nearby stations
  Future<void> fetchNearbyStations({
    double? latitude,
    double? longitude,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _nearbyStations = await _stationService.fetchNearbyStations(
        latitude: latitude,
        longitude: longitude,
      );
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
      final bike = await _bikeService.fetchBikeByQRCode(qrCode);

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

  // Get bikes by station
  Future<void> fetchBikesByStation(String stationId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bikes = await _bikeService.fetchBikesByStation(stationId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
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
