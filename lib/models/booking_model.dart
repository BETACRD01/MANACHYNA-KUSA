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
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
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
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
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
      createdAt: DateTime.tryParse((row['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((row['updated_at'] ?? '').toString()),
      completedAt: DateTime.tryParse((row['completed_at'] ?? '').toString()),
      cancellationReason: row['cancellation_reason']?.toString(),
      rating: row['review_rating'] != null
          ? _toDouble(row['review_rating'])
          : _toDouble((row['reviews'] as Map<String, dynamic>?)?['rating']),
      review: row['review_comment']?.toString() ??
          (row['reviews'] as Map<String, dynamic>?)?['comment']?.toString(),
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
      'duration_quantity': 1,
      'duration_type': 'hours',
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
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      rating: rating ?? this.rating,
      review: review ?? this.review,
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
