import '../../../core/services/supabase_service.dart';
import '../../../models/user_model.dart';

class UserRepository {
  Future<List<UserModel>> loadProviders() async {
    final rows = await SupabaseService.client
        .from('providers')
        .select()
        .eq('is_active', true)
        .order('rating', ascending: false);

    final mappedProviders = <UserModel>[];
    for (final raw in rows) {
      final providerRow = Map<String, dynamic>.from(raw);
      final userRows = await SupabaseService.client
          .from('users')
          .select()
          .eq('uid', providerRow['uid'])
          .limit(1);

      if (userRows.isEmpty) {
        continue;
      }

      final serviceNames = await _loadProviderServiceNames(
        providerRow['id'].toString(),
      );

      mappedProviders.add(
        UserModel.fromSupabase(
          Map<String, dynamic>.from(userRows.first),
          providerRow: providerRow,
          services: serviceNames,
        ),
      );
    }

    return mappedProviders;
  }

  Future<UserModel?> getUserById(String userId) async {
    final providerRows = await SupabaseService.client
        .from('providers')
        .select()
        .eq('uid', userId)
        .limit(1);

    if (providerRows.isNotEmpty) {
      final providerRow = Map<String, dynamic>.from(providerRows.first);
      final userRows = await SupabaseService.client
          .from('users')
          .select()
          .eq('uid', userId)
          .limit(1);

      if (userRows.isEmpty) {
        return null;
      }

      final serviceNames = await _loadProviderServiceNames(
        providerRow['id'].toString(),
      );

      return UserModel.fromSupabase(
        Map<String, dynamic>.from(userRows.first),
        providerRow: providerRow,
        services: serviceNames,
      );
    }

    final userRows = await SupabaseService.client
        .from('users')
        .select()
        .eq('uid', userId)
        .limit(1);

    if (userRows.isEmpty) {
      return null;
    }

    return UserModel.fromSupabase(Map<String, dynamic>.from(userRows.first));
  }

  Future<List<String>> _loadProviderServiceNames(String providerProfileId) async {
    final rows = await SupabaseService.client
        .from('provider_services')
        .select('services(name)')
        .eq('provider_id', providerProfileId)
        .eq('is_active', true);

    return rows
        .map((row) => row['services']?['name']?.toString())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toList();
  }
}
