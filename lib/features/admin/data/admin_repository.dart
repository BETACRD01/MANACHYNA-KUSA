import '../../../core/services/supabase_service.dart';

class AdminRepository {
  Future<AdminDashboardData> loadDashboard() async {
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
  }

  Future<AdminDashboardData> refreshDashboard() => loadDashboard();

  Future<PaginatedResult<AdminProvider>> loadProviders({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? statusFilter,
  }) async {
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
  }

  Future<PaginatedResult<AdminBookingSummary>> loadBookings({
    int page = 1,
    int pageSize = 20,
    String? statusFilter,
  }) async {
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
  }

  Future<AdminReportsData> loadReports() async {
    final response = await SupabaseService.client.functions.invoke(
      'admin-dashboard',
      body: {'action': 'reports'},
    );
    final data = response.data;
    if (data is! Map) throw Exception('Respuesta inválida.');
    if (data['error'] is String) throw Exception(data['error']);
    return AdminReportsData.fromMap(Map<String, dynamic>.from(data));
  }

  Future<AdminDashboardData> loadDashboardByDateRange({
    required DateTime from,
    required DateTime to,
  }) async {
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
