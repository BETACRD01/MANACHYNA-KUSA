class ReviewModel {
  final String id;
  final String bookingId;
  final String clientId;
  final String clientName;
  final String providerId;
  final String providerName;
  final String serviceId;
  final String serviceName;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final List<String> imageUrls;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.clientId,
    required this.clientName,
    required this.providerId,
    required this.providerName,
    required this.serviceId,
    required this.serviceName,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.imageUrls = const [],
  });

  factory ReviewModel.fromSupabase(Map<String, dynamic> map) {
    return ReviewModel(
      id: (map['id'] ?? '').toString(),
      bookingId: (map['booking_id'] ?? '').toString(),
      clientId: (map['client_uid'] ?? '').toString(),
      clientName: (map['client_name'] ?? '').toString(),
      providerId: (map['provider_uid'] ?? '').toString(),
      providerName: (map['provider_name'] ?? '').toString(),
      serviceId: (map['service_id'] ?? '').toString(),
      serviceName: (map['service_name'] ?? '').toString(),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment']?.toString(),
      createdAt: DateTime.tryParse((map['created_at'] ?? '').toString()) ??
          DateTime.now(),
      imageUrls: const [],
    );
  }
}
