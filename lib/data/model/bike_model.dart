class BikeModel {
  final String id;
  final String? stationId;
  final String qrCode;
  final String model;
  final String bikeType;
  final String status;
  final int? batteryLevel;
  final DateTime? lastMaintenanceDate;
  final int totalRentals;
  final double totalDistance;
  final String? color;
  final String? frameNumber;
  final DateTime? purchaseDate;
  final int? conditionScore;
  final String? notes;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  BikeModel({
    required this.id,
    this.stationId,
    required this.qrCode,
    required this.model,
    this.bikeType = 'standard',
    this.status = 'available',
    this.batteryLevel,
    this.lastMaintenanceDate,
    this.totalRentals = 0,
    this.totalDistance = 0.0,
    this.color,
    this.frameNumber,
    this.purchaseDate,
    this.conditionScore,
    this.notes,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BikeModel.fromJson(Map<String, dynamic> json) {
    return BikeModel(
      id: json['id'] as String,
      stationId: json['station_id'] as String?,
      qrCode: json['qr_code'] as String,
      model: json['model'] as String,
      bikeType: json['bike_type'] as String? ?? 'standard',
      status: json['status'] as String? ?? 'available',
      batteryLevel: json['battery_level'] as int?,
      lastMaintenanceDate: json['last_maintenance_date'] != null
          ? DateTime.parse(json['last_maintenance_date'] as String)
          : null,
      totalRentals: json['total_rentals'] as int? ?? 0,
      totalDistance: json['total_distance'] != null
          ? (json['total_distance'] as num).toDouble()
          : 0.0,
      color: json['color'] as String?,
      frameNumber: json['frame_number'] as String?,
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : null,
      conditionScore: json['condition_score'] as int?,
      notes: json['notes'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'qr_code': qrCode,
      'model': model,
      'bike_type': bikeType,
      'status': status,
      'battery_level': batteryLevel,
      'last_maintenance_date': lastMaintenanceDate?.toIso8601String(),
      'total_rentals': totalRentals,
      'total_distance': totalDistance,
      'color': color,
      'frame_number': frameNumber,
      'purchase_date': purchaseDate?.toIso8601String(),
      'condition_score': conditionScore,
      'notes': notes,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  BikeModel copyWith({
    String? id,
    String? stationId,
    String? qrCode,
    String? model,
    String? bikeType,
    String? status,
    int? batteryLevel,
    DateTime? lastMaintenanceDate,
    int? totalRentals,
    double? totalDistance,
    String? color,
    String? frameNumber,
    DateTime? purchaseDate,
    int? conditionScore,
    String? notes,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BikeModel(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      qrCode: qrCode ?? this.qrCode,
      model: model ?? this.model,
      bikeType: bikeType ?? this.bikeType,
      status: status ?? this.status,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      totalRentals: totalRentals ?? this.totalRentals,
      totalDistance: totalDistance ?? this.totalDistance,
      color: color ?? this.color,
      frameNumber: frameNumber ?? this.frameNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      conditionScore: conditionScore ?? this.conditionScore,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isAvailable => status == 'available';
  bool get isRented => status == 'rented';
  bool get needsMaintenance => status == 'maintenance' || status == 'damaged';
  bool get isElectric => bikeType == 'electric';
  bool get hasLowBattery => batteryLevel != null && batteryLevel! < 20;
}

enum BikeStatus {
  available,
  rented,
  maintenance,
  damaged,
  retired;

  String get value {
    switch (this) {
      case BikeStatus.available:
        return 'available';
      case BikeStatus.rented:
        return 'rented';
      case BikeStatus.maintenance:
        return 'maintenance';
      case BikeStatus.damaged:
        return 'damaged';
      case BikeStatus.retired:
        return 'retired';
    }
  }

  static BikeStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return BikeStatus.available;
      case 'rented':
        return BikeStatus.rented;
      case 'maintenance':
        return BikeStatus.maintenance;
      case 'damaged':
        return BikeStatus.damaged;
      case 'retired':
        return BikeStatus.retired;
      default:
        return BikeStatus.available;
    }
  }

  static BikeType bikeTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'standard':
        return BikeType.standard;
      case 'electric':
        return BikeType.electric;
      case 'mountain':
        return BikeType.mountain;
      case 'city':
        return BikeType.city;
      default:
        return BikeType.standard;
    }
  }
}

enum BikeType {
  standard,
  electric,
  mountain,
  city;

  String get value {
    switch (this) {
      case BikeType.standard:
        return 'standard';
      case BikeType.electric:
        return 'electric';
      case BikeType.mountain:
        return 'mountain';
      case BikeType.city:
        return 'city';
    }
  }
}
