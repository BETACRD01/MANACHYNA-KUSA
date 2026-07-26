// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomTaskOffer {

 String get id; String get providerId; String get providerName; double get providerRating; double get priceOffer; String get message; DateTime get createdAt;
/// Create a copy of CustomTaskOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomTaskOfferCopyWith<CustomTaskOffer> get copyWith => _$CustomTaskOfferCopyWithImpl<CustomTaskOffer>(this as CustomTaskOffer, _$identity);

  /// Serializes this CustomTaskOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomTaskOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.providerRating, providerRating) || other.providerRating == providerRating)&&(identical(other.priceOffer, priceOffer) || other.priceOffer == priceOffer)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,providerId,providerName,providerRating,priceOffer,message,createdAt);

@override
String toString() {
  return 'CustomTaskOffer(id: $id, providerId: $providerId, providerName: $providerName, providerRating: $providerRating, priceOffer: $priceOffer, message: $message, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CustomTaskOfferCopyWith<$Res>  {
  factory $CustomTaskOfferCopyWith(CustomTaskOffer value, $Res Function(CustomTaskOffer) _then) = _$CustomTaskOfferCopyWithImpl;
@useResult
$Res call({
 String id, String providerId, String providerName, double providerRating, double priceOffer, String message, DateTime createdAt
});




}
/// @nodoc
class _$CustomTaskOfferCopyWithImpl<$Res>
    implements $CustomTaskOfferCopyWith<$Res> {
  _$CustomTaskOfferCopyWithImpl(this._self, this._then);

  final CustomTaskOffer _self;
  final $Res Function(CustomTaskOffer) _then;

/// Create a copy of CustomTaskOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? providerId = null,Object? providerName = null,Object? providerRating = null,Object? priceOffer = null,Object? message = null,Object? createdAt = null,}) {
  return _then(CustomTaskOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,providerRating: null == providerRating ? _self.providerRating : providerRating // ignore: cast_nullable_to_non_nullable
as double,priceOffer: null == priceOffer ? _self.priceOffer : priceOffer // ignore: cast_nullable_to_non_nullable
as double,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomTaskOffer].
extension CustomTaskOfferPatterns on CustomTaskOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomTaskOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomTaskOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomTaskOffer value)  $default,){
final _that = this;
switch (_that) {
case _CustomTaskOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomTaskOffer value)?  $default,){
final _that = this;
switch (_that) {
case _CustomTaskOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String providerId,  String providerName,  double providerRating,  double priceOffer,  String message,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomTaskOffer() when $default != null:
return $default(_that.id,_that.providerId,_that.providerName,_that.providerRating,_that.priceOffer,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String providerId,  String providerName,  double providerRating,  double priceOffer,  String message,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CustomTaskOffer():
return $default(_that.id,_that.providerId,_that.providerName,_that.providerRating,_that.priceOffer,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String providerId,  String providerName,  double providerRating,  double priceOffer,  String message,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomTaskOffer() when $default != null:
return $default(_that.id,_that.providerId,_that.providerName,_that.providerRating,_that.priceOffer,_that.message,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomTaskOffer implements CustomTaskOffer {
  const _CustomTaskOffer({required this.id, required this.providerId, required this.providerName, required this.providerRating, required this.priceOffer, required this.message, required this.createdAt});
  factory _CustomTaskOffer.fromJson(Map<String, dynamic> json) => _$CustomTaskOfferFromJson(json);

@override final  String id;
@override final  String providerId;
@override final  String providerName;
@override final  double providerRating;
@override final  double priceOffer;
@override final  String message;
@override final  DateTime createdAt;

/// Create a copy of CustomTaskOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomTaskOfferCopyWith<_CustomTaskOffer> get copyWith => __$CustomTaskOfferCopyWithImpl<_CustomTaskOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomTaskOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomTaskOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&(identical(other.providerRating, providerRating) || other.providerRating == providerRating)&&(identical(other.priceOffer, priceOffer) || other.priceOffer == priceOffer)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,providerId,providerName,providerRating,priceOffer,message,createdAt);

@override
String toString() {
  return 'CustomTaskOffer(id: $id, providerId: $providerId, providerName: $providerName, providerRating: $providerRating, priceOffer: $priceOffer, message: $message, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CustomTaskOfferCopyWith<$Res> implements $CustomTaskOfferCopyWith<$Res> {
  factory _$CustomTaskOfferCopyWith(_CustomTaskOffer value, $Res Function(_CustomTaskOffer) _then) = __$CustomTaskOfferCopyWithImpl;
@override @useResult
$Res call({
 String id, String providerId, String providerName, double providerRating, double priceOffer, String message, DateTime createdAt
});




}
/// @nodoc
class __$CustomTaskOfferCopyWithImpl<$Res>
    implements _$CustomTaskOfferCopyWith<$Res> {
  __$CustomTaskOfferCopyWithImpl(this._self, this._then);

  final _CustomTaskOffer _self;
  final $Res Function(_CustomTaskOffer) _then;

/// Create a copy of CustomTaskOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? providerId = null,Object? providerName = null,Object? providerRating = null,Object? priceOffer = null,Object? message = null,Object? createdAt = null,}) {
  return _then(_CustomTaskOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,providerRating: null == providerRating ? _self.providerRating : providerRating // ignore: cast_nullable_to_non_nullable
as double,priceOffer: null == priceOffer ? _self.priceOffer : priceOffer // ignore: cast_nullable_to_non_nullable
as double,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CustomTaskModel {

 String get id; String get clientId; String get clientName; String get title; String get description; String get category; DateTime get date; double get budget; String get address; CustomTaskStatus get status; String? get providerId; String? get providerName; List<CustomTaskOffer> get offers; DateTime get createdAt;
/// Create a copy of CustomTaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomTaskModelCopyWith<CustomTaskModel> get copyWith => _$CustomTaskModelCopyWithImpl<CustomTaskModel>(this as CustomTaskModel, _$identity);

  /// Serializes this CustomTaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomTaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.address, address) || other.address == address)&&(identical(other.status, status) || other.status == status)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&const DeepCollectionEquality().equals(other.offers, offers)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,clientName,title,description,category,date,budget,address,status,providerId,providerName,const DeepCollectionEquality().hash(offers),createdAt);

@override
String toString() {
  return 'CustomTaskModel(id: $id, clientId: $clientId, clientName: $clientName, title: $title, description: $description, category: $category, date: $date, budget: $budget, address: $address, status: $status, providerId: $providerId, providerName: $providerName, offers: $offers, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CustomTaskModelCopyWith<$Res>  {
  factory $CustomTaskModelCopyWith(CustomTaskModel value, $Res Function(CustomTaskModel) _then) = _$CustomTaskModelCopyWithImpl;
@useResult
$Res call({
 String id, String clientId, String clientName, String title, String description, String category, DateTime date, double budget, String address, CustomTaskStatus status, String? providerId, String? providerName, List<CustomTaskOffer> offers, DateTime createdAt
});




}
/// @nodoc
class _$CustomTaskModelCopyWithImpl<$Res>
    implements $CustomTaskModelCopyWith<$Res> {
  _$CustomTaskModelCopyWithImpl(this._self, this._then);

  final CustomTaskModel _self;
  final $Res Function(CustomTaskModel) _then;

/// Create a copy of CustomTaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? clientId = null,Object? clientName = null,Object? title = null,Object? description = null,Object? category = null,Object? date = null,Object? budget = null,Object? address = null,Object? status = null,Object? providerId = freezed,Object? providerName = freezed,Object? offers = null,Object? createdAt = null,}) {
  return _then(CustomTaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CustomTaskStatus,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as List<CustomTaskOffer>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomTaskModel].
extension CustomTaskModelPatterns on CustomTaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomTaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomTaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomTaskModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomTaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomTaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomTaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientName,  String title,  String description,  String category,  DateTime date,  double budget,  String address,  CustomTaskStatus status,  String? providerId,  String? providerName,  List<CustomTaskOffer> offers,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomTaskModel() when $default != null:
return $default(_that.id,_that.clientId,_that.clientName,_that.title,_that.description,_that.category,_that.date,_that.budget,_that.address,_that.status,_that.providerId,_that.providerName,_that.offers,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String clientId,  String clientName,  String title,  String description,  String category,  DateTime date,  double budget,  String address,  CustomTaskStatus status,  String? providerId,  String? providerName,  List<CustomTaskOffer> offers,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CustomTaskModel():
return $default(_that.id,_that.clientId,_that.clientName,_that.title,_that.description,_that.category,_that.date,_that.budget,_that.address,_that.status,_that.providerId,_that.providerName,_that.offers,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String clientId,  String clientName,  String title,  String description,  String category,  DateTime date,  double budget,  String address,  CustomTaskStatus status,  String? providerId,  String? providerName,  List<CustomTaskOffer> offers,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomTaskModel() when $default != null:
return $default(_that.id,_that.clientId,_that.clientName,_that.title,_that.description,_that.category,_that.date,_that.budget,_that.address,_that.status,_that.providerId,_that.providerName,_that.offers,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomTaskModel implements CustomTaskModel {
  const _CustomTaskModel({required this.id, required this.clientId, required this.clientName, required this.title, required this.description, required this.category, required this.date, required this.budget, required this.address, required this.status, this.providerId, this.providerName, required  List<CustomTaskOffer> offers, required this.createdAt}): _offers = offers;
  factory _CustomTaskModel.fromJson(Map<String, dynamic> json) => _$CustomTaskModelFromJson(json);

@override final  String id;
@override final  String clientId;
@override final  String clientName;
@override final  String title;
@override final  String description;
@override final  String category;
@override final  DateTime date;
@override final  double budget;
@override final  String address;
@override final  CustomTaskStatus status;
@override final  String? providerId;
@override final  String? providerName;
 final  List<CustomTaskOffer> _offers;
@override List<CustomTaskOffer> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}

@override final  DateTime createdAt;

/// Create a copy of CustomTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomTaskModelCopyWith<_CustomTaskModel> get copyWith => __$CustomTaskModelCopyWithImpl<_CustomTaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomTaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomTaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.date, date) || other.date == date)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.address, address) || other.address == address)&&(identical(other.status, status) || other.status == status)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&const DeepCollectionEquality().equals(other._offers, _offers)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,clientId,clientName,title,description,category,date,budget,address,status,providerId,providerName,const DeepCollectionEquality().hash(_offers),createdAt);

@override
String toString() {
  return 'CustomTaskModel(id: $id, clientId: $clientId, clientName: $clientName, title: $title, description: $description, category: $category, date: $date, budget: $budget, address: $address, status: $status, providerId: $providerId, providerName: $providerName, offers: $offers, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CustomTaskModelCopyWith<$Res> implements $CustomTaskModelCopyWith<$Res> {
  factory _$CustomTaskModelCopyWith(_CustomTaskModel value, $Res Function(_CustomTaskModel) _then) = __$CustomTaskModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String clientId, String clientName, String title, String description, String category, DateTime date, double budget, String address, CustomTaskStatus status, String? providerId, String? providerName, List<CustomTaskOffer> offers, DateTime createdAt
});




}
/// @nodoc
class __$CustomTaskModelCopyWithImpl<$Res>
    implements _$CustomTaskModelCopyWith<$Res> {
  __$CustomTaskModelCopyWithImpl(this._self, this._then);

  final _CustomTaskModel _self;
  final $Res Function(_CustomTaskModel) _then;

/// Create a copy of CustomTaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? clientId = null,Object? clientName = null,Object? title = null,Object? description = null,Object? category = null,Object? date = null,Object? budget = null,Object? address = null,Object? status = null,Object? providerId = freezed,Object? providerName = freezed,Object? offers = null,Object? createdAt = null,}) {
  return _then(_CustomTaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CustomTaskStatus,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<CustomTaskOffer>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
