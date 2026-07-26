// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceModel {

 String get id; String get catalogServiceId; String get name; String get description; ServiceCategory get category; double get pricePerHour; String get providerId; String get providerProfileId; String get providerName; List<String> get imageUrls; double get rating; int get totalRatings; bool get isActive; DateTime get createdAt; DateTime? get updatedAt; double? get latitude; double? get longitude; String? get address; List<String> get tags; int get estimatedDuration;
/// Create a copy of ServiceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceModelCopyWith<ServiceModel> get copyWith => _$ServiceModelCopyWithImpl<ServiceModel>(this as ServiceModel, _$identity);

  /// Serializes this ServiceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.catalogServiceId, catalogServiceId) || other.catalogServiceId == catalogServiceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.pricePerHour, pricePerHour) || other.pricePerHour == pricePerHour)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerProfileId, providerProfileId) || other.providerProfileId == providerProfileId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalRatings, totalRatings) || other.totalRatings == totalRatings)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,catalogServiceId,name,description,category,pricePerHour,providerId,providerProfileId,providerName,const DeepCollectionEquality().hash(imageUrls),rating,totalRatings,isActive,createdAt,updatedAt,latitude,longitude,address,const DeepCollectionEquality().hash(tags),estimatedDuration]);

@override
String toString() {
  return 'ServiceModel(id: $id, catalogServiceId: $catalogServiceId, name: $name, description: $description, category: $category, pricePerHour: $pricePerHour, providerId: $providerId, providerProfileId: $providerProfileId, providerName: $providerName, imageUrls: $imageUrls, rating: $rating, totalRatings: $totalRatings, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, latitude: $latitude, longitude: $longitude, address: $address, tags: $tags, estimatedDuration: $estimatedDuration)';
}


}

/// @nodoc
abstract mixin class $ServiceModelCopyWith<$Res>  {
  factory $ServiceModelCopyWith(ServiceModel value, $Res Function(ServiceModel) _then) = _$ServiceModelCopyWithImpl;
@useResult
$Res call({
 String id, String catalogServiceId, String name, String description, ServiceCategory category, double pricePerHour, String providerId, String providerProfileId, String providerName, List<String> imageUrls, double rating, int totalRatings, bool isActive, DateTime createdAt, DateTime? updatedAt, double? latitude, double? longitude, String? address, List<String> tags, int estimatedDuration
});




}
/// @nodoc
class _$ServiceModelCopyWithImpl<$Res>
    implements $ServiceModelCopyWith<$Res> {
  _$ServiceModelCopyWithImpl(this._self, this._then);

  final ServiceModel _self;
  final $Res Function(ServiceModel) _then;

/// Create a copy of ServiceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? catalogServiceId = null,Object? name = null,Object? description = null,Object? category = null,Object? pricePerHour = null,Object? providerId = null,Object? providerProfileId = null,Object? providerName = null,Object? imageUrls = null,Object? rating = null,Object? totalRatings = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? address = freezed,Object? tags = null,Object? estimatedDuration = null,}) {
  return _then(ServiceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,catalogServiceId: null == catalogServiceId ? _self.catalogServiceId : catalogServiceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ServiceCategory,pricePerHour: null == pricePerHour ? _self.pricePerHour : pricePerHour // ignore: cast_nullable_to_non_nullable
as double,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,providerProfileId: null == providerProfileId ? _self.providerProfileId : providerProfileId // ignore: cast_nullable_to_non_nullable
as String,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalRatings: null == totalRatings ? _self.totalRatings : totalRatings // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceModel].
extension ServiceModelPatterns on ServiceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceModel value)  $default,){
final _that = this;
switch (_that) {
case _ServiceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceModel value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String catalogServiceId,  String name,  String description,  ServiceCategory category,  double pricePerHour,  String providerId,  String providerProfileId,  String providerName,  List<String> imageUrls,  double rating,  int totalRatings,  bool isActive,  DateTime createdAt,  DateTime? updatedAt,  double? latitude,  double? longitude,  String? address,  List<String> tags,  int estimatedDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceModel() when $default != null:
return $default(_that.id,_that.catalogServiceId,_that.name,_that.description,_that.category,_that.pricePerHour,_that.providerId,_that.providerProfileId,_that.providerName,_that.imageUrls,_that.rating,_that.totalRatings,_that.isActive,_that.createdAt,_that.updatedAt,_that.latitude,_that.longitude,_that.address,_that.tags,_that.estimatedDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String catalogServiceId,  String name,  String description,  ServiceCategory category,  double pricePerHour,  String providerId,  String providerProfileId,  String providerName,  List<String> imageUrls,  double rating,  int totalRatings,  bool isActive,  DateTime createdAt,  DateTime? updatedAt,  double? latitude,  double? longitude,  String? address,  List<String> tags,  int estimatedDuration)  $default,) {final _that = this;
switch (_that) {
case _ServiceModel():
return $default(_that.id,_that.catalogServiceId,_that.name,_that.description,_that.category,_that.pricePerHour,_that.providerId,_that.providerProfileId,_that.providerName,_that.imageUrls,_that.rating,_that.totalRatings,_that.isActive,_that.createdAt,_that.updatedAt,_that.latitude,_that.longitude,_that.address,_that.tags,_that.estimatedDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String catalogServiceId,  String name,  String description,  ServiceCategory category,  double pricePerHour,  String providerId,  String providerProfileId,  String providerName,  List<String> imageUrls,  double rating,  int totalRatings,  bool isActive,  DateTime createdAt,  DateTime? updatedAt,  double? latitude,  double? longitude,  String? address,  List<String> tags,  int estimatedDuration)?  $default,) {final _that = this;
switch (_that) {
case _ServiceModel() when $default != null:
return $default(_that.id,_that.catalogServiceId,_that.name,_that.description,_that.category,_that.pricePerHour,_that.providerId,_that.providerProfileId,_that.providerName,_that.imageUrls,_that.rating,_that.totalRatings,_that.isActive,_that.createdAt,_that.updatedAt,_that.latitude,_that.longitude,_that.address,_that.tags,_that.estimatedDuration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceModel extends ServiceModel {
  const _ServiceModel({required this.id, required this.catalogServiceId, required this.name, required this.description, required this.category, required this.pricePerHour, required this.providerId, required this.providerProfileId, required this.providerName,  List<String> imageUrls = const [], this.rating = 0.0, this.totalRatings = 0, this.isActive = true, required this.createdAt, this.updatedAt, this.latitude, this.longitude, this.address,  List<String> tags = const [], this.estimatedDuration = 60}): _imageUrls = imageUrls,_tags = tags,super._();
  factory _ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);

@override final  String id;
@override final  String catalogServiceId;
@override final  String name;
@override final  String description;
@override final  ServiceCategory category;
@override final  double pricePerHour;
@override final  String providerId;
@override final  String providerProfileId;
@override final  String providerName;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  double rating;
@override@JsonKey() final  int totalRatings;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? address;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  int estimatedDuration;

/// Create a copy of ServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceModelCopyWith<_ServiceModel> get copyWith => __$ServiceModelCopyWithImpl<_ServiceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.catalogServiceId, catalogServiceId) || other.catalogServiceId == catalogServiceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.pricePerHour, pricePerHour) || other.pricePerHour == pricePerHour)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.providerProfileId, providerProfileId) || other.providerProfileId == providerProfileId)&&(identical(other.providerName, providerName) || other.providerName == providerName)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalRatings, totalRatings) || other.totalRatings == totalRatings)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,catalogServiceId,name,description,category,pricePerHour,providerId,providerProfileId,providerName,const DeepCollectionEquality().hash(_imageUrls),rating,totalRatings,isActive,createdAt,updatedAt,latitude,longitude,address,const DeepCollectionEquality().hash(_tags),estimatedDuration]);

@override
String toString() {
  return 'ServiceModel(id: $id, catalogServiceId: $catalogServiceId, name: $name, description: $description, category: $category, pricePerHour: $pricePerHour, providerId: $providerId, providerProfileId: $providerProfileId, providerName: $providerName, imageUrls: $imageUrls, rating: $rating, totalRatings: $totalRatings, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, latitude: $latitude, longitude: $longitude, address: $address, tags: $tags, estimatedDuration: $estimatedDuration)';
}


}

/// @nodoc
abstract mixin class _$ServiceModelCopyWith<$Res> implements $ServiceModelCopyWith<$Res> {
  factory _$ServiceModelCopyWith(_ServiceModel value, $Res Function(_ServiceModel) _then) = __$ServiceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String catalogServiceId, String name, String description, ServiceCategory category, double pricePerHour, String providerId, String providerProfileId, String providerName, List<String> imageUrls, double rating, int totalRatings, bool isActive, DateTime createdAt, DateTime? updatedAt, double? latitude, double? longitude, String? address, List<String> tags, int estimatedDuration
});




}
/// @nodoc
class __$ServiceModelCopyWithImpl<$Res>
    implements _$ServiceModelCopyWith<$Res> {
  __$ServiceModelCopyWithImpl(this._self, this._then);

  final _ServiceModel _self;
  final $Res Function(_ServiceModel) _then;

/// Create a copy of ServiceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? catalogServiceId = null,Object? name = null,Object? description = null,Object? category = null,Object? pricePerHour = null,Object? providerId = null,Object? providerProfileId = null,Object? providerName = null,Object? imageUrls = null,Object? rating = null,Object? totalRatings = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? address = freezed,Object? tags = null,Object? estimatedDuration = null,}) {
  return _then(_ServiceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,catalogServiceId: null == catalogServiceId ? _self.catalogServiceId : catalogServiceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ServiceCategory,pricePerHour: null == pricePerHour ? _self.pricePerHour : pricePerHour // ignore: cast_nullable_to_non_nullable
as double,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,providerProfileId: null == providerProfileId ? _self.providerProfileId : providerProfileId // ignore: cast_nullable_to_non_nullable
as String,providerName: null == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalRatings: null == totalRatings ? _self.totalRatings : totalRatings // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
