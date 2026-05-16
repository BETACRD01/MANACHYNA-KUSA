import 'package:flutter/material.dart';

import '../features/services/data/service_repository.dart';
import '../models/service_model.dart';

class ServiceProvider with ChangeNotifier {
  ServiceProvider({
    required ServiceRepository repository,
  }) : _repository = repository;

  final ServiceRepository _repository;
  List<ServiceModel> _services = [];
  List<ServiceModel> _filteredServices = [];
  bool _isLoading = false;
  String? _errorMessage;
  ServiceCategory? _selectedCategory;
  String _searchQuery = '';

  List<ServiceModel> get services => _filteredServices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ServiceCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadServices() async {
    _setLoading(true);
    _setError(null);

    try {
      _services = await _repository.loadServices();

      _applyFilters();
    } catch (e) {
      _setError('Error al cargar servicios');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadServicesByProvider(String providerId) async {
    _setLoading(true);
    _setError(null);

    try {
      _services = await _repository.loadServicesByProvider(providerId);

      _applyFilters();
    } catch (e) {
      _setError('Error al cargar servicios del proveedor');
    } finally {
      _setLoading(false);
    }
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      return await _repository.getServiceById(serviceId);
    } catch (e) {
      _setError('Error al obtener servicio');
      return null;
    }
  }

  Future<bool> createService(ServiceModel service) async {
    _setLoading(true);
    _setError(null);

    try {
      await _repository.createService(service);

      await loadServicesByProvider(service.providerId);
      return true;
    } catch (e) {
      _setError('Error al crear servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateService(ServiceModel service) async {
    _setLoading(true);
    _setError(null);

    try {
      await _repository.updateService(service);

      final index = _services.indexWhere((item) => item.id == service.id);
      if (index != -1) {
        _services[index] = service;
        _applyFilters();
      }
      return true;
    } catch (e) {
      _setError('Error al actualizar servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteService(String serviceId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _repository.deleteService(serviceId);

      _services.removeWhere((service) => service.id == serviceId);
      _applyFilters();
      return true;
    } catch (e) {
      _setError('Error al eliminar servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void setCategory(ServiceCategory? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredServices = _services.where((service) {
      final matchesCategory =
          _selectedCategory == null || service.category == _selectedCategory;

      final matchesSearch = _searchQuery.isEmpty ||
          service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
          );

      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  List<ServiceModel> getPopularServices() {
    return _services.where((service) => service.rating >= 4.0).take(5).toList();
  }

  List<ServiceModel> getServicesByCategory(ServiceCategory category) {
    return _services
        .where((service) => service.category == category)
        .toList();
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _applyFilters();
  }

  void clearError() {
    _setError(null);
  }
}
