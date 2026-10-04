import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

@freezed
abstract class BookingModel with _$BookingModel {
  const BookingModel._();

  const factory BookingModel({
    required String id,
    required String clientId,
    required String clientProfileId,
    required String clientName,
    required String providerId,
    String? providerProfileId,
    required String providerName,
    required String serviceId,
    required String serviceName,
    required DateTime scheduledDate,
    required String scheduledTime,
    required BookingStatus status,
    required double totalPrice,
    String? notes,
    String? address,
    double? latitude,
    double? longitude,
    @Default(1) int durationQuantity,
    @Default('hours') String durationType,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    double? rating,
    String? review,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  // --- MÉTODOS DE COMPATIBILIDAD HACIA ATRÁS (DTO) ---
  
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
      scheduledDate: DateTime.tryParse(scheduledDate ?? '') ?? DateTime.now(),
      scheduledTime: (row['scheduled_time'] ?? '').toString(),
      status: bookingStatusFromSupabase((row['status'] ?? 'pending').toString()),
      totalPrice: _toDouble(row['total_amount']) ?? 0.0,
      notes: row['notes']?.toString(),
      address: row['address']?.toString(),
      latitude: _toDouble(row['latitude']),
      longitude: _toDouble(row['longitude']),
      durationQuantity: (row['duration_quantity'] as num?)?.toInt() ?? 1,
      durationType: (row['duration_type']?.toString()) ?? 'hours',
      createdAt: DateTime.tryParse((row['created_at'] ?? '').toString()) ?? DateTime.now(),
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
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String _dateOnly(DateTime date) {
    return date.toIso8601String().split('T').first;
  }
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
