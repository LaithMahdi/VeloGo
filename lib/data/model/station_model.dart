class StationModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final int totalCapacity;
  final int availableBikes;
  final String status;
  final String? description;
  final String? imageUrl;
  final String operatingHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  StationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.totalCapacity,
    required this.availableBikes,
    this.status = 'active',
    this.description,
    this.imageUrl,
    this.operatingHours = '24/7',
    required this.createdAt,
    required this.updatedAt,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      totalCapacity: json['total_capacity'] as int,
      availableBikes: json['available_bikes'] as int,
      status: json['status'] as String? ?? 'active',
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      operatingHours: json['operating_hours'] as String? ?? '24/7',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'total_capacity': totalCapacity,
      'available_bikes': availableBikes,
      'status': status,
      'description': description,
      'image_url': imageUrl,
      'operating_hours': operatingHours,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  StationModel copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    int? totalCapacity,
    int? availableBikes,
    String? status,
    String? description,
    String? imageUrl,
    String? operatingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      availableBikes: availableBikes ?? this.availableBikes,
      status: status ?? this.status,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      operatingHours: operatingHours ?? this.operatingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasAvailableBikes => availableBikes > 0;
  bool get isActive => status == 'active';
  bool get isOperating => status == 'active' || status == 'maintenance';

  int get availableSlots => totalCapacity - availableBikes;
  double get occupancyRate =>
      totalCapacity > 0 ? availableBikes / totalCapacity : 0.0;
}
