// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingModel {

 String get id; String get clientId; String get clientProfileId; String get clientName; String get providerId; String? get providerProfileId; String get providerName; String get serviceId; String get serviceName; DateTime get scheduledDate; String get scheduledTime; BookingStatus get status; double get totalPrice; String? get notes; String? get address; double? get latitude; double? get longitude; int get durationQuantity; String get durationType; DateTime get createdAt; DateTime? get updatedAt; DateTime? get completedAt; DateTime? get cancelledAt; String? get cancellationReason; double? get rating; String? get review;
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingModelCopyWith<BookingModel> get copyWith => _$BookingModelCopyWithImpl<BookingModel>(this as BookingModel, _$identity);

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientProfileId, clientProfileId) || other.clientProfileId == clientProfileId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerProfileId, providerProfileId) || other.providerProfileId == providerProfileId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.durationQuantity, durationQuantity) || other.durationQuantity == durationQuantity)&&(identical(other.durationType, durationType) || other.durationType == durationType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,clientId,clientProfileId,clientName,providerId,providerProfileId,providerName,serviceId,serviceName,scheduledDate,scheduledTime,status,totalPrice,notes,address,latitude,longitude,durationQuantity,durationType,createdAt,updatedAt,completedAt,cancelledAt,cancellationReason,rating,review]);

@override
String toString() {
  return 'BookingModel(id: $id, clientId: $clientId, clientProfileId: $clientProfileId, clientName: $clientName, providerId: $providerId, providerProfileId: $providerProfileId, providerName: $providerName, serviceId: $serviceId, serviceName: $serviceName, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, status: $status, totalPrice: $totalPrice, notes: $notes, address: $address, latitude: $latitude, longitude: $longitude, durationQuantity: $durationQuantity, durationType: $durationType, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, rating: $rating, review: $review)';
}


}

/// @nodoc
abstract mixin class $BookingModelCopyWith<$Res>  {
  factory $BookingModelCopyWith(BookingModel value, $Res Function(BookingModel) _then) = _$BookingModelCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String clientProfileId, String clientName, String providerId, String? providerProfileId, String providerName, String serviceId, String serviceName, DateTime scheduledDate, String scheduledTime, BookingStatus status, double totalPrice, String? notes, String? address, double? latitude, double? longitude, int durationQuantity, String durationType, DateTime createdAt, DateTime? updatedAt, DateTime? completedAt, DateTime? cancelledAt, String? cancellationReason, double? rating, String? review
});




}
/// @nodoc
class _$BookingModelCopyWithImpl<$Res>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._self, this._then);

  final BookingModel _self;
  final $Res Function(BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? clientProfileId = null,Object? clientName = null,Object? providerId = null,Object? providerProfileId = freezed,Object? providerName = null,Object? serviceId = null,Object? serviceName = null,Object? scheduledDate = null,Object? scheduledTime = null,Object? status = null,Object? totalPrice = null,Object? notes = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? durationQuantity = null,Object? durationType = null,Object? createdAt = null,Object? updatedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? rating = freezed,Object? review = freezed,}) {
  return _then(BookingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientProfileId: null == clientProfileId ? _self.clientProfileId : clientProfileId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,providerProfileId: freezed == providerProfileId ? _self.providerProfileId : providerProfileId // ignore: cast_nullable_to_non_nullable
as String?,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,durationQuantity: null == durationQuantity ? _self.durationQuantity : durationQuantity // ignore: cast_nullable_to_non_nullable
as int,durationType: null == durationType ? _self.durationType : durationType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingModel].
extension BookingModelPatterns on BookingModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientProfileId,  String clientName,  String providerId,  String? providerProfileId,  String providerName,  String serviceId,  String serviceName,  DateTime scheduledDate,  String scheduledTime,  BookingStatus status,  double totalPrice,  String? notes,  String? address,  double? latitude,  double? longitude,  int durationQuantity,  String durationType,  DateTime createdAt,  DateTime? updatedAt,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancellationReason,  double? rating,  String? review)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.clientId,_that.clientProfileId,_that.clientName,_that.providerId,_that.providerProfileId,_that.providerName,_that.serviceId,_that.serviceName,_that.scheduledDate,_that.scheduledTime,_that.status,_that.totalPrice,_that.notes,_that.address,_that.latitude,_that.longitude,_that.durationQuantity,_that.durationType,_that.createdAt,_that.updatedAt,_that.completedAt,_that.cancelledAt,_that.cancellationReason,_that.rating,_that.review);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientProfileId,  String clientName,  String providerId,  String? providerProfileId,  String providerName,  String serviceId,  String serviceName,  DateTime scheduledDate,  String scheduledTime,  BookingStatus status,  double totalPrice,  String? notes,  String? address,  double? latitude,  double? longitude,  int durationQuantity,  String durationType,  DateTime createdAt,  DateTime? updatedAt,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancellationReason,  double? rating,  String? review)  $default,) {final _that = this;
switch (_that) {
case _BookingModel():
return $default(_that.id,_that.clientId,_that.clientProfileId,_that.clientName,_that.providerId,_that.providerProfileId,_that.providerName,_that.serviceId,_that.serviceName,_that.scheduledDate,_that.scheduledTime,_that.status,_that.totalPrice,_that.notes,_that.address,_that.latitude,_that.longitude,_that.durationQuantity,_that.durationType,_that.createdAt,_that.updatedAt,_that.completedAt,_that.cancelledAt,_that.cancellationReason,_that.rating,_that.review);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String clientProfileId,  String clientName,  String providerId,  String? providerProfileId,  String providerName,  String serviceId,  String serviceName,  DateTime scheduledDate,  String scheduledTime,  BookingStatus status,  double totalPrice,  String? notes,  String? address,  double? latitude,  double? longitude,  int durationQuantity,  String durationType,  DateTime createdAt,  DateTime? updatedAt,  DateTime? completedAt,  DateTime? cancelledAt,  String? cancellationReason,  double? rating,  String? review)?  $default,) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.clientId,_that.clientProfileId,_that.clientName,_that.providerId,_that.providerProfileId,_that.providerName,_that.serviceId,_that.serviceName,_that.scheduledDate,_that.scheduledTime,_that.status,_that.totalPrice,_that.notes,_that.address,_that.latitude,_that.longitude,_that.durationQuantity,_that.durationType,_that.createdAt,_that.updatedAt,_that.completedAt,_that.cancelledAt,_that.cancellationReason,_that.rating,_that.review);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingModel extends BookingModel {
  const _BookingModel({required this.id, required this.clientId, required this.clientProfileId, required this.clientName, required this.providerId, this.providerProfileId, required this.providerName, required this.serviceId, required this.serviceName, required this.scheduledDate, required this.scheduledTime, required this.status, required this.totalPrice, this.notes, this.address, this.latitude, this.longitude, this.durationQuantity = 1, this.durationType = 'hours', required this.createdAt, this.updatedAt, this.completedAt, this.cancelledAt, this.cancellationReason, this.rating, this.review}): super._();
  factory _BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String clientProfileId;
@override final  String clientName;
@override final  String providerId;
@override final  String? providerProfileId;
@override final  String providerName;
@override final  String serviceId;
@override final  String serviceName;
@override final  DateTime scheduledDate;
@override final  String scheduledTime;
@override final  BookingStatus status;
@override final  double totalPrice;
@override final  String? notes;
@override final  String? address;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey() final  int durationQuantity;
@override@JsonKey() final  String durationType;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override final  DateTime? completedAt;
@override final  DateTime? cancelledAt;
@override final  String? cancellationReason;
@override final  double? rating;
@override final  String? review;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingModelCopyWith<_BookingModel> get copyWith => __$BookingModelCopyWithImpl<_BookingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientProfileId, clientProfileId) || other.clientProfileId == clientProfileId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerProfileId, providerProfileId) || other.providerProfileId == providerProfileId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.durationQuantity, durationQuantity) || other.durationQuantity == durationQuantity)&&(identical(other.durationType, durationType) || other.durationType == durationType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,clientId,clientProfileId,clientName,providerId,providerProfileId,providerName,serviceId,serviceName,scheduledDate,scheduledTime,status,totalPrice,notes,address,latitude,longitude,durationQuantity,durationType,createdAt,updatedAt,completedAt,cancelledAt,cancellationReason,rating,review]);

@override
String toString() {
  return 'BookingModel(id: $id, clientId: $clientId, clientProfileId: $clientProfileId, clientName: $clientName, providerId: $providerId, providerProfileId: $providerProfileId, providerName: $providerName, serviceId: $serviceId, serviceName: $serviceName, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, status: $status, totalPrice: $totalPrice, notes: $notes, address: $address, latitude: $latitude, longitude: $longitude, durationQuantity: $durationQuantity, durationType: $durationType, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, rating: $rating, review: $review)';
}


}

/// @nodoc
abstract mixin class _$BookingModelCopyWith<$Res> implements $BookingModelCopyWith<$Res> {
  factory _$BookingModelCopyWith(_BookingModel value, $Res Function(_BookingModel) _then) = __$BookingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String clientProfileId, String clientName, String providerId, String? providerProfileId, String providerName, String serviceId, String serviceName, DateTime scheduledDate, String scheduledTime, BookingStatus status, double totalPrice, String? notes, String? address, double? latitude, double? longitude, int durationQuantity, String durationType, DateTime createdAt, DateTime? updatedAt, DateTime? completedAt, DateTime? cancelledAt, String? cancellationReason, double? rating, String? review
});




}
/// @nodoc
class __$BookingModelCopyWithImpl<$Res>
    implements _$BookingModelCopyWith<$Res> {
  __$BookingModelCopyWithImpl(this._self, this._then);

  final _BookingModel _self;
  final $Res Function(_BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? clientProfileId = null,Object? clientName = null,Object? providerId = null,Object? providerProfileId = freezed,Object? providerName = null,Object? serviceId = null,Object? serviceName = null,Object? scheduledDate = null,Object? scheduledTime = null,Object? status = null,Object? totalPrice = null,Object? notes = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? durationQuantity = null,Object? durationType = null,Object? createdAt = null,Object? updatedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? cancellationReason = freezed,Object? rating = freezed,Object? review = freezed,}) {
  return _then(_BookingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientProfileId: null == clientProfileId ? _self.clientProfileId : clientProfileId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,providerProfileId: freezed == providerProfileId ? _self.providerProfileId : providerProfileId // ignore: cast_nullable_to_non_nullable
as String?,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,durationQuantity: null == durationQuantity ? _self.durationQuantity : durationQuantity // ignore: cast_nullable_to_non_nullable
as int,durationType: null == durationType ? _self.durationType : durationType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
