import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  static const String _mobileRedirectUrl =
      'io.supabase.manachynakusa://login-callback/';

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
    );
  }

  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
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

      if (userModel.userType == UserType.provider) {
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
}
