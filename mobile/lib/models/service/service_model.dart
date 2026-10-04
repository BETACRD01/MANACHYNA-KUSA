import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

enum ServiceCategory {
  cleaning,
  plumbing,
  carpentry,
  electricity,
  gardening,
  housework,
  wasteDisposal,
  other
}

@freezed
abstract class ServiceModel with _$ServiceModel {
  const ServiceModel._();

  const factory ServiceModel({
    required String id,
    required String catalogServiceId,
    required String name,
    required String description,
    required ServiceCategory category,
    required double pricePerHour,
    required String providerId,
    required String providerProfileId,
    required String providerName,
    @Default([]) List<String> imageUrls,
    @Default(0.0) double rating,
    @Default(0) int totalRatings,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
    String? address,
    @Default([]) List<String> tags,
    @Default(60) int estimatedDuration,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);

  factory ServiceModel.fromSupabase(Map<String, dynamic> row) {
    final service = (row['services'] as Map<String, dynamic>? ?? {});
    final provider = (row['providers'] as Map<String, dynamic>? ?? {});
    final category = (service['service_categories'] as Map<String, dynamic>?);
    final metadata = (service['metadata'] as Map<String, dynamic>? ?? {});
    final rawTags = metadata['tags'];

    return ServiceModel(
      id: (row['id'] ?? '').toString(),
      catalogServiceId: (service['id'] ?? '').toString(),
      name: (service['name'] ?? '').toString(),
      description: (row['description'] ?? service['short_description'] ?? service['description'] ?? '').toString(),
      category: serviceCategoryFromSlug((category?['slug'] ?? service['slug'] ?? '').toString()),
      pricePerHour: _toDouble(row['price'] ?? service['base_price']) ?? 0.0,
      providerId: (provider['uid'] ?? '').toString(),
      providerProfileId: (provider['id'] ?? '').toString(),
      providerName: (provider['full_name'] ?? provider['name'] ?? '').toString(),
      imageUrls: [
        if (service['image_url'] != null && service['image_url'].toString().isNotEmpty)
          service['image_url'].toString(),
      ],
      rating: _toDouble(provider['rating']) ?? 0.0,
      totalRatings: _toInt(provider['reviews_count']) ?? 0,
      isActive: row['is_active'] == true && service['is_active'] == true,
      createdAt: DateTime.tryParse((row['created_at'] ?? '').toString()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse((row['updated_at'] ?? '').toString()),
      latitude: _toDouble(provider['latitude']),
      longitude: _toDouble(provider['longitude']),
      address: (provider['address'] ?? '').toString().isEmpty ? null : provider['address'].toString(),
      tags: rawTags is List ? rawTags.map((tag) => tag.toString()).toList() : [],
      estimatedDuration: _toInt(service['estimated_duration_minutes']) ?? 60,
    );
  }

  Map<String, dynamic> toProviderServiceRow() {
    return {
      'service_id': catalogServiceId,
      'provider_id': providerProfileId,
      'price': pricePerHour,
      'description': description,
      'is_active': isActive,
      'updated_at': DateTime.now().toIso8601String(),
    };
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

ServiceCategory serviceCategoryFromSlug(String slug) {
  switch (slug) {
    case 'cleaning':
      return ServiceCategory.cleaning;
    case 'plumbing':
      return ServiceCategory.plumbing;
    case 'carpentry':
      return ServiceCategory.carpentry;
    case 'electricity':
      return ServiceCategory.electricity;
    case 'gardening':
      return ServiceCategory.gardening;
    case 'housework':
      return ServiceCategory.housework;
    case 'waste-disposal':
      return ServiceCategory.wasteDisposal;
    default:
      return ServiceCategory.other;
  }
}
