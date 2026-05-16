class ServiceModel {
  final String id;
  final String catalogServiceId;
  final String name;
  final String description;
  final ServiceCategory category;
  final double pricePerHour;
  final String providerId;
  final String providerProfileId;
  final String providerName;
  final List<String> imageUrls;
  final double rating;
  final int totalRatings;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? latitude;
  final double? longitude;
  final String? address;
  final List<String> tags;
  final int estimatedDuration;

  ServiceModel({
    required this.id,
    required this.catalogServiceId,
    required this.name,
    required this.description,
    required this.category,
    required this.pricePerHour,
    required this.providerId,
    required this.providerProfileId,
    required this.providerName,
    this.imageUrls = const [],
    this.rating = 0.0,
    this.totalRatings = 0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    this.address,
    this.tags = const [],
    this.estimatedDuration = 60,
  });

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
      description: (row['description'] ??
              service['short_description'] ??
              service['description'] ??
              '')
          .toString(),
      category: serviceCategoryFromSlug(
        (category?['slug'] ?? service['slug'] ?? '').toString(),
      ),
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
      createdAt: DateTime.tryParse((row['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((row['updated_at'] ?? '').toString()),
      latitude: _toDouble(provider['latitude']),
      longitude: _toDouble(provider['longitude']),
      address: (provider['address'] ?? '').toString().isEmpty
          ? null
          : provider['address'].toString(),
      tags: rawTags is List
          ? rawTags.map((tag) => tag.toString()).toList()
          : [],
      estimatedDuration:
          _toInt(service['estimated_duration_minutes']) ?? 60,
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

  ServiceModel copyWith({
    String? id,
    String? catalogServiceId,
    String? name,
    String? description,
    ServiceCategory? category,
    double? pricePerHour,
    String? providerId,
    String? providerProfileId,
    String? providerName,
    List<String>? imageUrls,
    double? rating,
    int? totalRatings,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
    String? address,
    List<String>? tags,
    int? estimatedDuration,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      catalogServiceId: catalogServiceId ?? this.catalogServiceId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      providerId: providerId ?? this.providerId,
      providerProfileId: providerProfileId ?? this.providerProfileId,
      providerName: providerName ?? this.providerName,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      tags: tags ?? this.tags,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
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
