import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/services/data/service_repository.dart';
import '../models/service/service_model.dart';

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

  // ---------------------------------------------------------------------------
  // CONSTANTES DE NEGOCIO
  // ---------------------------------------------------------------------------

  static const double _popularMinimumRating = 4.0;
  static const int _popularMaxResults = 5;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  List<ServiceModel> get services => _filteredServices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ServiceCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

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
  // CARGA
  // ---------------------------------------------------------------------------

  Future<void> loadServices() async {
    _beginOperation();

    try {
      _services = await _repository.loadServices();
      _applyFilters();
    } catch (e) {
      debugPrint('[ServiceProvider.loadServices] $e');
      _setError('Error al cargar servicios');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadServicesByProvider(String providerId) async {
    _beginOperation();

    try {
      _services = await _repository.loadServicesByProvider(providerId);
      _applyFilters();
    } catch (e) {
      debugPrint('[ServiceProvider.loadServicesByProvider] $e');
      _setError('Error al cargar servicios del proveedor');
    } finally {
      _setLoading(false);
    }
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      return await _repository.getServiceById(serviceId);
    } catch (e) {
      debugPrint('[ServiceProvider.getServiceById] $e');
      _setError('Error al obtener servicio');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // MUTACIONES
  // ---------------------------------------------------------------------------

  /// Crea un servicio en el repositorio.
  ///
  /// Comportamiento de recarga post-creación:
  ///   - Inserta el nuevo servicio optimistamente en _services en memoria.
  ///   - NO llama a loadServicesByProvider() de forma implícita, para evitar
  ///     sobreescribir una lista de catálogo público (loadServices) que otra
  ///     pantalla pueda estar mostrando simultáneamente. El caller es
  ///     responsable de llamar loadServicesByProvider() si necesita refrescar.
  Future<bool> createService(ServiceModel service) async {
    _beginOperation();

    try {
      await _repository.createService(service);

      // Inserción optimista en memoria — mantiene la lista local actualizada
      // sin forzar una recarga completa que podría pisar el estado de otra vista.
      _services = [service, ..._services];
      _applyFilters();
      return true;
    } catch (e) {
      debugPrint('[ServiceProvider.createService] $e');
      _setError('Error al crear servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateService(ServiceModel service) async {
    _beginOperation();

    try {
      await _repository.updateService(service);

      final index = _services.indexWhere((item) => item.id == service.id);
      if (index != -1) {
        _services[index] = service;
        _applyFilters();
      } else {
        // El servicio no estaba en la lista local (posible carga parcial o
        // navegación directa). La actualización en BD sí ocurrió.
        debugPrint('[ServiceProvider.updateService] servicio id=${service.id} '
            'no encontrado en _services — la lista local puede estar desactualizada.');
      }
      return true;
    } catch (e) {
      debugPrint('[ServiceProvider.updateService] $e');
      _setError('Error al actualizar servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deactivateService(String serviceId) async {
    _beginOperation();

    try {
      await _repository.deactivateService(serviceId);

      _services.removeWhere((service) => service.id == serviceId);
      _applyFilters();
      return true;
    } catch (e) {
      debugPrint('[ServiceProvider.deactivateService] $e');
      _setError('Error al desactivar servicio');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ---------------------------------------------------------------------------
  // FILTROS
  // ---------------------------------------------------------------------------

  void setCategory(ServiceCategory? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    // Se calcula una sola vez para todas las comparaciones dentro del .where().
    final normalizedQuery = _searchQuery.toLowerCase();

    _filteredServices = _services.where((service) {
      final matchesCategory =
          _selectedCategory == null || service.category == _selectedCategory;

      final matchesSearch = _searchQuery.isEmpty ||
          service.name.toLowerCase().contains(normalizedQuery) ||
          service.description.toLowerCase().contains(normalizedQuery) ||
          service.tags.any((tag) => tag.toLowerCase().contains(normalizedQuery));

      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // GETTERS DE CONVENIENCIA (SÍNCRONOS)
  // ---------------------------------------------------------------------------

  List<ServiceModel> getPopularServices() {
    return _services
        .where((service) => service.rating >= _popularMinimumRating)
        .take(_popularMaxResults)
        .toList();
  }

  List<ServiceModel> getServicesByCategory(ServiceCategory category) {
    return _services.where((service) => service.category == category).toList();
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
