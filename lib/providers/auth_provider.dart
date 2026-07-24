import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/auth_service.dart';
import '../features/auth/data/auth_repository.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    _initializeAuth();
  }

  final AuthRepository _authRepository;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isInitialized = false;
  StreamSubscription<AuthState>? _authSubscription;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  Future<void> _initializeAuth() async {
    try {
      debugPrint('Iniciando AuthProvider con Supabase Auth');

      _authSubscription =
          AuthService.authStateChanges.listen((authState) async {
        final authUser = authState.session?.user;

        if (authUser != null) {
          await _loadUserData(authUser.id);
        } else {
          _currentUser = null;
          _setLoading(false);
          notifyListeners();
        }
      });

      final currentAuthUser = AuthService.currentUser;
      if (currentAuthUser != null) {
        await _loadUserData(currentAuthUser.id);
      } else {
        _setLoading(false);
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error inicializando AuthProvider: $e');
      _isInitialized = true;
      _setLoading(false);
      _setError('Error al inicializar autenticación');
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      _setLoading(true);
      debugPrint('Cargando datos del usuario: $userId');

      final userData = await _authRepository.getCurrentUser();
      if (userData != null) {
        _currentUser = userData;
        _clearError();
      } else {
        _setError('No se encontraron datos del usuario');
      }
    } catch (e) {
      debugPrint('Error cargando datos: $e');
      _setError('Error al cargar datos del usuario');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String? error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String? success) {
    _successMessage = success;
    _errorMessage = null;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  Future<void> checkAuthStatus() async {
    try {
      if (!_isInitialized) {
        return;
      }

      final authUser = AuthService.currentUser;
      if (authUser != null && _currentUser == null) {
        await _loadUserData(authUser.id);
      }
    } catch (e) {
      debugPrint('Error en checkAuthStatus: $e');
    }
  }

  Future<bool> signInWithProvider(OAuthProvider provider) async {
    _setLoading(true);
    _clearError();
    _successMessage = null;

    try {
      final bool launched;
      if (provider == OAuthProvider.google) {
        launched = await _authRepository.signInWithGoogle();
      } else if (provider == OAuthProvider.facebook) {
        launched = await _authRepository.signInWithFacebook();
      } else if (provider == OAuthProvider.azure) {
        launched = await _authRepository.signInWithMicrosoft();
      } else {
        launched = await _authRepository.signInWithProvider(provider);
      }

      if (!launched) {
        _setError('No se pudo iniciar la autenticación');
        return false;
      }

      _setSuccess(
        provider == OAuthProvider.google ||
                provider == OAuthProvider.facebook ||
                provider == OAuthProvider.azure
            ? 'Inicio de sesión completado'
            : 'Continua el inicio de sesión en el navegador',
      );
      return true;
    } catch (e) {
      debugPrint('Error autenticando con $provider: $e');
      final errorMessage = _getAuthErrorMessage(e.toString(), provider);
      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
      _currentUser = null;
      _clearError();
      _setSuccess('Sesión cerrada correctamente');
    } catch (e) {
      _setError('Error al cerrar sesión: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    _setLoading(true);
    _clearError();
    _successMessage = null;

    try {
      final success = await _authRepository.updateProfile(updatedUser);
      if (success) {
        _currentUser = updatedUser;
        _setSuccess('Perfil actualizado correctamente');
        return true;
      }

      _setError('Error al actualizar perfil');
      return false;
    } catch (e) {
      _setError('Error al actualizar perfil: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfileImageUrl(String imageUrl) async {
    _setLoading(true);
    _clearError();
    _successMessage = null;

    try {
      if (_currentUser == null) {
        _setError('No hay usuario autenticado');
        return false;
      }

      final success = await _authRepository.updateProfileImage(
        _currentUser!.id,
        imageUrl,
      );

      if (success) {
        _currentUser = _currentUser!.copyWith(profileImageUrl: imageUrl);
        _setSuccess('Imagen de perfil actualizada');
        return true;
      }

      _setError('Error al actualizar imagen');
      return false;
    } catch (e) {
      _setError('Error al actualizar imagen: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshUserData() async {
    final authUser = AuthService.currentUser;
    if (authUser != null) {
      await _loadUserData(authUser.id);
    }
  }

  String _getAuthErrorMessage(String error, OAuthProvider provider) {
    final providerName = provider == OAuthProvider.facebook
        ? 'Facebook'
        : provider == OAuthProvider.google
            ? 'Google'
            : provider == OAuthProvider.azure
                ? 'Microsoft'
                : 'el proveedor seleccionado';

    if (error.contains('provider is not enabled')) {
      return 'Ese proveedor aún no está habilitado en Supabase.';
    } else if (error.contains('unsupported_provider')) {
      return 'Ese proveedor no está disponible en la configuración actual.';
    } else if (error.contains('access_denied')) {
      return 'El acceso fue cancelado o denegado.';
    } else if (error.contains('canceled') || error.contains('cancelled')) {
      return 'Inicio de sesión cancelado.';
    } else if (error.contains('invalid request')) {
      return 'La configuración OAuth del proveedor está incompleta.';
    } else if (error.contains('network')) {
      return 'Error de conexión. Verifica tu internet e inténtalo de nuevo.';
    } else if (error.contains('ID token') || error.contains('access token')) {
      return 'No se pudo validar la cuenta de $providerName.';
    } else if (error.contains('ApiException: 10') ||
        error.contains('DEVELOPER_ERROR')) {
      return 'Google Sign-In no esta bien configurado para esta app.';
    }
    return 'Error de autenticación';
  }

  void clearError() => _clearError();
  void clearSuccess() => _successMessage = null;

  void clearMessages() {
    _clearError();
    _successMessage = null;
  }

  bool get isProvider => _currentUser?.hasProviderAccess == true;
  bool get isClient => _currentUser?.userType == UserType.client;
  bool get isAdmin => _currentUser?.hasAdminAccess == true;
  String? get userId => _currentUser?.id;
  String get userName => _currentUser?.name ?? 'Usuario';
  String get userEmail => _currentUser?.email ?? '';

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
