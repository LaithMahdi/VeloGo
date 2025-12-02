class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final double balance;
  final int totalRentals;
  final DateTime createdAt;
  final DateTime? lastSignInAt;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.balance = 0.0,
    this.totalRentals = 0,
    required this.createdAt,
    this.lastSignInAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['user_metadata']?['full_name'] as String?,
      phoneNumber: json['user_metadata']?['phone_number'] as String?,
      avatarUrl: json['user_metadata']?['avatar_url'] as String?,
      balance: json['user_metadata']?['balance'] != null
          ? (json['user_metadata']['balance'] as num).toDouble()
          : 0.0,
      totalRentals: json['user_metadata']?['total_rentals'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_metadata': {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'avatar_url': avatarUrl,
        'balance': balance,
        'total_rentals': totalRentals,
      },
      'created_at': createdAt.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    double? balance,
    int? totalRentals,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      balance: balance ?? this.balance,
      totalRentals: totalRentals ?? this.totalRentals,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }
}
