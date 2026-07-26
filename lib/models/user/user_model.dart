import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserType { client, provider, admin }

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String profileId,
    String? providerProfileId,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required UserType userType,
    @Default(false) bool hasProviderAccess,
    @Default(false) bool hasAdminAccess,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(true) bool isActive,
    String? profileImageUrl,
    double? latitude,
    double? longitude,
    @Default(0.0) double rating,
    @Default(0) int totalRatings,
    @Default([]) List<String> services,
    String? description,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

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

  // --- MÉTODOS DE COMPATIBILIDAD HACIA ATRÁS (DTO) ---
  // A medida que migremos a Clean Architecture, estos métodos se moverán a la capa de Repositorio.

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
      address: (providerRow?['address'] ?? userRow['address'] ?? '').toString(),
      city: (providerRow?['city'] ?? userRow['city'] ?? '').toString(),
      userType: _roleToUserType(role),
      hasProviderAccess: isProvider,
      hasAdminAccess: isAdmin,
      createdAt: DateTime.tryParse((userRow['created_at'] ?? '').toString()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse((userRow['updated_at'] ?? '').toString()),
      isActive: (providerRow?['is_active'] ?? userRow['is_active'] ?? true) == true,
      profileImageUrl: (providerRow?['avatar_url'] ?? userRow['avatar_url'])?.toString(),
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
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
