import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../../models/user/user_model.dart';

class UserRepository {
  UserRepository({SupabaseClient? client}) : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  /// Carga todos los proveedores activos.
  /// Optimizado: 3 queries en total (antes era 2N+1).
  ///   1. Consulta a `providers` para obtener todos los activos.
  ///   2. Consulta a `users` con `.inFilter` sobre la lista de uids.
  ///   3. Consulta a `provider_services` con `.inFilter` sobre la lista de provider_ids.
  /// El resultado final se construye en memoria con Maps indexados.
  Future<List<UserModel>> loadProviders() async {
    // --- Query 1: todos los providers activos ---
    final providerRows = await _client
        .from('providers')
        .select()
        .eq('is_active', true)
        .order('rating', ascending: false);

    if (providerRows.isEmpty) return [];

    final uids = providerRows.map((r) => r['uid'].toString()).toList();
    final providerIds = providerRows.map((r) => r['id'].toString()).toList();

    // --- Query 2: todos los users de esos uids en una sola consulta ---
    // supabase_flutter ^2.x usa .inFilter() (el .in_() fue deprecado)
    final userRows = await _client
        .from('users')
        .select()
        .inFilter('uid', uids);

    // --- Query 3: todos los servicios de esos providers en una sola consulta ---
    final serviceRows = await _client
        .from('provider_services')
        .select('provider_id, services(name)')
        .inFilter('provider_id', providerIds)
        .eq('is_active', true);

    // --- Indexado en memoria para lookup O(1) ---
    final usersByUid = <String, Map<String, dynamic>>{
      for (final u in userRows) u['uid'].toString(): u,
    };

    final servicesByProviderId = <String, List<String>>{};
    for (final s in serviceRows) {
      final pid = s['provider_id'].toString();
      final name = s['services']?['name']?.toString();
      if (name != null && name.isNotEmpty) {
        servicesByProviderId.putIfAbsent(pid, () => []).add(name);
      }
    }

    // --- Armado final ---
    final result = <UserModel>[];
    for (final providerRow in providerRows) {
      final uid = providerRow['uid'].toString();
      final userRow = usersByUid[uid];

      if (userRow == null) {
        // Dato inconsistente: provider sin fila correspondiente en users
        debugPrint('[UserRepository] loadProviders: sin fila en users para uid=$uid — omitiendo provider.');
        continue;
      }

      final pid = providerRow['id'].toString();
      result.add(
        UserModel.fromSupabase(
          userRow,
          providerRow: providerRow,
          services: servicesByProviderId[pid] ?? [],
        ),
      );
    }

    return result;
  }

  /// Obtiene un usuario por su uid (cliente o proveedor).
  /// Las consultas a `providers` y `users` se lanzan en paralelo con Future.wait
  /// ya que son independientes entre sí.
  Future<UserModel?> getUserById(String userId) async {
    // Ambas queries en paralelo — no dependen entre sí
    final results = await Future.wait([
      _client.from('providers').select().eq('uid', userId).maybeSingle(),
      _client.from('users').select().eq('uid', userId).maybeSingle(),
    ]);

    final providerRow = results[0];
    final userRow = results[1];

    if (userRow == null) return null;

    if (providerRow != null) {
      final serviceNames = await _loadProviderServiceNames(providerRow['id'].toString());
      return UserModel.fromSupabase(userRow, providerRow: providerRow, services: serviceNames);
    }

    return UserModel.fromSupabase(userRow);
  }

  Future<List<String>> _loadProviderServiceNames(String providerProfileId) async {
    final rows = await _client
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
