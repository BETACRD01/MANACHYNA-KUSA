import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  static const String _mobileRedirectUrl =
      'io.supabase.manachynakusa://login-callback/';
  static const String _googleWebClientId =
      '265582480726-lfi3eohu2s3jjjut3r7mibci2umgfgbs.apps.googleusercontent.com';
  static const String _googleAndroidClientId =
      '265582480726-ahiesironihk30mkn6nljl9i6o89vdh9.apps.googleusercontent.com';
  static const String _googleIosClientId =
      '265582480726-mlmcq2vbm3mf2nnime4uj32tuhhvg22c.apps.googleusercontent.com';
  static const String _microsoftClientId = String.fromEnvironment(
    'MICROSOFT_CLIENT_ID',
    defaultValue: '38b33db3-9f5c-455d-ae6c-baf67dd9b9ab',
  );
  static const String _microsoftRedirectUrl =
      'com.manachynakusa.app://oauthredirect';
  static const AuthorizationServiceConfiguration _microsoftServiceConfig =
      AuthorizationServiceConfiguration(
    authorizationEndpoint:
        'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
    tokenEndpoint: 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
  );

  static Future<void>? _googleInitializeFuture;
  static const FlutterAppAuth _appAuth = FlutterAppAuth();

  static SupabaseClient get _supabase => SupabaseService.client;

  static User? get currentUser {
    try {
      return _supabase.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  static Stream<AuthState> get authStateChanges {
    try {
      return _supabase.auth.onAuthStateChange;
    } catch (_) {
      return const Stream.empty();
    }
  }

  static Future<bool> signInWithProvider(OAuthProvider provider) {
    return _supabase.auth.signInWithOAuth(
      provider,
      redirectTo: kIsWeb ? null : _mobileRedirectUrl,
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      queryParams: provider == OAuthProvider.google
          ? const {'prompt': 'select_account'}
          : null,
    );
  }

  static Future<bool> signInWithGoogle() async {
    if (kIsWeb) {
      return signInWithProvider(OAuthProvider.google);
    }

    await _initializeGoogleSignIn();

    final googleSignIn = GoogleSignIn.instance;
    if (!googleSignIn.supportsAuthenticate()) {
      throw const AuthException(
        'Google Sign-In nativo no esta disponible en esta plataforma.',
      );
    }

    GoogleSignInAccount googleUser;
    try {
      googleUser = await googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (kDebugMode) {
        debugPrint('Google Sign-In nativo fallo: $e');
      }

      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.clientConfigurationError ||
          e.code == GoogleSignInExceptionCode.providerConfigurationError) {
        throw AuthException(
          'Google Sign-In nativo no esta configurado correctamente: ${e.description ?? e.code.name}',
        );
      }

      rethrow;
    }

    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw const AuthException('Google no entrego un ID token valido.');
    }

    await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );

    return true;
  }

  static Future<bool> signInWithFacebook() async {
    if (kIsWeb) {
      return signInWithProvider(OAuthProvider.facebook);
    }

    late final LoginResult result;
    final facebookNonce = Platform.isAndroid ? _createNonce() : null;

    if (Platform.isIOS) {
      result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email'],
        loginTracking: LoginTracking.limited,
      );
    } else {
      result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email', 'openid'],
        loginBehavior: LoginBehavior.nativeOnly,
        nonce: facebookNonce,
      );
    }

      debugPrint(
        '[Facebook] status=${result.status} message=${result.message} '
      'tokenType=${result.accessToken?.runtimeType} '
      'applicationId=${result.accessToken is ClassicToken ? (result.accessToken as ClassicToken).applicationId : 'n/a'}',
    );

    if (result.status != LoginStatus.success) {
      throw AuthException(
        result.message ?? 'Facebook Sign-In fue cancelado o fallo.',
      );
    }

    final accessToken = result.accessToken;
    final String idToken;

    if (accessToken is LimitedToken) {
      idToken = accessToken.tokenString;
    } else if (accessToken is ClassicToken) {
      final authToken = accessToken.authenticationToken;
      if (authToken == null || authToken.isEmpty) {
        await _signInWithFacebookClassicToken(accessToken.tokenString);
        return true;
      }
      idToken = authToken;
    } else {
      throw AuthException(
        'Facebook entrego un tipo de token inesperado: '
        '${accessToken.runtimeType}',
      );
    }

    await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.facebook,
      idToken: idToken,
      nonce: facebookNonce,
    );

    return true;
  }

  static Future<bool> signInWithMicrosoft() async {
    if (kIsWeb) {
      return signInWithProvider(OAuthProvider.azure);
    }

    if (_microsoftClientId.isEmpty) {
      throw const AuthException(
        'Microsoft Sign-In nativo necesita MICROSOFT_CLIENT_ID configurado.',
      );
    }

    late final AuthorizationTokenResponse result;
    try {
      debugPrint(
        '[Microsoft] clientId=$_microsoftClientId redirect=$_microsoftRedirectUrl',
      );
      result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _microsoftClientId,
          _microsoftRedirectUrl,
          serviceConfiguration: _microsoftServiceConfig,
          scopes: const ['openid', 'profile', 'email', 'User.Read'],
          promptValues: const ['select_account'],
        ),
      );
    } on FlutterAppAuthUserCancelledException {
      throw const AuthException('Inicio de sesión cancelado.');
    }

    final idToken = result.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const AuthException('Microsoft no entrego un ID token valido.');
    }

    await _signInWithMicrosoftToken(
      idToken: idToken,
      accessToken: result.accessToken,
    );

    return true;
  }

  static Future<void> _signInWithFacebookClassicToken(String token) async {
    late final dynamic response;
    try {
      response = await _supabase.functions.invoke(
        'facebook-native-auth',
        body: {'access_token': token},
      );
    } catch (error) {
      debugPrint('[Facebook backend] $error');
      throw AuthException('Facebook backend: $error');
    }
    final data = response.data;
    if (data is! Map || data['email'] is! String || data['token_hash'] is! String) {
      throw AuthException(
        data is Map && data['error'] is String
            ? data['error'] as String
            : 'El servidor no devolvio una sesion valida.',
      );
    }

    await _supabase.auth.verifyOTP(
      type: OtpType.magiclink,
      tokenHash: data['token_hash'] as String,
    );
  }

  static Future<void> _signInWithMicrosoftToken({
    required String idToken,
    String? accessToken,
  }) async {
    late final dynamic response;
    try {
      response = await _supabase.functions.invoke(
        'microsoft-native-auth',
        body: {
          'id_token': idToken,
          if (accessToken != null && accessToken.isNotEmpty)
            'access_token': accessToken,
        },
      );
    } catch (error) {
      debugPrint('[Microsoft backend] $error');
      throw AuthException('Microsoft backend: $error');
    }

    final data = response.data;
    if (data is! Map || data['email'] is! String || data['token_hash'] is! String) {
      throw AuthException(
        data is Map && data['error'] is String
            ? data['error'] as String
            : 'El servidor no devolvio una sesion valida.',
      );
    }

    await _supabase.auth.verifyOTP(
      type: OtpType.magiclink,
      tokenHash: data['token_hash'] as String,
    );
  }

  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      if (!kIsWeb && _googleInitializeFuture != null) {
        await GoogleSignIn.instance.signOut();
      }
      if (!kIsWeb) {
        await FacebookAuth.instance.logOut();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error al cerrar sesión: $e');
    }
  }

  static Future<UserModel?> getCurrentUserData() async {
    try {
      final supabaseUser = _supabase.auth.currentUser;
      if (supabaseUser == null) return null;

      final userRows = await _supabase
          .from('users')
          .select()
          .eq('uid', supabaseUser.id)
          .limit(1);

      // Primer login OAuth: crea el perfil y vuelve a consultar
      if (userRows.isEmpty) {
        await _ensureUserProfileExistsForCurrentUser(supabaseUser);

        final refreshedUserRows = await _supabase
            .from('users')
            .select()
            .eq('uid', supabaseUser.id)
            .limit(1);

        if (refreshedUserRows.isEmpty) return null;

        return UserModel.fromSupabase(
          Map<String, dynamic>.from(refreshedUserRows.first),
        );
      }

      final userRow = Map<String, dynamic>.from(userRows.first);

      final providerRows = await _supabase
          .from('providers')
          .select()
          .eq('uid', supabaseUser.id)
          .limit(1);

      Map<String, dynamic>? providerRow;
      List<String> providerServices = const [];

      if (providerRows.isNotEmpty) {
        providerRow = Map<String, dynamic>.from(providerRows.first);
        providerServices = await _loadProviderServiceNames(
          providerId: providerRow['id'].toString(),
        );
      }

      return UserModel.fromSupabase(
        userRow,
        providerRow: providerRow,
        services: providerServices,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  static Future<bool> updateUserProfile(UserModel userModel) async {
    try {
      final supabaseUid = _supabase.auth.currentUser?.id;
      if (supabaseUid == null) return false;

      await _supabase
          .from('users')
          .update(userModel.toUserRow())
          .eq('uid', supabaseUid);

      if (userModel.hasProviderAccess) {
        final providerRows = await _supabase
            .from('providers')
            .select('id')
            .eq('uid', supabaseUid)
            .limit(1);

        if (providerRows.isNotEmpty) {
          await _supabase
              .from('providers')
              .update(userModel.toProviderRow())
              .eq('uid', supabaseUid);
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Error al actualizar perfil: $e');
      return false;
    }
  }

  // Solo actualiza la tabla providers si el usuario tiene fila en ella
  static Future<bool> updateProfileImage(String userId, String imageUrl) async {
    try {
      final now = DateTime.now().toIso8601String();
      final payload = {'avatar_url': imageUrl, 'updated_at': now};

      await _supabase.from('users').update(payload).eq('uid', userId);

      final providerRows = await _supabase
          .from('providers')
          .select('id')
          .eq('uid', userId)
          .limit(1);

      if (providerRows.isNotEmpty) {
        await _supabase.from('providers').update(payload).eq('uid', userId);
      }

      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Error al actualizar imagen de perfil: $e');
      return false;
    }
  }

  static Future<void> _ensureUserProfileExistsForCurrentUser(User authUser) {
    final metadata = authUser.userMetadata ?? const <String, dynamic>{};
    final email = authUser.email ?? '${authUser.id}@oauth.local';
    final name = _resolveDisplayName(authUser, metadata);
    final avatarUrl = metadata['avatar_url']?.toString();
    final phone = metadata['phone']?.toString() ?? '';

    return _upsertUserRows(
      supabaseUid: authUser.id,
      email: email,
      name: name,
      phone: phone,
      address: '',
      city: '', // el usuario completa su ciudad en el perfil
      userType: UserType.client,
      avatarUrl: avatarUrl,
    );
  }

  static Future<void> _upsertUserRows({
    required String supabaseUid,
    required String email,
    required String name,
    required String phone,
    required String address,
    required String city,
    required UserType userType,
    String? avatarUrl,
  }) async {
    await _supabase.from('users').upsert({
      'uid': supabaseUid,
      'email': email,
      'name': name,
      'full_name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'role': _userRole(userType),
      'is_provider': userType == UserType.provider,
      'is_active': true,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'uid');

    if (userType == UserType.provider) {
      await _supabase.from('providers').upsert({
        'uid': supabaseUid,
        'email': email,
        'name': name,
        'full_name': name,
        'phone': phone,
        'address': address,
        'city': city,
        'avatar_url': avatarUrl,
        'status': 'pending',
        'is_active': true,
        'is_available': true,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'uid');
    }
  }

  static Future<List<String>> _loadProviderServiceNames({
    required String providerId,
  }) async {
    final rows = await _supabase
        .from('provider_services')
        .select('services(name)')
        .eq('provider_id', providerId)
        .eq('is_active', true);

    return rows
        .map((row) => row['services']?['name']?.toString())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toList();
  }

  static String _userRole(UserType userType) {
    switch (userType) {
      case UserType.provider:
        return 'provider';
      case UserType.admin:
        return 'admin';
      case UserType.client:
        return 'client';
    }
  }

  static String _resolveDisplayName(
    User authUser,
    Map<String, dynamic> metadata,
  ) {
    final candidates = [
      metadata['full_name'],
      metadata['name'],
      metadata['preferred_username'],
      authUser.email?.split('@').first,
      'Usuario',
    ];

    for (final value in candidates) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }

    return 'Usuario';
  }

  static Future<void> _initializeGoogleSignIn() {
    return _googleInitializeFuture ??= GoogleSignIn.instance.initialize(
      clientId: _googlePlatformClientId(),
      serverClientId: _googleWebClientId,
    );
  }

  static String? _googlePlatformClientId() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _googleAndroidClientId;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _googleIosClientId;
    }
    return null;
  }

  static String _createNonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
