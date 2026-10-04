// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get profileId; String? get providerProfileId; String get name; String get email; String get phone; String get address; String get city; UserType get userType; bool get hasProviderAccess; bool get hasAdminAccess; DateTime get createdAt; DateTime? get updatedAt; bool get isActive; String? get profileImageUrl; double? get latitude; double? get longitude; double get rating; int get totalRatings; List<String> get services; String? get description;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.providerProfileId, providerProfileId) || other.providerProfileId == providerProfileId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.hasProviderAccess, hasProviderAccess) || other.hasProviderAccess == hasProviderAccess)&&(identical(other.hasAdminAccess, hasAdminAccess) || other.hasAdminAccess == hasAdminAccess)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalRatings, totalRatings) || other.totalRatings == totalRatings)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,profileId,providerProfileId,name,email,phone,address,city,userType,hasProviderAccess,hasAdminAccess,createdAt,updatedAt,isActive,profileImageUrl,latitude,longitude,rating,totalRatings,const DeepCollectionEquality().hash(services),description]);

@override
String toString() {
  return 'UserModel(id: $id, profileId: $profileId, providerProfileId: $providerProfileId, name: $name, email: $email, phone: $phone, address: $address, city: $city, userType: $userType, hasProviderAccess: $hasProviderAccess, hasAdminAccess: $hasAdminAccess, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, profileImageUrl: $profileImageUrl, latitude: $latitude, longitude: $longitude, rating: $rating, totalRatings: $totalRatings, services: $services, description: $description)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String profileId, String? providerProfileId, String name, String email, String phone, String address, String city, UserType userType, bool hasProviderAccess, bool hasAdminAccess, DateTime createdAt, DateTime? updatedAt, bool isActive, String? profileImageUrl, double? latitude, double? longitude, double rating, int totalRatings, List<String> services, String? description
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? providerProfileId = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? address = null,Object? city = null,Object? userType = null,Object? hasProviderAccess = null,Object? hasAdminAccess = null,Object? createdAt = null,Object? updatedAt = freezed,Object? isActive = null,Object? profileImageUrl = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? rating = null,Object? totalRatings = null,Object? services = null,Object? description = freezed,}) {
  return _then(UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,providerProfileId: freezed == providerProfileId ? _self.providerProfileId : providerProfileId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as UserType,hasProviderAccess: null == hasProviderAccess ? _self.hasProviderAccess : hasProviderAccess // ignore: cast_nullable_to_non_nullable
as bool,hasAdminAccess: null == hasAdminAccess ? _self.hasAdminAccess : hasAdminAccess // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalRatings: null == totalRatings ? _self.totalRatings : totalRatings // ignore: cast_nullable_to_non_nullable
as int,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId,  String? providerProfileId,  String name,  String email,  String phone,  String address,  String city,  UserType userType,  bool hasProviderAccess,  bool hasAdminAccess,  DateTime createdAt,  DateTime? updatedAt,  bool isActive,  String? profileImageUrl,  double? latitude,  double? longitude,  double rating,  int totalRatings,  List<String> services,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.profileId,_that.providerProfileId,_that.name,_that.email,_that.phone,_that.address,_that.city,_that.userType,_that.hasProviderAccess,_that.hasAdminAccess,_that.createdAt,_that.updatedAt,_that.isActive,_that.profileImageUrl,_that.latitude,_that.longitude,_that.rating,_that.totalRatings,_that.services,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId,  String? providerProfileId,  String name,  String email,  String phone,  String address,  String city,  UserType userType,  bool hasProviderAccess,  bool hasAdminAccess,  DateTime createdAt,  DateTime? updatedAt,  bool isActive,  String? profileImageUrl,  double? latitude,  double? longitude,  double rating,  int totalRatings,  List<String> services,  String? description)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.profileId,_that.providerProfileId,_that.name,_that.email,_that.phone,_that.address,_that.city,_that.userType,_that.hasProviderAccess,_that.hasAdminAccess,_that.createdAt,_that.updatedAt,_that.isActive,_that.profileImageUrl,_that.latitude,_that.longitude,_that.rating,_that.totalRatings,_that.services,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId,  String? providerProfileId,  String name,  String email,  String phone,  String address,  String city,  UserType userType,  bool hasProviderAccess,  bool hasAdminAccess,  DateTime createdAt,  DateTime? updatedAt,  bool isActive,  String? profileImageUrl,  double? latitude,  double? longitude,  double rating,  int totalRatings,  List<String> services,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.profileId,_that.providerProfileId,_that.name,_that.email,_that.phone,_that.address,_that.city,_that.userType,_that.hasProviderAccess,_that.hasAdminAccess,_that.createdAt,_that.updatedAt,_that.isActive,_that.profileImageUrl,_that.latitude,_that.longitude,_that.rating,_that.totalRatings,_that.services,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.id, required this.profileId, this.providerProfileId, required this.name, required this.email, required this.phone, required this.address, required this.city, required this.userType, this.hasProviderAccess = false, this.hasAdminAccess = false, required this.createdAt, this.updatedAt, this.isActive = true, this.profileImageUrl, this.latitude, this.longitude, this.rating = 0.0, this.totalRatings = 0,  List<String> services = const [], this.description}): _services = services,super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String profileId;
@override final  String? providerProfileId;
@override final  String name;
@override final  String email;
@override final  String phone;
@override final  String address;
@override final  String city;
@override final  UserType userType;
@override@JsonKey() final  bool hasProviderAccess;
@override@JsonKey() final  bool hasAdminAccess;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  bool isActive;
@override final  String? profileImageUrl;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int totalRatings;
 final  List<String> _services;
@override@JsonKey() List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override final  String? description;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.providerProfileId, providerProfileId) || other.providerProfileId == providerProfileId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.hasProviderAccess, hasProviderAccess) || other.hasProviderAccess == hasProviderAccess)&&(identical(other.hasAdminAccess, hasAdminAccess) || other.hasAdminAccess == hasAdminAccess)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalRatings, totalRatings) || other.totalRatings == totalRatings)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,profileId,providerProfileId,name,email,phone,address,city,userType,hasProviderAccess,hasAdminAccess,createdAt,updatedAt,isActive,profileImageUrl,latitude,longitude,rating,totalRatings,const DeepCollectionEquality().hash(_services),description]);

@override
String toString() {
  return 'UserModel(id: $id, profileId: $profileId, providerProfileId: $providerProfileId, name: $name, email: $email, phone: $phone, address: $address, city: $city, userType: $userType, hasProviderAccess: $hasProviderAccess, hasAdminAccess: $hasAdminAccess, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, profileImageUrl: $profileImageUrl, latitude: $latitude, longitude: $longitude, rating: $rating, totalRatings: $totalRatings, services: $services, description: $description)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId, String? providerProfileId, String name, String email, String phone, String address, String city, UserType userType, bool hasProviderAccess, bool hasAdminAccess, DateTime createdAt, DateTime? updatedAt, bool isActive, String? profileImageUrl, double? latitude, double? longitude, double rating, int totalRatings, List<String> services, String? description
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? providerProfileId = freezed,Object? name = null,Object? email = null,Object? phone = null,Object? address = null,Object? city = null,Object? userType = null,Object? hasProviderAccess = null,Object? hasAdminAccess = null,Object? createdAt = null,Object? updatedAt = freezed,Object? isActive = null,Object? profileImageUrl = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? rating = null,Object? totalRatings = null,Object? services = null,Object? description = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,providerProfileId: freezed == providerProfileId ? _self.providerProfileId : providerProfileId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as UserType,hasProviderAccess: null == hasProviderAccess ? _self.hasProviderAccess : hasProviderAccess // ignore: cast_nullable_to_non_nullable
as bool,hasAdminAccess: null == hasAdminAccess ? _self.hasAdminAccess : hasAdminAccess // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalRatings: null == totalRatings ? _self.totalRatings : totalRatings // ignore: cast_nullable_to_non_nullable
as int,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
