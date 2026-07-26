import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/users/data/user_repository.dart';
import '../models/user/user_model.dart';

class UserProvider with ChangeNotifier {
  UserProvider({
    required UserRepository repository,
  }) : _repository = repository;

  final UserRepository _repository;
  List<UserModel> _providers = [];
  bool _isLoading = false;
  String? _errorMessage;

  // false = todavía no se ha intentado cargar los proveedores.
  // true  = loadProviders() ya se ejecutó al menos una vez (exitoso o con error).
  bool _isInitialized = false;

  // ---------------------------------------------------------------------------
  // CONSTANTES DE NEGOCIO
  // ---------------------------------------------------------------------------

  static const double _topRatedMinimumRating = 4.0;
  static const int _topRatedMaxResults = 5;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  List<UserModel> get providers => _providers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// true cuando loadProviders() ya se ejecutó al menos una vez.
  /// Útil para distinguir "cargando por primera vez" de "cargado (sin resultados)".
  bool get isInitialized => _isInitialized;

  // ---------------------------------------------------------------------------
  // HELPERS DE ESTADO INTERNOS
  // ---------------------------------------------------------------------------

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Inicia una operación: activa loading, limpia error, notifica UNA sola vez.
  void _beginOperation() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // OPERACIONES
  // ---------------------------------------------------------------------------

  Future<void> loadProviders() async {
    _beginOperation();

    try {
      _providers = await _repository.loadProviders();
    } catch (e) {
      debugPrint('[UserProvider.loadProviders] $e');
      _setError('Error al cargar proveedores');
    } finally {
      // Se marca como inicializado tanto en el camino exitoso como en el de
      // error, para que la UI pueda distinguir "aún cargando" de "ya intentó".
      _isInitialized = true;
      _setLoading(false);
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _repository.getUserById(userId);
    } catch (e) {
      debugPrint('[UserProvider.getUserById] $e');
      _setError('Error al obtener proveedor');
      return null;
    }
  }

  /// Busca proveedores por nombre o servicio.
  ///
  /// Si la lista aún no se ha cargado (!_isInitialized), realiza la carga
  /// automáticamente antes de filtrar. Usar `_isInitialized` en lugar de
  /// `_providers.isEmpty` evita recargar cuando el resultado real es "sin
  /// proveedores disponibles" (lista vacía pero ya cargada).
  Future<List<UserModel>> searchProviders(String query) async {
    if (!_isInitialized) {
      await loadProviders();
    }

    final normalized = query.toLowerCase();
    return _providers.where((provider) {
      return provider.name.toLowerCase().contains(normalized) ||
          provider.services.any(
            (service) => service.toLowerCase().contains(normalized),
          );
    }).toList();
  }

  List<UserModel> getTopRatedProviders() {
    return _providers
        .where((provider) => provider.rating >= _topRatedMinimumRating)
        .take(_topRatedMaxResults)
        .toList();
  }

  List<UserModel> getProvidersByService(String service) {
    return _providers
        .where((provider) => provider.services.contains(service))
        .toList();
  }

  /// Recarga la lista de proveedores desde el repositorio.
  /// Equivalente a llamar loadProviders() directamente.
  Future<void> reinitialize() => loadProviders();

  void clearError() {
    _setError(null);
  }
}
