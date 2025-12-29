import 'bike_model.dart';

class RentalModel {
  final String id;
  final String userId;
  final String bikeId;
  final BikeModel? bike;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final DateTime plannedEndTime;
  final double pricePerHour;
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
    required this.durationMinutes,
    required this.plannedEndTime,
    this.pricePerHour = 5.0,
    this.totalCost,
    required this.status,
    this.startLocation,
    this.endLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    T require<T>(String key) {
      final value = json[key];
      if (value == null) {
        throw Exception(
          'RentalModel.fromJson: Required key "$key" is missing or null. Data: '
          '${json.toString()}',
        );
      }
      return value as T;
    }

    return RentalModel(
      id: require<String>('id'),
      userId: require<String>('user_id'),
      bikeId: require<String>('bike_id'),
      bike: json['bike'] != null
          ? BikeModel.fromJson(json['bike'] as Map<String, dynamic>)
          : null,
      startTime: DateTime.parse(require<String>('start_time')),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      durationMinutes: require<int>('duration_minutes'),
      plannedEndTime: DateTime.parse(require<String>('planned_end_time')),
      pricePerHour: json['price_per_hour'] != null
          ? (json['price_per_hour'] as num).toDouble()
          : 5.0,
      totalCost: json['total_cost'] != null
          ? (json['total_cost'] as num).toDouble()
          : null,
      status: RentalStatus.fromString(require<String>('status')),
      startLocation: json['start_location'] ?? "",
      endLocation: json['end_location'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.parse(require<String>('start_time')),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.parse(require<String>('start_time'))),
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
      'duration_minutes': durationMinutes,
      'planned_end_time': plannedEndTime.toIso8601String(),
      'price_per_hour': pricePerHour,
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
    int? durationMinutes,
    DateTime? plannedEndTime,
    double? pricePerHour,
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
      durationMinutes: durationMinutes ?? this.durationMinutes,
      plannedEndTime: plannedEndTime ?? this.plannedEndTime,
      pricePerHour: pricePerHour ?? this.pricePerHour,
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
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (hours > 0) {
      return '$hours hr $minutes min';
    }
    return '$minutes min';
  }

  Duration get remainingTime {
    if (endTime != null) return Duration.zero;
    final remaining = plannedEndTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  double get estimatedCost {
    return (durationMinutes / 60) * pricePerHour;
  }

  double calculateCurrentCost() {
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
