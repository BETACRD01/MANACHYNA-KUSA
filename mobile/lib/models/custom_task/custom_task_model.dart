import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_task_model.freezed.dart';
part 'custom_task_model.g.dart';

enum CustomTaskStatus {
  open,
  accepted,
  completed,
}

@freezed
abstract class CustomTaskOffer with _$CustomTaskOffer {
  const factory CustomTaskOffer({
    required String id,
    required String providerId,
    required String providerName,
    required double providerRating,
    required double priceOffer,
    required String message,
    required DateTime createdAt,
  }) = _CustomTaskOffer;

  factory CustomTaskOffer.fromJson(Map<String, dynamic> json) => _$CustomTaskOfferFromJson(json);
}

@freezed
abstract class CustomTaskModel with _$CustomTaskModel {
  const factory CustomTaskModel({
    required String id,
    required String clientId,
    required String clientName,
    required String title,
    required String description,
    required String category,
    required DateTime date,
    required double budget,
    required String address,
    required CustomTaskStatus status,
    String? providerId,
    String? providerName,
    required List<CustomTaskOffer> offers,
    required DateTime createdAt,
  }) = _CustomTaskModel;

  factory CustomTaskModel.fromJson(Map<String, dynamic> json) => _$CustomTaskModelFromJson(json);
}
