// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => _ReviewModel(
  id: json['id'] as String,
  bookingId: json['bookingId'] as String,
  clientUid: json['clientUid'] as String,
  providerUid: json['providerUid'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  providerReply: json['providerReply'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ReviewModelToJson(_ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'clientUid': instance.clientUid,
      'providerUid': instance.providerUid,
      'rating': instance.rating,
      'comment': instance.comment,
      'providerReply': instance.providerReply,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
