// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) =>
    _ServiceModel(
      id: json['id'] as String,
      catalogServiceId: json['catalogServiceId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$ServiceCategoryEnumMap, json['category']),
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      providerId: json['providerId'] as String,
      providerProfileId: json['providerProfileId'] as String,
      providerName: json['providerName'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$ServiceModelToJson(_ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'catalogServiceId': instance.catalogServiceId,
      'name': instance.name,
      'description': instance.description,
      'category': _$ServiceCategoryEnumMap[instance.category]!,
      'pricePerHour': instance.pricePerHour,
      'providerId': instance.providerId,
      'providerProfileId': instance.providerProfileId,
      'providerName': instance.providerName,
      'imageUrls': instance.imageUrls,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'tags': instance.tags,
      'estimatedDuration': instance.estimatedDuration,
    };

const _$ServiceCategoryEnumMap = {
  ServiceCategory.cleaning: 'cleaning',
  ServiceCategory.plumbing: 'plumbing',
  ServiceCategory.carpentry: 'carpentry',
  ServiceCategory.electricity: 'electricity',
  ServiceCategory.gardening: 'gardening',
  ServiceCategory.housework: 'housework',
  ServiceCategory.wasteDisposal: 'wasteDisposal',
  ServiceCategory.other: 'other',
};
