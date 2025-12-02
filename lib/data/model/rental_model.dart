import 'bike_model.dart';

class RentalModel {
  final String id;
  final String userId;
  final String bikeId;
  final BikeModel? bike;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration; // in minutes
  final double? totalCost;
  final RentalStatus status;
  final String? startLocation;
  final String? endLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  RentalModel({
    required this.id,
    required this.userId,
    required this.bikeId,
    this.bike,
    required this.startTime,
    this.endTime,
    this.duration,
    this.totalCost,
    required this.status,
    this.startLocation,
    this.endLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bikeId: json['bike_id'] as String,
      bike: json['bike'] != null ? BikeModel.fromJson(json['bike'] as Map<String, dynamic>) : null,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time'] as String) : null,
      duration: json['duration'] as int?,
      totalCost: json['total_cost'] != null ? (json['total_cost'] as num).toDouble() : null,
      status: RentalStatus.fromString(json['status'] as String),
      startLocation: json['start_location'] as String?,
      endLocation: json['end_location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bike_id': bikeId,
      'bike': bike?.toJson(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration': duration,
      'total_cost': totalCost,
      'status': status.value,
      'start_location': startLocation,
      'end_location': endLocation,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  RentalModel copyWith({
    String? id,
    String? userId,
    String? bikeId,
    BikeModel? bike,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    double? totalCost,
    RentalStatus? status,
    String? startLocation,
    String? endLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RentalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bikeId: bikeId ?? this.bikeId,
      bike: bike ?? this.bike,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      totalCost: totalCost ?? this.totalCost,
      status: status ?? this.status,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == RentalStatus.active;

  String get durationFormatted {
    if (duration == null) return '0 min';
    
    final hours = duration! ~/ 60;
    final minutes = duration! % 60;
    
    if (hours > 0) {
      return '$hours hr $minutes min';
    }
    return '$minutes min';
  }

  double calculateCurrentCost(double pricePerHour) {
    if (endTime != null && totalCost != null) {
      return totalCost!;
    }
    
    final currentDuration = DateTime.now().difference(startTime).inMinutes;
    return (currentDuration / 60) * pricePerHour;
  }
}

enum RentalStatus {
  active,
  completed,
  cancelled;

  String get value {
    switch (this) {
      case RentalStatus.active:
        return 'active';
      case RentalStatus.completed:
        return 'completed';
      case RentalStatus.cancelled:
        return 'cancelled';
    }
  }

  static RentalStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return RentalStatus.active;
      case 'completed':
        return RentalStatus.completed;
      case 'cancelled':
        return RentalStatus.cancelled;
      default:
        return RentalStatus.completed;
    }
  }
}
