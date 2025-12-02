class BikeModel {
  final String id;
  final String bikeNumber;
  final String name;
  final String? imageUrl;
  final double pricePerHour;
  final BikeStatus status;
  final String? currentLocation;
  final double? latitude;
  final double? longitude;
  final String? stationId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BikeModel({
    required this.id,
    required this.bikeNumber,
    required this.name,
    this.imageUrl,
    required this.pricePerHour,
    required this.status,
    this.currentLocation,
    this.latitude,
    this.longitude,
    this.stationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BikeModel.fromJson(Map<String, dynamic> json) {
    return BikeModel(
      id: json['id'] as String,
      bikeNumber: json['bike_number'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      status: BikeStatus.fromString(json['status'] as String),
      currentLocation: json['current_location'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      stationId: json['station_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bike_number': bikeNumber,
      'name': name,
      'image_url': imageUrl,
      'price_per_hour': pricePerHour,
      'status': status.value,
      'current_location': currentLocation,
      'latitude': latitude,
      'longitude': longitude,
      'station_id': stationId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BikeModel copyWith({
    String? id,
    String? bikeNumber,
    String? name,
    String? imageUrl,
    double? pricePerHour,
    BikeStatus? status,
    String? currentLocation,
    double? latitude,
    double? longitude,
    String? stationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BikeModel(
      id: id ?? this.id,
      bikeNumber: bikeNumber ?? this.bikeNumber,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      stationId: stationId ?? this.stationId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum BikeStatus {
  available,
  inUse,
  maintenance,
  unavailable;

  String get value {
    switch (this) {
      case BikeStatus.available:
        return 'available';
      case BikeStatus.inUse:
        return 'in_use';
      case BikeStatus.maintenance:
        return 'maintenance';
      case BikeStatus.unavailable:
        return 'unavailable';
    }
  }

  static BikeStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return BikeStatus.available;
      case 'in_use':
        return BikeStatus.inUse;
      case 'maintenance':
        return BikeStatus.maintenance;
      case 'unavailable':
        return BikeStatus.unavailable;
      default:
        return BikeStatus.unavailable;
    }
  }
}
