import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  static SupabaseClient get _supabase => SupabaseService.client;

  static User? get currentUser => _supabase.auth.currentUser;

  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  static Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
    required String city,
    required UserType userType,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final authUser = response.user;
      if (authUser == null) {
        throw Exception('No se pudo crear el usuario en Supabase Auth');
      }

      await _upsertUserRows(
        supabaseUid: authUser.id,
        email: email,
        name: name,
        phone: phone,
        address: address,
        city: city,
        userType: userType,
      );

      return getCurrentUserData();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al registrar usuario: $e');
      }
      return null;
    }
  }

  static Future<UserModel?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final authUser = response.user;
      if (authUser == null) {
        throw Exception('No se pudo iniciar sesión en Supabase');
      }

      await _ensureUserProfileExists(
        supabaseUid: authUser.id,
        email: email,
      );

      return getCurrentUserData();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al iniciar sesión: $e');
      }
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al cerrar sesión: $e');
      }
    }
  }

  static Future<UserModel?> getCurrentUserData() async {
    try {
      final supabaseUser = _supabase.auth.currentUser;
      if (supabaseUser == null) {
        return null;
      }

      final userRows = await _supabase
          .from('users')
          .select()
          .eq('uid', supabaseUser.id)
          .limit(1);

      if (userRows.isEmpty) {
        return null;
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
      if (kDebugMode) {
        debugPrint('Error al obtener datos del usuario: $e');
      }
      return null;
    }
  }

  static Future<bool> updateUserProfile(UserModel userModel) async {
    try {
      final supabaseUid = _supabase.auth.currentUser?.id;
      if (supabaseUid == null) {
        return false;
      }

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
      if (kDebugMode) {
        debugPrint('Error al actualizar perfil: $e');
      }
      return false;
    }
  }

  static Future<bool> updateProfileImage(String userId, String imageUrl) async {
    try {
      await _supabase
          .from('users')
          .update({
            'avatar_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('uid', userId);

      await _supabase
          .from('providers')
          .update({
            'avatar_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('uid', userId);

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating profile image: $e');
      }
      return false;
    }
  }

  static Future<bool> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al enviar email de restablecimiento: $e');
      }
      return false;
    }
  }

  static Future<void> _ensureUserProfileExists({
    required String supabaseUid,
    required String email,
  }) async {
    final userRows = await _supabase
        .from('users')
        .select('id')
        .eq('uid', supabaseUid)
        .limit(1);

    if (userRows.isNotEmpty) {
      return;
    }

    final fallbackName = email.split('@').first;
    await _upsertUserRows(
      supabaseUid: supabaseUid,
      email: email,
      name: fallbackName,
      phone: '',
      address: '',
      city: 'Tena',
      userType: UserType.client,
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
}
