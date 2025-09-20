import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? location;
  final String? avatarUrl;
  final int credits;
  final Map<String, dynamic>? preferences;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isVerified;
  final bool isActive;
  final String role;
  final Map<String, dynamic>? metadata;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.location,
    this.avatarUrl,
    this.credits = 0,
    this.preferences,
    required this.createdAt,
    this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
    this.role = 'user',
    this.metadata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['user_id'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      location: json['location'],
      avatarUrl: json['avatar_url'],
      credits: json['credits'] ?? 0,
      preferences: json['preferences'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      role: json['role'] ?? 'user',
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'location': location,
      'avatar_url': avatarUrl,
      'credits': credits,
      'preferences': preferences,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_verified': isVerified,
      'is_active': isActive,
      'role': role,
      'metadata': metadata,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
    String? location,
    String? avatarUrl,
    int? credits,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
    String? role,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      credits: credits ?? this.credits,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        dateOfBirth,
        gender,
        location,
        avatarUrl,
        credits,
        preferences,
        createdAt,
        updatedAt,
        isVerified,
        isActive,
        role,
        metadata,
      ];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, credits: $credits)';
  }

  // Helper getters
  String get displayName => name ?? email.split('@').first;
  
  bool get hasProfile => name != null && name!.isNotEmpty;
  
  int get age {
    if (dateOfBirth == null) return 0;
    final birthDate = DateTime.parse(dateOfBirth!);
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
  
  bool get canBookMentor => credits >= 50; // Minimum credits for mentor booking
  
  bool get canPurchase => credits > 0;
  
  Map<String, dynamic> get profileCompleteness {
    int completed = 0;
    int total = 6;
    
    if (name != null && name!.isNotEmpty) completed++;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) completed++;
    if (dateOfBirth != null && dateOfBirth!.isNotEmpty) completed++;
    if (gender != null && gender!.isNotEmpty) completed++;
    if (location != null && location!.isNotEmpty) completed++;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) completed++;
    
    return {
      'completed': completed,
      'total': total,
      'percentage': (completed / total * 100).round(),
    };
  }
}