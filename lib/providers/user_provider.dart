import 'package:flutter/material.dart';

import '../features/users/data/user_repository.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserProvider({
    required UserRepository repository,
  }) : _repository = repository;

  final UserRepository _repository;
  List<UserModel> _providers = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = true;

  List<UserModel> get providers => _providers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadProviders() async {
    _setLoading(true);
    _setError(null);

    try {
      _providers = await _repository.loadProviders();
    } catch (e) {
      _setError('Error al cargar proveedores: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _repository.getUserById(userId);
    } catch (e) {
      _setError('Error al obtener usuario: ${e.toString()}');
      return null;
    }
  }

  Future<List<UserModel>> searchProviders(String query) async {
    if (_providers.isEmpty) {
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
    return _providers.where((provider) => provider.rating >= 4.0).take(5).toList();
  }

  List<UserModel> getProvidersByService(String service) {
    return _providers
        .where((provider) => provider.services.contains(service))
        .toList();
  }
  void clearError() {
    _setError(null);
  }

  Future<void> reinitialize() async {
    _isInitialized = true;
    notifyListeners();
  }
}
