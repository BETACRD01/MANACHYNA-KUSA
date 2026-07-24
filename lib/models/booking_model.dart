class BookingModel {
  final String id;
  final String clientId;
  final String clientProfileId;
  final String clientName;
  final String providerId;
  final String? providerProfileId;
  final String providerName;
  final String serviceId;
  final String serviceName;
  final DateTime scheduledDate;
  final String scheduledTime;
  final BookingStatus status;
  final double totalPrice;
  final String? notes;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int durationQuantity;
  final String durationType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final double? rating;
  final String? review;

  BookingModel({
    required this.id,
    required this.clientId,
    required this.clientProfileId,
    required this.clientName,
    required this.providerId,
    this.providerProfileId,
    required this.providerName,
    required this.serviceId,
    required this.serviceName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.totalPrice,
    this.notes,
    this.address,
    this.latitude,
    this.longitude,
    this.durationQuantity = 1,
    this.durationType = 'hours',
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.rating,
    this.review,
  });

  factory BookingModel.fromSupabase(Map<String, dynamic> row) {
    final scheduledDate = row['scheduled_date']?.toString();

    return BookingModel(
      id: (row['id'] ?? '').toString(),
      clientId: (row['client_uid'] ?? '').toString(),
      clientProfileId: (row['client_id'] ?? '').toString(),
      clientName: (row['client_name'] ?? '').toString(),
      providerId: (row['provider_uid'] ?? '').toString(),
      providerProfileId: row['provider_id']?.toString(),
      providerName: (row['provider_name'] ?? '').toString(),
      serviceId: (row['service_id'] ?? '').toString(),
      serviceName: (row['service_name'] ?? '').toString(),
      scheduledDate:
          DateTime.tryParse(scheduledDate ?? '') ?? DateTime.now(),
      scheduledTime: (row['scheduled_time'] ?? '').toString(),
      status: bookingStatusFromSupabase((row['status'] ?? 'pending').toString()),
      totalPrice: _toDouble(row['total_amount']) ?? 0.0,
      notes: row['notes']?.toString(),
      address: row['address']?.toString(),
      latitude: _toDouble(row['latitude']),
      longitude: _toDouble(row['longitude']),
      durationQuantity: (row['duration_quantity'] as num?)?.toInt() ?? 1,
      durationType: (row['duration_type']?.toString()) ?? 'hours',
      createdAt: DateTime.tryParse((row['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((row['updated_at'] ?? '').toString()),
      completedAt: DateTime.tryParse((row['completed_at'] ?? '').toString()),
      cancelledAt: DateTime.tryParse((row['cancelled_at'] ?? '').toString()),
      cancellationReason: row['cancellation_reason']?.toString(),
      rating: _parseReviewRating(row['reviews']),
      review: _parseReviewComment(row['reviews']),
    );
  }

  Map<String, dynamic> toInsertRow() {
    return {
      'client_uid': clientId,
      'client_id': clientProfileId,
      'client_name': clientName,
      'provider_uid': providerId,
      'provider_id': providerProfileId,
      'provider_name': providerName,
      'service_id': serviceId,
      'service_name': serviceName,
      'status': bookingStatusToSupabase(status),
      'scheduled_date': _dateOnly(scheduledDate),
      'scheduled_time': scheduledTime,
      'duration_quantity': durationQuantity,
      'duration_type': durationType,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'subtotal': totalPrice,
      'total_amount': totalPrice,
    };
  }

  BookingModel copyWith({
    String? id,
    String? clientId,
    String? clientProfileId,
    String? clientName,
    String? providerId,
    String? providerProfileId,
    String? providerName,
    String? serviceId,
    String? serviceName,
    DateTime? scheduledDate,
    String? scheduledTime,
    BookingStatus? status,
    double? totalPrice,
    String? notes,
    String? address,
    double? latitude,
    double? longitude,
    int? durationQuantity,
    String? durationType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    double? rating,
    String? review,
  }) {
    return BookingModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientProfileId: clientProfileId ?? this.clientProfileId,
      clientName: clientName ?? this.clientName,
      providerId: providerId ?? this.providerId,
      providerProfileId: providerProfileId ?? this.providerProfileId,
      providerName: providerName ?? this.providerName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      durationQuantity: durationQuantity ?? this.durationQuantity,
      durationType: durationType ?? this.durationType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  static double? _parseReviewRating(dynamic reviews) {
    if (reviews is Map) {
      final rating = reviews['rating'];
      if (rating is num) return rating.toDouble();
      if (rating is String) return double.tryParse(rating);
    }
    if (reviews is List && reviews.isNotEmpty) {
      final review = reviews.first as Map;
      final rating = review['rating'];
      if (rating is num) return rating.toDouble();
    }
    return null;
  }

  static String? _parseReviewComment(dynamic reviews) {
    if (reviews is Map) {
      return reviews['comment']?.toString();
    }
    if (reviews is List && reviews.isNotEmpty) {
      final review = reviews.first as Map;
      return review['comment']?.toString();
    }
    return null;
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

  static String _dateOnly(DateTime date) {
    return date.toIso8601String().split('T').first;
  }
}

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

BookingStatus bookingStatusFromSupabase(String status) {
  switch (status) {
    case 'confirmed':
      return BookingStatus.confirmed;
    case 'in_progress':
      return BookingStatus.inProgress;
    case 'completed':
      return BookingStatus.completed;
    case 'cancelled':
    case 'rejected':
      return BookingStatus.cancelled;
    default:
      return BookingStatus.pending;
  }
}

String bookingStatusToSupabase(BookingStatus status) {
  switch (status) {
    case BookingStatus.confirmed:
      return 'confirmed';
    case BookingStatus.inProgress:
      return 'in_progress';
    case BookingStatus.completed:
      return 'completed';
    case BookingStatus.cancelled:
      return 'cancelled';
    case BookingStatus.pending:
      return 'pending';
  }
}
