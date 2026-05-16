import '../../../core/services/supabase_service.dart';
import '../../../models/service_model.dart';

class ServiceRepository {
  Future<List<ServiceModel>> loadServices() async {
    final rows = await SupabaseService.client
        .from('provider_services')
        .select('''
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
        ''')
        .eq('is_active', true)
        .eq('services.is_active', true)
        .eq('providers.is_active', true);

    return rows
        .map((row) => ServiceModel.fromSupabase(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<List<ServiceModel>> loadServicesByProvider(String providerUid) async {
    final rows = await SupabaseService.client
        .from('provider_services')
        .select('''
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
        ''')
        .eq('providers.uid', providerUid)
        .eq('is_active', true);

    return rows
        .map((row) => ServiceModel.fromSupabase(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    final rows = await SupabaseService.client
        .from('provider_services')
        .select('''
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
        ''')
        .eq('id', serviceId)
        .limit(1);

    if (rows.isEmpty) {
      return null;
    }

    return ServiceModel.fromSupabase(Map<String, dynamic>.from(rows.first));
  }

  Future<void> createService(ServiceModel service) {
    return SupabaseService.client
        .from('provider_services')
        .insert(service.toProviderServiceRow());
  }

  Future<void> updateService(ServiceModel service) {
    return SupabaseService.client
        .from('provider_services')
        .update(service.toProviderServiceRow())
        .eq('id', service.id);
  }

  Future<void> deleteService(String serviceId) {
    return SupabaseService.client
        .from('provider_services')
        .update({
          'is_active': false,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', serviceId);
  }
}
