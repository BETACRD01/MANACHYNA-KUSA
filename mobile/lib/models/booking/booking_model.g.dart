// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingModel _$BookingModelFromJson(Map<String, dynamic> json) =>
    _BookingModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      clientProfileId: json['clientProfileId'] as String,
      clientName: json['clientName'] as String,
      providerId: json['providerId'] as String,
      providerProfileId: json['providerProfileId'] as String?,
      providerName: json['providerName'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      scheduledTime: json['scheduledTime'] as String,
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      notes: json['notes'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      durationQuantity: (json['durationQuantity'] as num?)?.toInt() ?? 1,
      durationType: json['durationType'] as String? ?? 'hours',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
      cancellationReason: json['cancellationReason'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      review: json['review'] as String?,
    );

Map<String, dynamic> _$BookingModelToJson(_BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'clientProfileId': instance.clientProfileId,
      'clientName': instance.clientName,
      'providerId': instance.providerId,
      'providerProfileId': instance.providerProfileId,
      'providerName': instance.providerName,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'scheduledTime': instance.scheduledTime,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'totalPrice': instance.totalPrice,
      'notes': instance.notes,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'durationQuantity': instance.durationQuantity,
      'durationType': instance.durationType,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'cancellationReason': instance.cancellationReason,
      'rating': instance.rating,
      'review': instance.review,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.inProgress: 'inProgress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};
