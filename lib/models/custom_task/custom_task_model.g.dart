// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomTaskOffer _$CustomTaskOfferFromJson(Map<String, dynamic> json) =>
    _CustomTaskOffer(
      id: json['id'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerRating: (json['providerRating'] as num).toDouble(),
      priceOffer: (json['priceOffer'] as num).toDouble(),
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CustomTaskOfferToJson(_CustomTaskOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'providerRating': instance.providerRating,
      'priceOffer': instance.priceOffer,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_CustomTaskModel _$CustomTaskModelFromJson(Map<String, dynamic> json) =>
    _CustomTaskModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      budget: (json['budget'] as num).toDouble(),
      address: json['address'] as String,
      status: $enumDecode(_$CustomTaskStatusEnumMap, json['status']),
      providerId: json['providerId'] as String?,
      providerName: json['providerName'] as String?,
      offers: (json['offers'] as List<dynamic>)
          .map((e) => CustomTaskOffer.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CustomTaskModelToJson(_CustomTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'date': instance.date.toIso8601String(),
      'budget': instance.budget,
      'address': instance.address,
      'status': _$CustomTaskStatusEnumMap[instance.status]!,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'offers': instance.offers,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$CustomTaskStatusEnumMap = {
  CustomTaskStatus.open: 'open',
  CustomTaskStatus.accepted: 'accepted',
  CustomTaskStatus.completed: 'completed',
};
