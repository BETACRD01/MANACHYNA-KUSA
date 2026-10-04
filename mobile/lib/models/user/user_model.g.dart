// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  profileId: json['profileId'] as String,
  providerProfileId: json['providerProfileId'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
  hasProviderAccess: json['hasProviderAccess'] as bool? ?? false,
  hasAdminAccess: json['hasAdminAccess'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
  profileImageUrl: json['profileImageUrl'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  description: json['description'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'providerProfileId': instance.providerProfileId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'hasProviderAccess': instance.hasProviderAccess,
      'hasAdminAccess': instance.hasAdminAccess,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isActive': instance.isActive,
      'profileImageUrl': instance.profileImageUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'services': instance.services,
      'description': instance.description,
    };

const _$UserTypeEnumMap = {
  UserType.client: 'client',
  UserType.provider: 'provider',
  UserType.admin: 'admin',
};
