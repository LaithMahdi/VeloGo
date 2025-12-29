import 'bike_model.dart';
import 'station_model.dart';

/// Detailed bike model with station information
class BikeDetailModel {
  final BikeModel bike;
  final StationModel? station;

  BikeDetailModel({required this.bike, this.station});

  factory BikeDetailModel.fromJson(Map<String, dynamic> json) {
    return BikeDetailModel(
      bike: BikeModel.fromJson(json),
      station: json['stations'] != null
          ? StationModel.fromJson(json['stations'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...bike.toJson(),
      if (station != null) 'stations': station!.toJson(),
    };
  }

  // Convenience getters
  String get id => bike.id;
  String get qrCode => bike.qrCode;
  String get model => bike.model;
  String get bikeType => bike.bikeType;
  String get status => bike.status;
  String? get imageUrl => bike.imageUrl;
  String? get color => bike.color;
  int? get batteryLevel => bike.batteryLevel;
  int? get conditionScore => bike.conditionScore;
  int get totalRentals => bike.totalRentals;
  double get totalDistance => bike.totalDistance;

  bool get isAvailable => bike.isAvailable;
  bool get isRented => bike.isRented;
  bool get needsMaintenance => bike.needsMaintenance;
  bool get isElectric => bike.isElectric;
  bool get hasLowBattery => bike.hasLowBattery;

  String? get stationName => station?.name;
  String? get stationAddress => station?.address;
  String? get stationCity => station?.city;

  BikeDetailModel copyWith({BikeModel? bike, StationModel? station}) {
    return BikeDetailModel(
      bike: bike ?? this.bike,
      station: station ?? this.station,
    );
  }
}
