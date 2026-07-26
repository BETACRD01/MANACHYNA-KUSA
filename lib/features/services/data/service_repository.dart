import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../../models/service/service_model.dart';

class ServiceRepository {
  ServiceRepository({SupabaseClient? client})
    : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  static const String _serviceQuery = '''
    id,
    price,
    description,
    is_active,
    created_at,
    updated_at,
    services!inner(
      id,
      name,
      slug,
      description,
      short_description,
      image_url,
      base_price,
      estimated_duration_minutes,
      is_active,
      metadata,
      service_categories(slug)
    ),
    providers!inner(
      id,
      uid,
      name,
      full_name,
      avatar_url,
      rating,
      reviews_count,
      address,
      latitude,
      longitude,
      is_active
    )
  ''';

  Future<List<ServiceModel>> loadServices() async {
    final rows = await _client
        .from('provider_services')
        .select(_serviceQuery)
        .eq('is_active', true)
        .eq('services.is_active', true)
        .eq('providers.is_active', true);

    return rows.map((row) => ServiceModel.fromSupabase(row)).toList();
  }

  /// Carga todos los servicios de un proveedor (incluye inactivos).
  /// Se usa en el panel del proveedor, donde necesita ver y gestionar
  /// todos sus servicios, no solo los activos del catálogo público.
  Future<List<ServiceModel>> loadServicesByProvider(String providerUid) async {
    final rows = await _client
        .from('provider_services')
        .select(_serviceQuery)
        .eq('providers.uid', providerUid)
        .eq('is_active', true);

    return rows.map((row) => ServiceModel.fromSupabase(row)).toList();
  }

  Future<ServiceModel?> getServiceById(String providerServiceId) async {
    final row = await _client
        .from('provider_services')
        .select(_serviceQuery)
        .eq('id', providerServiceId)
        .maybeSingle();

    if (row == null) return null;
    return ServiceModel.fromSupabase(row);
  }

  Future<void> createService(ServiceModel service) {
    return _client
        .from('provider_services')
        .insert(service.toProviderServiceRow());
  }

  Future<void> updateService(ServiceModel service) {
    return _client
        .from('provider_services')
        .update(service.toProviderServiceRow())
        .eq('id', service.id);
  }

  /// Soft-delete: marca el servicio como inactivo en lugar de borrarlo físicamente.
  Future<void> deactivateService(String providerServiceId) {
    return _client
        .from('provider_services')
        .update({
          'is_active': false,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', providerServiceId);
  }
}
