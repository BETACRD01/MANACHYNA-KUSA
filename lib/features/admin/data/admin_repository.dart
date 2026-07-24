import '../../../core/services/supabase_service.dart';

class AdminRepository {
  Future<AdminDashboardData> loadDashboard() async {
    final response = await SupabaseService.client.functions.invoke(
      'admin-dashboard',
      body: {'action': 'overview'},
    );
    final data = response.data;
    if (data is! Map) {
      throw Exception('El servidor no devolvio datos validos.');
    }
    if (data['error'] is String) {
      final details = data['details']?.toString();
      throw Exception(
        details == null || details.isEmpty
            ? data['error'] as String
            : '${data['error']}: $details',
      );
    }
    return AdminDashboardData.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> approveProvider(String providerId) {
    return _setProviderStatus(providerId, 'approve');
  }

  Future<void> suspendProvider(String providerId) {
    return _setProviderStatus(providerId, 'suspend');
  }

  Future<void> reactivateProvider(String providerId) {
    return _setProviderStatus(providerId, 'reactivate');
  }

  Future<void> _setProviderStatus(String providerId, String action) async {
    final response = await SupabaseService.client.functions.invoke(
      'admin-dashboard',
      body: {
        'action': action,
        'provider_id': providerId,
      },
    );
    final data = response.data;
    if (data is Map && data['error'] is String) {
      throw Exception(data['error'] as String);
    }
  }
}

class AdminDashboardData {
  const AdminDashboardData({
    required this.stats,
    required this.providers,
    required this.recentBookings,
  });

  final AdminStats stats;
  final List<AdminProvider> providers;
  final List<AdminBookingSummary> recentBookings;

  factory AdminDashboardData.fromMap(Map<String, dynamic> map) {
    final providersRaw = map['providers'];
    final bookingsRaw = map['recent_bookings'];
    return AdminDashboardData(
      stats: AdminStats.fromMap(
        Map<String, dynamic>.from(map['stats'] as Map? ?? const {}),
      ),
      providers: providersRaw is List
          ? providersRaw
              .whereType<Map>()
              .map((item) => AdminProvider.fromMap(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      recentBookings: bookingsRaw is List
          ? bookingsRaw
              .whereType<Map>()
              .map(
                (item) => AdminBookingSummary.fromMap(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
    );
  }
}

class AdminStats {
  const AdminStats({
    required this.totalUsers,
    required this.totalProviders,
    required this.pendingProviders,
    required this.activeProviders,
    required this.totalBookings,
    required this.pendingBookings,
    required this.activeServices,
  });

  final int totalUsers;
  final int totalProviders;
  final int pendingProviders;
  final int activeProviders;
  final int totalBookings;
  final int pendingBookings;
  final int activeServices;

  factory AdminStats.fromMap(Map<String, dynamic> map) {
    return AdminStats(
      totalUsers: _toInt(map['total_users']),
      totalProviders: _toInt(map['total_providers']),
      pendingProviders: _toInt(map['pending_providers']),
      activeProviders: _toInt(map['active_providers']),
      totalBookings: _toInt(map['total_bookings']),
      pendingBookings: _toInt(map['pending_bookings']),
      activeServices: _toInt(map['active_services']),
    );
  }
}

class AdminProvider {
  const AdminProvider({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.status,
    required this.isActive,
    required this.rating,
    required this.reviewsCount,
    this.createdAt,
  });

  final String id;
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String status;
  final bool isActive;
  final double rating;
  final int reviewsCount;
  final DateTime? createdAt;

  bool get isPending => status == 'pending';
  bool get isSuspended => status == 'suspended' || !isActive;

  factory AdminProvider.fromMap(Map<String, dynamic> map) {
    return AdminProvider(
      id: (map['id'] ?? '').toString(),
      uid: (map['uid'] ?? '').toString(),
      name: (map['full_name'] ?? map['name'] ?? 'Proveedor').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      city: (map['city'] ?? '').toString(),
      status: (map['status'] ?? 'pending').toString(),
      isActive: map['is_active'] == true,
      rating: _toDouble(map['rating']),
      reviewsCount: _toInt(map['reviews_count']),
      createdAt: DateTime.tryParse((map['created_at'] ?? '').toString()),
    );
  }
}

class AdminBookingSummary {
  const AdminBookingSummary({
    required this.id,
    required this.status,
    required this.serviceName,
    required this.clientName,
    required this.providerName,
    required this.totalPrice,
    this.scheduledDate,
  });

  final String id;
  final String status;
  final String serviceName;
  final String clientName;
  final String providerName;
  final double totalPrice;
  final DateTime? scheduledDate;

  factory AdminBookingSummary.fromMap(Map<String, dynamic> map) {
    return AdminBookingSummary(
      id: (map['id'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      serviceName: (map['service_name'] ?? 'Servicio').toString(),
      clientName: (map['client_name'] ?? 'Cliente').toString(),
      providerName: (map['provider_name'] ?? 'Proveedor').toString(),
      totalPrice: _toDouble(map['total_amount']),
      scheduledDate: DateTime.tryParse((map['scheduled_date'] ?? '').toString()),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}
