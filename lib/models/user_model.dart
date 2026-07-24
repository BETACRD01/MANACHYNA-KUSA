class UserModel {
  final String id;
  final String profileId;
  final String? providerProfileId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final UserType userType;
  final bool hasProviderAccess;
  final bool hasAdminAccess;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? profileImageUrl;
  final double? latitude;
  final double? longitude;
  final double rating;
  final int totalRatings;
  final List<String> services;
  final String? description;

  UserModel({
    required this.id,
    required this.profileId,
    this.providerProfileId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.userType,
    this.hasProviderAccess = false,
    this.hasAdminAccess = false,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.profileImageUrl,
    this.latitude,
    this.longitude,
    this.rating = 0.0,
    this.totalRatings = 0,
    this.services = const [],
    this.description,
  });

  String get displayEmail {
    const fallbackDomain = '@manachyna.invalid';
    if (email.endsWith(fallbackDomain) && email.startsWith('facebook_')) {
      final facebookId = email.substring(
        'facebook_'.length,
        email.length - fallbackDomain.length,
      );
      return 'ID de Facebook: $facebookId';
    }
    if (email.endsWith(fallbackDomain) && email.startsWith('microsoft_')) {
      final microsoftId = email.substring(
        'microsoft_'.length,
        email.length - fallbackDomain.length,
      );
      return 'ID de Microsoft: $microsoftId';
    }
    return email;
  }

  factory UserModel.fromSupabase(
    Map<String, dynamic> userRow, {
    Map<String, dynamic>? providerRow,
    List<String> services = const [],
  }) {
    final role = (userRow['role'] ?? 'client').toString();
    final isProvider = providerRow != null || userRow['is_provider'] == true;
    final isAdmin = role == 'admin';

    return UserModel(
      id: (userRow['uid'] ?? '').toString(),
      profileId: (userRow['id'] ?? '').toString(),
      providerProfileId: providerRow?['id']?.toString(),
      name: (providerRow?['name'] ?? userRow['name'] ?? '').toString(),
      email: (userRow['email'] ?? providerRow?['email'] ?? '').toString(),
      phone: (providerRow?['phone'] ?? userRow['phone'] ?? '').toString(),
      address:
          (providerRow?['address'] ?? userRow['address'] ?? '').toString(),
      city: (providerRow?['city'] ?? userRow['city'] ?? '').toString(),
      userType: _roleToUserType(role),
      hasProviderAccess: isProvider,
      hasAdminAccess: isAdmin,
      createdAt: DateTime.tryParse((userRow['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((userRow['updated_at'] ?? '').toString()),
      isActive: (providerRow?['is_active'] ?? userRow['is_active'] ?? true) ==
          true,
      profileImageUrl:
          (providerRow?['avatar_url'] ?? userRow['avatar_url'])?.toString(),
      latitude: _toDouble(providerRow?['latitude'] ?? userRow['latitude']),
      longitude: _toDouble(providerRow?['longitude'] ?? userRow['longitude']),
      rating: _toDouble(providerRow?['rating']) ?? 0.0,
      totalRatings: _toInt(providerRow?['reviews_count']) ?? 0,
      services: services,
      description: providerRow?['bio']?.toString(),
    );
  }

  Map<String, dynamic> toUserRow() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'role': _userTypeToRole(userType),
      'is_provider': hasProviderAccess,
      'is_active': isActive,
      'avatar_url': profileImageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> toProviderRow() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'bio': description,
      'avatar_url': profileImageUrl,
      'is_active': isActive,
      'latitude': latitude,
      'longitude': longitude,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? profileId,
    String? providerProfileId,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    UserType? userType,
    bool? hasProviderAccess,
    bool? hasAdminAccess,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? profileImageUrl,
    double? latitude,
    double? longitude,
    double? rating,
    int? totalRatings,
    List<String>? services,
    String? description,
  }) {
    return UserModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      providerProfileId: providerProfileId ?? this.providerProfileId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      userType: userType ?? this.userType,
      hasProviderAccess: hasProviderAccess ?? this.hasProviderAccess,
      hasAdminAccess: hasAdminAccess ?? this.hasAdminAccess,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      services: services ?? this.services,
      description: description ?? this.description,
    );
  }

  static UserType _roleToUserType(String role) {
    switch (role) {
      case 'provider':
        return UserType.provider;
      case 'admin':
        return UserType.admin;
      default:
        return UserType.client;
    }
  }

  static String _userTypeToRole(UserType userType) {
    switch (userType) {
      case UserType.provider:
        return 'provider';
      case UserType.admin:
        return 'admin';
      case UserType.client:
        return 'client';
    }
  }

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }
}

enum UserType { client, provider, admin }
