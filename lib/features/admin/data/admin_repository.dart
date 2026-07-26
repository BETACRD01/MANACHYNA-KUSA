import '../../../core/services/supabase_service.dart';

class AdminRepository {
  Future<AdminDashboardData> loadDashboard() async {
    try {
      final response = await SupabaseService.client.functions.invoke(
        'admin-dashboard',
        body: {'action': 'overview'},
      );
      final data = response.data;
      if (data is! Map) {
        throw Exception('El servidor no devolvió datos válidos.');
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
    } catch (error) {
      if (!_shouldUseAdminFallback(error)) rethrow;
      return _mockAdminDashboardData();
    }
  }

  Future<AdminDashboardData> refreshDashboard() => loadDashboard();

  Future<PaginatedResult<AdminProvider>> loadProviders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? statusFilter,
  }) async {
    try {
      final response = await SupabaseService.client.functions.invoke(
        'admin-dashboard',
        body: {
          'action': 'list_providers',
          'page': page,
          'page_size': pageSize,
          if (search != null && search.isNotEmpty) 'search': search,
          if (statusFilter != null && statusFilter != 'all')
            'status': statusFilter,
        },
      );
      final data = response.data;
      if (data is! Map) throw Exception('Respuesta inválida del servidor.');
      if (data['error'] is String) throw Exception(data['error']);
      return PaginatedResult.fromMap(
        Map<String, dynamic>.from(data),
        (item) => AdminProvider.fromMap(Map<String, dynamic>.from(item)),
      );
    } catch (error) {
      if (!_shouldUseAdminFallback(error)) rethrow;
      final items = _filterMockProviders(
        _mockAdminProviders(),
        search: search,
        statusFilter: statusFilter,
      );
      return PaginatedResult(
        items: items,
        total: items.length,
        page: page,
        pageSize: pageSize,
        hasMore: false,
      );
    }
  }

  Future<PaginatedResult<AdminBookingSummary>> loadBookings({
    int page = 1,
    int pageSize = 20,
    String? statusFilter,
  }) async {
    try {
      final response = await SupabaseService.client.functions.invoke(
        'admin-dashboard',
        body: {
          'action': 'list_bookings',
          'page': page,
          'page_size': pageSize,
          if (statusFilter != null && statusFilter != 'all')
            'status': statusFilter,
        },
      );
      final data = response.data;
      if (data is! Map) throw Exception('Respuesta inválida del servidor.');
      if (data['error'] is String) throw Exception(data['error']);
      return PaginatedResult.fromMap(
        Map<String, dynamic>.from(data),
        (item) => AdminBookingSummary.fromMap(Map<String, dynamic>.from(item)),
      );
    } catch (error) {
      if (!_shouldUseAdminFallback(error)) rethrow;
      final items = _mockAdminBookings()
          .where(
            (item) =>
                statusFilter == null ||
                statusFilter == 'all' ||
                item.status == statusFilter,
          )
          .toList();
      return PaginatedResult(
        items: items,
        total: items.length,
        page: page,
        pageSize: pageSize,
        hasMore: false,
      );
    }
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

  Future<void> deleteService(String serviceId) async {
    final response = await SupabaseService.client.functions.invoke(
      'admin-dashboard',
      body: {
        'action': 'delete_service',
        'service_id': serviceId,
      },
    );
    final data = response.data;
    if (data is Map && data['error'] is String) {
      throw Exception(data['error'] as String);
    }
  }

  Future<void> toggleServiceStatus(String serviceId, bool isActive) async {
    final response = await SupabaseService.client.functions.invoke(
      'admin-dashboard',
      body: {
        'action': 'toggle_service',
        'service_id': serviceId,
        'is_active': isActive,
      },
    );
    final data = response.data;
    if (data is Map && data['error'] is String) {
      throw Exception(data['error'] as String);
    }
  }

  Future<List<AdminServiceSummary>> loadServices() async {
    try {
      final response = await SupabaseService.client.functions.invoke(
        'admin-dashboard',
        body: {'action': 'list_services'},
      );
      final data = response.data;
      if (data is! Map) throw Exception('Respuesta inválida.');
      if (data['error'] is String) throw Exception(data['error']);
      final list = data['services'];
      if (list is! List) return [];
      return list
          .whereType<Map>()
          .map((item) =>
              AdminServiceSummary.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (error) {
      if (!_shouldUseAdminFallback(error)) rethrow;
      return _mockAdminServices();
    }
  }

  Future<AdminReportsData> loadReports() async {
    try {
      final response = await SupabaseService.client.functions.invoke(
        'admin-dashboard',
        body: {'action': 'reports'},
      );
      final data = response.data;
      if (data is! Map) throw Exception('Respuesta inválida.');
      if (data['error'] is String) throw Exception(data['error']);
      return AdminReportsData.fromMap(Map<String, dynamic>.from(data));
    } catch (error) {
      if (!_shouldUseAdminFallback(error)) rethrow;
      return _mockAdminReportsData();
    }
  }

  Future<AdminDashboardData> loadDashboardByDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await SupabaseService.client.functions.invoke(
        'admin-dashboard',
        body: {
          'action': 'overview_by_range',
          'from': from.toIso8601String(),
          'to': to.toIso8601String(),
        },
      );
      final data = response.data;
      if (data is! Map) throw Exception('Respuesta inválida.');
      if (data['error'] is String) throw Exception(data['error']);
      return AdminDashboardData.fromMap(Map<String, dynamic>.from(data));
    } catch (error) {
      if (!_shouldUseAdminFallback(error)) rethrow;
      return _mockAdminDashboardData();
    }
  }
}

class PaginatedResult<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory PaginatedResult.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    final list = map['items'] ?? map['data'] ?? [];
    final items = list is List
        ? list
            .whereType<Map>()
            .map((m) => fromItem(Map<String, dynamic>.from(m)))
            .toList()
        : <T>[];
    return PaginatedResult(
      items: items,
      total: _toInt(map['total']),
      page: _toInt(map['page']),
      pageSize: _toInt(map['page_size']),
      hasMore: map['has_more'] == true,
    );
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
              .map((item) =>
                  AdminProvider.fromMap(Map<String, dynamic>.from(item)))
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
  final int totalUsers;
  final int totalProviders;
  final int pendingProviders;
  final int activeProviders;
  final int totalBookings;
  final int pendingBookings;
  final int activeServices;
  final int completedBookings;
  final int cancelledBookings;
  final double revenueTotal;
  final double avgRating;
  final int newUsersThisMonth;
  final int newProvidersThisMonth;

  const AdminStats({
    required this.totalUsers,
    required this.totalProviders,
    required this.pendingProviders,
    required this.activeProviders,
    required this.totalBookings,
    required this.pendingBookings,
    required this.activeServices,
    this.completedBookings = 0,
    this.cancelledBookings = 0,
    this.revenueTotal = 0.0,
    this.avgRating = 0.0,
    this.newUsersThisMonth = 0,
    this.newProvidersThisMonth = 0,
  });

  factory AdminStats.fromMap(Map<String, dynamic> map) {
    return AdminStats(
      totalUsers: _toInt(map['total_users']),
      totalProviders: _toInt(map['total_providers']),
      pendingProviders: _toInt(map['pending_providers']),
      activeProviders: _toInt(map['active_providers']),
      totalBookings: _toInt(map['total_bookings']),
      pendingBookings: _toInt(map['pending_bookings']),
      activeServices: _toInt(map['active_services']),
      completedBookings: _toInt(map['completed_bookings']),
      cancelledBookings: _toInt(map['cancelled_bookings']),
      revenueTotal: _toDouble(map['revenue_total']),
      avgRating: _toDouble(map['avg_rating']),
      newUsersThisMonth: _toInt(map['new_users_this_month']),
      newProvidersThisMonth: _toInt(map['new_providers_this_month']),
    );
  }
}

class AdminProvider {
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
  final List<String> services;

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
    this.services = const [],
  });

  bool get isPending => status == 'pending';
  bool get isSuspended => status == 'suspended' || !isActive;
  bool get isApproved => status == 'approved' && isActive;

  factory AdminProvider.fromMap(Map<String, dynamic> map) {
    final servicesRaw = map['services'];
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
      services: servicesRaw is List
          ? servicesRaw.map((s) => s.toString()).toList()
          : [],
    );
  }
}

class AdminBookingSummary {
  final String id;
  final String status;
  final String serviceName;
  final String clientName;
  final String providerName;
  final double totalPrice;
  final DateTime? scheduledDate;
  final DateTime? createdAt;

  const AdminBookingSummary({
    required this.id,
    required this.status,
    required this.serviceName,
    required this.clientName,
    required this.providerName,
    required this.totalPrice,
    this.scheduledDate,
    this.createdAt,
  });

  factory AdminBookingSummary.fromMap(Map<String, dynamic> map) {
    return AdminBookingSummary(
      id: (map['id'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      serviceName: (map['service_name'] ?? 'Servicio').toString(),
      clientName: (map['client_name'] ?? 'Cliente').toString(),
      providerName: (map['provider_name'] ?? 'Proveedor').toString(),
      totalPrice: _toDouble(map['total_amount']),
      scheduledDate:
          DateTime.tryParse((map['scheduled_date'] ?? '').toString()),
      createdAt: DateTime.tryParse((map['created_at'] ?? '').toString()),
    );
  }
}

class AdminServiceSummary {
  final String id;
  final String name;
  final String category;
  final bool isActive;
  final int providerCount;
  final int bookingCount;
  final double basePrice;
  final DateTime? createdAt;

  const AdminServiceSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.isActive,
    this.providerCount = 0,
    this.bookingCount = 0,
    this.basePrice = 0.0,
    this.createdAt,
  });

  factory AdminServiceSummary.fromMap(Map<String, dynamic> map) {
    return AdminServiceSummary(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      category: (map['category_name'] ?? map['category'] ?? '').toString(),
      isActive: map['is_active'] != false,
      providerCount: _toInt(map['provider_count']),
      bookingCount: _toInt(map['booking_count']),
      basePrice: _toDouble(map['base_price']),
      createdAt: DateTime.tryParse((map['created_at'] ?? '').toString()),
    );
  }
}

class AdminReportsData {
  final List<AdminReportMetric> overview;
  final List<AdminDailyActivity> dailyActivity;
  final List<AdminBookingStatusReport> bookingStatus;

  const AdminReportsData({
    required this.overview,
    required this.dailyActivity,
    required this.bookingStatus,
  });

  factory AdminReportsData.fromMap(Map<String, dynamic> map) {
    final overviewRaw = map['overview'];
    final dailyRaw = map['daily_activity'];
    final bookingRaw = map['booking_status'];
    return AdminReportsData(
      overview: overviewRaw is List
          ? overviewRaw
              .whereType<Map>()
              .map((item) =>
                  AdminReportMetric.fromMap(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      dailyActivity: dailyRaw is List
          ? dailyRaw
              .whereType<Map>()
              .map((item) =>
                  AdminDailyActivity.fromMap(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      bookingStatus: bookingRaw is List
          ? bookingRaw
              .whereType<Map>()
              .map((item) => AdminBookingStatusReport.fromMap(
                  Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }
}

class AdminReportMetric {
  final int sortOrder;
  final String metric;
  final double value;

  const AdminReportMetric({
    required this.sortOrder,
    required this.metric,
    required this.value,
  });

  factory AdminReportMetric.fromMap(Map<String, dynamic> map) {
    return AdminReportMetric(
      sortOrder: _toInt(map['sort_order']),
      metric: (map['metric'] ?? '').toString(),
      value: _toDouble(map['value']),
    );
  }
}

class AdminDailyActivity {
  final DateTime? day;
  final int newUsers;
  final int newProviders;
  final int bookingsCreated;
  final int bookingsCompleted;
  final double bookingAmount;
  final double paymentsAmount;
  final int messagesSent;

  const AdminDailyActivity({
    required this.day,
    required this.newUsers,
    required this.newProviders,
    required this.bookingsCreated,
    required this.bookingsCompleted,
    required this.bookingAmount,
    required this.paymentsAmount,
    required this.messagesSent,
  });

  int get activityTotal =>
      newUsers +
      newProviders +
      bookingsCreated +
      bookingsCompleted +
      messagesSent;

  factory AdminDailyActivity.fromMap(Map<String, dynamic> map) {
    return AdminDailyActivity(
      day: DateTime.tryParse((map['day'] ?? '').toString()),
      newUsers: _toInt(map['new_users']),
      newProviders: _toInt(map['new_providers']),
      bookingsCreated: _toInt(map['bookings_created']),
      bookingsCompleted: _toInt(map['bookings_completed']),
      bookingAmount: _toDouble(map['booking_amount']),
      paymentsAmount: _toDouble(map['payments_amount']),
      messagesSent: _toInt(map['messages_sent']),
    );
  }
}

class AdminBookingStatusReport {
  final String status;
  final int bookings;
  final double totalAmount;

  const AdminBookingStatusReport({
    required this.status,
    required this.bookings,
    required this.totalAmount,
  });

  factory AdminBookingStatusReport.fromMap(Map<String, dynamic> map) {
    return AdminBookingStatusReport(
      status: (map['status'] ?? '').toString(),
      bookings: _toInt(map['bookings']),
      totalAmount: _toDouble(map['total_amount']),
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

bool _shouldUseAdminFallback(Object error) {
  final message = error.toString().toLowerCase();
  if (message.contains('status: 401') ||
      message.contains('statuscode: 401') ||
      message.contains('status: 403') ||
      message.contains('statuscode: 403') ||
      message.contains('acceso denegado') ||
      message.contains('no autorizado')) {
    return false;
  }
  return message.contains('status: 500') ||
      message.contains('internal server error') ||
      message.contains('functionexception') ||
      message.contains('socketexception') ||
      message.contains('failed host lookup') ||
      message.contains('connection') ||
      message.contains('timeout');
}

AdminDashboardData _mockAdminDashboardData() {
  final providers = _mockAdminProviders();
  final bookings = _mockAdminBookings();
  return AdminDashboardData(
    stats: AdminStats(
      totalUsers: 128,
      totalProviders: providers.length,
      pendingProviders: providers.where((p) => p.isPending).length,
      activeProviders: providers.where((p) => p.isApproved).length,
      totalBookings: 86,
      pendingBookings: bookings.where((b) => b.status == 'pending').length,
      activeServices: 24,
      completedBookings: 63,
      cancelledBookings: 5,
      revenueTotal: 4215.75,
      avgRating: 4.8,
      newUsersThisMonth: 37,
      newProvidersThisMonth: 8,
    ),
    providers: providers,
    recentBookings: bookings,
  );
}

List<AdminProvider> _mockAdminProviders() {
  final now = DateTime.now();
  return [
    AdminProvider(
      id: 'mock-provider-1',
      uid: 'mock-user-1',
      name: 'Carlos Mayancha',
      email: 'carlos.mayancha@manachyna.test',
      phone: '+593 99 421 1101',
      city: 'Tena',
      status: 'pending',
      isActive: false,
      rating: 4.8,
      reviewsCount: 24,
      createdAt: now.subtract(const Duration(days: 1)),
      services: const ['Carpinteria', 'Muebles a medida', 'Reparaciones'],
    ),
    AdminProvider(
      id: 'mock-provider-2',
      uid: 'mock-user-2',
      name: 'Maria Shiguango',
      email: 'maria.shiguango@manachyna.test',
      phone: '+593 98 225 2202',
      city: 'Archidona',
      status: 'approved',
      isActive: true,
      rating: 4.9,
      reviewsCount: 41,
      createdAt: now.subtract(const Duration(days: 8)),
      services: const ['Limpieza', 'Hogar', 'Desinfeccion'],
    ),
    AdminProvider(
      id: 'mock-provider-3',
      uid: 'mock-user-3',
      name: 'Jose Andy Vargas',
      email: 'jose.vargas@manachyna.test',
      phone: '+593 97 640 3303',
      city: 'Tena',
      status: 'suspended',
      isActive: false,
      rating: 4.1,
      reviewsCount: 9,
      createdAt: now.subtract(const Duration(days: 15)),
      services: const ['Electricidad', 'Instalaciones'],
    ),
    AdminProvider(
      id: 'mock-provider-4',
      uid: 'mock-user-4',
      name: 'Nelly Cerda',
      email: 'nelly.cerda@manachyna.test',
      phone: '+593 96 118 4404',
      city: 'Puerto Napo',
      status: 'pending',
      isActive: false,
      rating: 4.6,
      reviewsCount: 18,
      createdAt: now.subtract(const Duration(days: 2)),
      services: const ['Cocina tradicional', 'Eventos'],
    ),
    AdminProvider(
      id: 'mock-provider-5',
      uid: 'mock-user-5',
      name: 'Luis Grefa',
      email: 'luis.grefa@manachyna.test',
      phone: '+593 95 730 5505',
      city: 'Misahualli',
      status: 'approved',
      isActive: true,
      rating: 4.7,
      reviewsCount: 33,
      createdAt: now.subtract(const Duration(days: 26)),
      services: const ['Plomeria', 'Mantenimiento'],
    ),
    AdminProvider(
      id: 'mock-provider-6',
      uid: 'mock-user-6',
      name: 'Karla Tapuy',
      email: 'karla.tapuy@manachyna.test',
      phone: '+593 94 225 6606',
      city: 'Ahuano',
      status: 'approved',
      isActive: true,
      rating: 4.9,
      reviewsCount: 57,
      createdAt: now.subtract(const Duration(days: 31)),
      services: const ['Jardineria', 'Limpieza exterior'],
    ),
  ];
}

List<AdminProvider> _filterMockProviders(
  List<AdminProvider> providers, {
  String? search,
  String? statusFilter,
}) {
  final query = search?.trim().toLowerCase() ?? '';
  return providers.where((provider) {
    final matchesStatus = statusFilter == null ||
        statusFilter == 'all' ||
        provider.status == statusFilter ||
        (statusFilter == 'active' && provider.isActive);
    final matchesSearch = query.isEmpty ||
        provider.name.toLowerCase().contains(query) ||
        provider.email.toLowerCase().contains(query) ||
        provider.phone.toLowerCase().contains(query);
    return matchesStatus && matchesSearch;
  }).toList();
}

List<AdminBookingSummary> _mockAdminBookings() {
  final now = DateTime.now();
  return [
    AdminBookingSummary(
      id: 'mock-booking-1',
      status: 'pending',
      serviceName: 'Carpinteria - reparacion de puerta',
      clientName: 'Ana Paredes',
      providerName: 'Carlos Mayancha',
      totalPrice: 45.50,
      scheduledDate: now.add(const Duration(days: 1)),
      createdAt: now.subtract(const Duration(hours: 3)),
    ),
    AdminBookingSummary(
      id: 'mock-booking-2',
      status: 'completed',
      serviceName: 'Limpieza profunda',
      clientName: 'Byron Alvarado',
      providerName: 'Maria Shiguango',
      totalPrice: 32.5,
      scheduledDate: now.subtract(const Duration(days: 2)),
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    AdminBookingSummary(
      id: 'mock-booking-3',
      status: 'confirmed',
      serviceName: 'Plomeria - fuga en lavamanos',
      clientName: 'Jenny Cerda',
      providerName: 'Luis Grefa',
      totalPrice: 28,
      scheduledDate: now.add(const Duration(hours: 6)),
      createdAt: now.subtract(const Duration(hours: 9)),
    ),
    AdminBookingSummary(
      id: 'mock-booking-4',
      status: 'in_progress',
      serviceName: 'Jardineria exterior',
      clientName: 'Marco Tapuy',
      providerName: 'Karla Tapuy',
      totalPrice: 38,
      scheduledDate: now,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    AdminBookingSummary(
      id: 'mock-booking-5',
      status: 'cancelled',
      serviceName: 'Instalacion electrica',
      clientName: 'Paola Vargas',
      providerName: 'Jose Andy Vargas',
      totalPrice: 65,
      scheduledDate: now.subtract(const Duration(days: 1)),
      createdAt: now.subtract(const Duration(days: 3)),
    ),
  ];
}

List<AdminServiceSummary> _mockAdminServices() {
  final now = DateTime.now();
  return [
    AdminServiceSummary(
      id: 'mock-service-1',
      name: 'Carpinteria',
      category: 'Hogar',
      isActive: true,
      providerCount: 7,
      bookingCount: 18,
      basePrice: 25,
      createdAt: now.subtract(const Duration(days: 20)),
    ),
    AdminServiceSummary(
      id: 'mock-service-2',
      name: 'Electricidad',
      category: 'Tecnicos',
      isActive: true,
      providerCount: 5,
      bookingCount: 14,
      basePrice: 30,
      createdAt: now.subtract(const Duration(days: 18)),
    ),
    AdminServiceSummary(
      id: 'mock-service-3',
      name: 'Plomeria',
      category: 'Tecnicos',
      isActive: true,
      providerCount: 6,
      bookingCount: 16,
      basePrice: 22,
      createdAt: now.subtract(const Duration(days: 16)),
    ),
    AdminServiceSummary(
      id: 'mock-service-4',
      name: 'Limpieza profunda',
      category: 'Hogar',
      isActive: true,
      providerCount: 9,
      bookingCount: 27,
      basePrice: 18,
      createdAt: now.subtract(const Duration(days: 14)),
    ),
    AdminServiceSummary(
      id: 'mock-service-5',
      name: 'Cocina tradicional',
      category: 'Eventos',
      isActive: true,
      providerCount: 4,
      bookingCount: 11,
      basePrice: 35,
      createdAt: now.subtract(const Duration(days: 10)),
    ),
  ];
}

AdminReportsData _mockAdminReportsData() {
  final today = DateTime.now();
  return AdminReportsData(
    overview: const [
      AdminReportMetric(sortOrder: 1, metric: 'Usuarios activos', value: 128),
      AdminReportMetric(
          sortOrder: 2, metric: 'Proveedores verificados', value: 18),
      AdminReportMetric(sortOrder: 3, metric: 'Reservas creadas', value: 86),
      AdminReportMetric(
          sortOrder: 4, metric: 'Ingresos confirmados', value: 4215.75),
      AdminReportMetric(
          sortOrder: 5, metric: 'Calificacion promedio', value: 4.8),
      AdminReportMetric(sortOrder: 6, metric: 'Mensajes enviados', value: 392),
    ],
    dailyActivity: List.generate(10, (index) {
      final day = today.subtract(Duration(days: 9 - index));
      return AdminDailyActivity(
        day: day,
        newUsers: 3 + index,
        newProviders: index.isEven ? 2 : 1,
        bookingsCreated: 5 + index,
        bookingsCompleted: 3 + index,
        bookingAmount: 140 + (index * 22),
        paymentsAmount: 110 + (index * 19),
        messagesSent: 18 + (index * 4),
      );
    }),
    bookingStatus: const [
      AdminBookingStatusReport(
        status: 'completed',
        bookings: 63,
        totalAmount: 3080,
      ),
      AdminBookingStatusReport(
        status: 'pending',
        bookings: 14,
        totalAmount: 620,
      ),
      AdminBookingStatusReport(
        status: 'confirmed',
        bookings: 9,
        totalAmount: 390,
      ),
      AdminBookingStatusReport(
        status: 'cancelled',
        bookings: 5,
        totalAmount: 125,
      ),
    ],
  );
}
