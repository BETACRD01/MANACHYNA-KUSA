class ReviewModel {
  final String id;
  final String bookingId;
  final String clientUid;
  final String providerUid;
  final int rating;
  final String? comment;
  final String? providerReply;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.clientUid,
    required this.providerUid,
    required this.rating,
    this.comment,
    this.providerReply,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromSupabase(Map<String, dynamic> map) {
    return ReviewModel(
      id: (map['id'] ?? '').toString(),
      bookingId: (map['booking_id'] ?? '').toString(),
      clientUid: (map['client_uid'] ?? '').toString(),
      providerUid: (map['provider_uid'] ?? '').toString(),
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment']?.toString(),
      providerReply: map['provider_reply']?.toString(),
      createdAt: DateTime.tryParse((map['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((map['updated_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
