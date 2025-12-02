class StationModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int totalSlots;
  final int availableSlots;
  final int availableBikes;
  final DateTime createdAt;
  final DateTime updatedAt;

  StationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.totalSlots,
    required this.availableSlots,
    required this.availableBikes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      totalSlots: json['total_slots'] as int,
      availableSlots: json['available_slots'] as int,
      availableBikes: json['available_bikes'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_slots': totalSlots,
      'available_slots': availableSlots,
      'available_bikes': availableBikes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  StationModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? totalSlots,
    int? availableSlots,
    int? availableBikes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalSlots: totalSlots ?? this.totalSlots,
      availableSlots: availableSlots ?? this.availableSlots,
      availableBikes: availableBikes ?? this.availableBikes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasAvailableBikes => availableBikes > 0;
  bool get hasAvailableSlots => availableSlots > 0;

  double get occupancyRate =>
      totalSlots > 0 ? (totalSlots - availableSlots) / totalSlots : 0.0;
}
