import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../features/admin/data/admin_repository.dart';
import '../../providers/auth_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final AdminRepository _repository = AdminRepository();
  late TabController _tabController;

  Future<AdminDashboardData>? _dashboardFuture;
  String? _busyProviderId;
  final TextEditingController _providerSearchCtrl = TextEditingController();
  String _providerStatusFilter = 'all';
  String _bookingStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _dashboardFuture = _repository.loadDashboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _providerSearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() => _dashboardFuture = _repository.loadDashboard());
    await _dashboardFuture;
  }

  void _reloadSilent() {
    setState(() => _dashboardFuture = _repository.refreshDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final isAdmin = user?.hasAdminAccess == true;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _reload,
          ),
        ],
        bottom: isAdmin
            ? TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                tabs: const [
                  Tab(
                      icon: Icon(Icons.dashboard_rounded, size: 20),
                      text: 'Resumen'),
                  Tab(
                      icon: Icon(Icons.engineering_outlined, size: 20),
                      text: 'Proveedores'),
                  Tab(
                      icon: Icon(Icons.calendar_month_rounded, size: 20),
                      text: 'Reservas'),
                  Tab(
                      icon:
                          Icon(Icons.miscellaneous_services_outlined, size: 20),
                      text: 'Servicios'),
                  Tab(
                      icon: Icon(Icons.analytics_rounded, size: 20),
                      text: 'Reportes'),
                ],
              )
            : null,
      ),
      body: isAdmin
          ? FutureBuilder<AdminDashboardData>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Cargando panel...');
                }
                if (snapshot.hasError) {
                  return _AdminErrorView(
                    message: _extractMessage(snapshot.error),
                    onRetry: _reload,
                  );
                }
                final data = snapshot.data;
                if (data == null) {
                  return _AdminErrorView(
                    message: 'No se recibieron datos del panel.',
                    onRetry: _reload,
                  );
                }
                return TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _OverviewTab(
                      data: data,
                      onRefresh: _reload,
                      onReloadSilent: _reloadSilent,
                      onOpenReports: () => _tabController.animateTo(4),
                    ),
                    _ProvidersTab(
                      repository: _repository,
                      busyProviderId: _busyProviderId,
                      searchCtrl: _providerSearchCtrl,
                      statusFilter: _providerStatusFilter,
                      onStatusFilterChanged: (v) {
                        setState(() => _providerStatusFilter = v);
                      },
                      onAction: (id) => setState(() => _busyProviderId = id),
                      onActionDone: () {
                        setState(() => _busyProviderId = null);
                        _reloadSilent();
                      },
                      onError: (msg) => _showSnack(msg),
                    ),
                    _BookingsTab(
                      repository: _repository,
                      statusFilter: _bookingStatusFilter,
                      onStatusFilterChanged: (v) {
                        setState(() => _bookingStatusFilter = v);
                      },
                    ),
                    _ServicesTab(
                        repository: _repository, onRefresh: _reloadSilent),
                    _ReportsTab(repository: _repository),
                  ],
                );
              },
            )
          : const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text('Acceso denegado',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('Solo para administradores.'),
                ],
              ),
            ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _extractMessage(dynamic error) {
    if (error == null) return 'Error desconocido';
    if (error is Exception) {
      final s = error.toString();
      return s.startsWith('Exception: ') ? s.substring(11) : s;
    }
    return error.toString();
  }
}

class _OverviewTab extends StatelessWidget {
  final AdminDashboardData data;
  final Future<void> Function() onRefresh;
  final VoidCallback onReloadSilent;
  final VoidCallback onOpenReports;

  const _OverviewTab({
    required this.data,
    required this.onRefresh,
    required this.onReloadSilent,
    required this.onOpenReports,
  });

  @override
  Widget build(BuildContext context) {
    final stats = data.stats;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const _AdminHeader(name: 'Admin'),
          const SizedBox(height: 20),
          _StatsGrid(stats: stats),
          const SizedBox(height: 24),
          _QuickActions(
              onReloadSilent: onReloadSilent, onOpenReports: onOpenReports),
          const SizedBox(height: 24),
          _SectionHeader(
              title: 'Proveedores',
              subtitle: '${stats.pendingProviders} pendientes'),
          const SizedBox(height: 12),
          if (data.providers.isEmpty)
            const _EmptyPanel(text: 'No hay proveedores registrados.')
          else
            ...data.providers
                .take(5)
                .map((p) => _ProviderMiniCard(provider: p)),
          const SizedBox(height: 24),
          const _SectionHeader(
              title: 'Reservas recientes', subtitle: 'Últimas operaciones'),
          const SizedBox(height: 12),
          if (data.recentBookings.isEmpty)
            const _EmptyPanel(text: 'No hay reservas recientes.')
          else
            ...data.recentBookings.map((b) => _BookingMiniCard(booking: b)),
        ],
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  final String name;
  const _AdminHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panel de Administración',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Bienvenido, $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fiber_manual_record_rounded,
                    size: 10, color: Colors.greenAccent),
                SizedBox(width: 6),
                Text('En vivo',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AdminStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: r'$');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen general',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            )),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 600 ? 4 : 2;
            final items = [
              _StatCardData(
                  'Usuarios',
                  stats.totalUsers,
                  Icons.people_outline_rounded,
                  const Color(0xFF5C6BC0),
                  '${stats.newUsersThisMonth} nuevos'),
              _StatCardData(
                  'Proveedores',
                  stats.totalProviders,
                  Icons.engineering_outlined,
                  AppColors.primary,
                  '${stats.activeProviders} activos'),
              _StatCardData('Pendientes', stats.pendingProviders,
                  Icons.pending_actions_rounded, AppColors.warning, 'revisar'),
              _StatCardData(
                  'Reservas',
                  stats.totalBookings,
                  Icons.event_note_rounded,
                  const Color(0xFF26A69A),
                  '${stats.pendingBookings} pend.'),
              _StatCardData(
                  'Servicios',
                  stats.activeServices,
                  Icons.miscellaneous_services_outlined,
                  AppColors.success,
                  'activos'),
              _StatCardData('Completadas', stats.completedBookings,
                  Icons.check_circle_outline_rounded, AppColors.success, ''),
              _StatCardData('Canceladas', stats.cancelledBookings,
                  Icons.cancel_outlined, AppColors.error, ''),
              _StatCardData('Ingresos', currency.format(stats.revenueTotal),
                  Icons.payments_outlined, const Color(0xFF00897B), 'pagado'),
              _StatCardData('Valoración', stats.avgRating.toStringAsFixed(1),
                  Icons.star_rounded, const Color(0xFFFFA726), 'promedio'),
            ];
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.7,
              ),
              itemBuilder: (context, index) => _StatCard(item: items[index]),
            );
          },
        ),
      ],
    );
  }
}

class _StatCardData {
  final String label;
  final dynamic value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCardData(
      this.label, this.value, this.icon, this.color, this.subtitle);
}

class _StatCard extends StatelessWidget {
  final _StatCardData item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              const Spacer(),
              if (item.subtitle.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(item.subtitle,
                      style: TextStyle(
                          fontSize: 9,
                          color: item.color,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const Spacer(),
          Text(
            '${item.value}',
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
                color: context.appTextSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onReloadSilent;
  final VoidCallback onOpenReports;
  const _QuickActions(
      {required this.onReloadSilent, required this.onOpenReports});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acciones rápidas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            )),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _ActionCard(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Nuevo\nProveedor',
              color: AppColors.primary,
              onTap: () => _showSoon(context,
                  'Gestiona proveedores desde la pestaña Proveedores.'),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _ActionCard(
              icon: Icons.add_circle_outline_rounded,
              label: 'Nuevo\nServicio',
              color: AppColors.secondary,
              onTap: () => _showSoon(
                  context, 'Gestiona servicios desde la pestaña Servicios.'),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _ActionCard(
              icon: Icons.analytics_rounded,
              label: 'Reporte\nCompleto',
              color: AppColors.warning,
              onTap: onOpenReports,
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _ActionCard(
              icon: Icons.sync_rounded,
              label: 'Sincronizar\nDatos',
              color: const Color(0xFF5C6BC0),
              onTap: onReloadSilent,
            )),
          ],
        ),
      ],
    );
  }

  void _showSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.appTextPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 2),
              Text(subtitle,
                  style:
                      TextStyle(color: context.appTextSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderMiniCard extends StatelessWidget {
  final AdminProvider provider;
  const _ProviderMiniCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final statusColor = provider.isPending
        ? AppColors.warning
        : provider.isSuspended
            ? AppColors.error
            : AppColors.success;
    final statusLabel = provider.isPending
        ? 'Pendiente'
        : provider.isSuspended
            ? 'Pausado'
            : 'Activo';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: context.appSoftGreen,
            child: Text(
              provider.name.isNotEmpty ? provider.name[0].toUpperCase() : 'P',
              style: TextStyle(
                  color: context.appPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                    provider.email.isNotEmpty ? provider.email : provider.phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(statusLabel,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _BookingMiniCard extends StatelessWidget {
  final AdminBookingSummary booking;
  const _BookingMiniCard({required this.booking});

  Color _statusColor() {
    switch (booking.status) {
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'in_progress':
        return AppColors.secondary;
      case 'confirmed':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  String _statusLabel() {
    switch (booking.status) {
      case 'pending':
        return 'Pendiente';
      case 'confirmed':
        return 'Confirmada';
      case 'in_progress':
        return 'En curso';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return booking.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _statusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.receipt_long_outlined,
                color: _statusColor(), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextPrimary,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('${booking.clientName} → ${booking.providerName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${booking.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: context.appTextPrimary,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_statusLabel(),
                    style: TextStyle(
                        color: _statusColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProvidersTab extends StatefulWidget {
  final AdminRepository repository;
  final String? busyProviderId;
  final TextEditingController searchCtrl;
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final ValueChanged<String?> onAction;
  final VoidCallback onActionDone;
  final ValueChanged<String> onError;

  const _ProvidersTab({
    required this.repository,
    required this.busyProviderId,
    required this.searchCtrl,
    required this.statusFilter,
    required this.onStatusFilterChanged,
    required this.onAction,
    required this.onActionDone,
    required this.onError,
  });

  @override
  State<_ProvidersTab> createState() => _ProvidersTabState();
}

class _ProvidersTabState extends State<_ProvidersTab> {
  List<AdminProvider> _providers = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.repository.loadProviders(
        search: widget.searchCtrl.text,
        statusFilter: widget.statusFilter,
      );
      if (!mounted) return;
      setState(() {
        _providers = result.items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _doAction(AdminProvider provider, String action) async {
    widget.onAction(provider.id);
    try {
      if (action == 'approve') {
        await widget.repository.approveProvider(provider.id);
      } else if (action == 'suspend') {
        await widget.repository.suspendProvider(provider.id);
      } else {
        await widget.repository.reactivateProvider(provider.id);
      }
      widget.onActionDone();
      widget.onError('Proveedor actualizado correctamente');
      await _load();
    } catch (e) {
      widget.onError('Error: $e');
      widget.onAction(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: context.appBackground,
          child: Column(
            children: [
              TextField(
                controller: widget.searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Buscar proveedor...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 22),
                  suffixIcon: widget.searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            widget.searchCtrl.clear();
                            _load();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: context.appMutedSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _load(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['all', 'pending', 'approved', 'suspended']
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _FilterChip(
                              label: f == 'all'
                                  ? 'Todos'
                                  : f == 'pending'
                                      ? 'Pendientes'
                                      : f == 'approved'
                                          ? 'Activos'
                                          : 'Pausados',
                              selected: widget.statusFilter == f,
                              onTap: () => widget.onStatusFilterChanged(f),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingWidget(message: 'Cargando proveedores...')
              : _error != null
                  ? _AdminErrorView(message: _error!, onRetry: _load)
                  : _providers.isEmpty
                      ? _EmptyPanel(
                          text: widget.searchCtrl.text.isNotEmpty
                              ? 'Sin resultados para "${widget.searchCtrl.text}"'
                              : 'No hay proveedores registrados.')
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            itemCount: _providers.length,
                            itemBuilder: (context, index) {
                              final p = _providers[index];
                              return _ProviderFullCard(
                                provider: p,
                                isBusy: widget.busyProviderId == p.id,
                                onApprove: () => _doAction(p, 'approve'),
                                onSuspend: () => _doAction(p, 'suspend'),
                                onReactivate: () => _doAction(p, 'reactivate'),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : context.appMutedSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
              color: selected ? Colors.white : context.appTextSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            )),
      ),
    );
  }
}

class _ProviderFullCard extends StatelessWidget {
  final AdminProvider provider;
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onSuspend;
  final VoidCallback onReactivate;

  const _ProviderFullCard({
    required this.provider,
    required this.isBusy,
    required this.onApprove,
    required this.onSuspend,
    required this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = provider.isPending
        ? AppColors.warning
        : provider.isSuspended
            ? AppColors.error
            : AppColors.success;
    final statusLabel = provider.isPending
        ? 'Pendiente'
        : provider.isSuspended
            ? 'Pausado'
            : 'Activo';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: [
          BoxShadow(
              color: context.appShadow,
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: context.appSoftGreen,
                child: Text(
                  provider.name.isNotEmpty
                      ? provider.name[0].toUpperCase()
                      : 'P',
                  style: TextStyle(
                      color: context.appPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: context.appTextPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                        provider.email.isNotEmpty
                            ? provider.email
                            : provider.phone,
                        style: TextStyle(
                            color: context.appTextSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(statusLabel,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                  icon: Icons.place_outlined,
                  text:
                      provider.city.isNotEmpty ? provider.city : 'Sin ciudad'),
              _InfoChip(
                  icon: Icons.star_rounded,
                  text: provider.rating.toStringAsFixed(1)),
              _InfoChip(
                  icon: Icons.rate_review_outlined,
                  text: '${provider.reviewsCount} reseñas'),
              if (provider.createdAt != null)
                _InfoChip(
                    icon: Icons.calendar_today_outlined,
                    text: _formatDate(provider.createdAt!)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (provider.isPending || provider.isSuspended)
                Expanded(
                  child: _AdminActionButton(
                    label: provider.isPending ? 'Aprobar' : 'Reactivar',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    isBusy: isBusy,
                    onPressed: provider.isPending ? onApprove : onReactivate,
                  ),
                ),
              if (provider.isPending || provider.isSuspended)
                const SizedBox(width: 10),
              if (!provider.isSuspended)
                Expanded(
                  child: _AdminActionButton(
                    label: provider.isPending ? 'Rechazar' : 'Pausar',
                    icon: Icons.pause_circle_outline_rounded,
                    color: AppColors.warning,
                    isBusy: isBusy,
                    onPressed: onSuspend,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.appTextSecondary),
          const SizedBox(width: 5),
          Text(text,
              style: TextStyle(color: context.appTextSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AdminActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isBusy;
  final VoidCallback onPressed;
  const _AdminActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isBusy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isBusy ? null : onPressed,
      icon: isBusy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

class _BookingsTab extends StatefulWidget {
  final AdminRepository repository;
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  const _BookingsTab(
      {required this.repository,
      required this.statusFilter,
      required this.onStatusFilterChanged});

  @override
  State<_BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<_BookingsTab> {
  List<AdminBookingSummary> _bookings = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.repository
          .loadBookings(statusFilter: widget.statusFilter);
      if (!mounted) return;
      setState(() {
        _bookings = result.items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: context.appBackground,
          child: SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                {'key': 'all', 'label': 'Todas'},
                {'key': 'pending', 'label': 'Pendientes'},
                {'key': 'confirmed', 'label': 'Confirmadas'},
                {'key': 'in_progress', 'label': 'En curso'},
                {'key': 'completed', 'label': 'Completadas'},
                {'key': 'cancelled', 'label': 'Canceladas'},
              ]
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: f['label']!,
                          selected: widget.statusFilter == f['key'],
                          onTap: () => widget.onStatusFilterChanged(f['key']!),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingWidget(message: 'Cargando reservas...')
              : _error != null
                  ? _AdminErrorView(message: _error!, onRetry: _load)
                  : _bookings.isEmpty
                      ? _EmptyPanel(
                          text:
                              'No hay reservas ${widget.statusFilter == 'all' ? '' : 'con ese estado'}.')
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            itemCount: _bookings.length,
                            itemBuilder: (context, index) {
                              final b = _bookings[index];
                              return _BookingFullCard(booking: b);
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}

class _BookingFullCard extends StatelessWidget {
  final AdminBookingSummary booking;
  const _BookingFullCard({required this.booking});

  Color _statusColor() {
    switch (booking.status) {
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'in_progress':
        return AppColors.secondary;
      case 'confirmed':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  IconData _statusIcon() {
    switch (booking.status) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'in_progress':
        return Icons.play_circle_rounded;
      case 'confirmed':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  String _statusLabel() {
    switch (booking.status) {
      case 'pending':
        return 'Pendiente';
      case 'confirmed':
        return 'Confirmada';
      case 'in_progress':
        return 'En curso';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return booking.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_statusIcon(), color: _statusColor(), size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.serviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: context.appTextPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 13, color: context.appTextSecondary),
                        const SizedBox(width: 4),
                        Text(booking.clientName,
                            style: TextStyle(
                                color: context.appTextSecondary, fontSize: 12)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            size: 12, color: context.appTextSecondary),
                        const SizedBox(width: 8),
                        Icon(Icons.engineering_outlined,
                            size: 13, color: context.appTextSecondary),
                        const SizedBox(width: 4),
                        Text(booking.providerName,
                            style: TextStyle(
                                color: context.appTextSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${booking.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: context.appTextPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 18)),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor().withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_statusLabel(),
                        style: TextStyle(
                            color: _statusColor(),
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
          if (booking.scheduledDate != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: context.appTextSecondary),
                const SizedBox(width: 6),
                Text(
                  '${booking.scheduledDate!.day}/${booking.scheduledDate!.month}/${booking.scheduledDate!.year}',
                  style:
                      TextStyle(color: context.appTextSecondary, fontSize: 12),
                ),
                const Spacer(),
                if (booking.createdAt != null)
                  Text(
                      'Creada: ${booking.createdAt!.day}/${booking.createdAt!.month}/${booking.createdAt!.year}',
                      style: TextStyle(
                          color: context.appTextSecondary, fontSize: 11)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ServicesTab extends StatefulWidget {
  final AdminRepository repository;
  final VoidCallback onRefresh;
  const _ServicesTab({required this.repository, required this.onRefresh});

  @override
  State<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<_ServicesTab> {
  List<AdminServiceSummary> _services = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final services = await widget.repository.loadServices();
      if (!mounted) return;
      setState(() {
        _services = services;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _toggleService(AdminServiceSummary service) async {
    try {
      await widget.repository
          .toggleServiceStatus(service.id, !service.isActive);
      widget.onRefresh();
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const LoadingWidget(message: 'Cargando servicios...')
        : _error != null
            ? _AdminErrorView(message: _error!, onRetry: _load)
            : _services.isEmpty
                ? const _EmptyPanel(text: 'No hay servicios registrados.')
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        final s = _services[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.appElevatedSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.appBorder),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                    Icons.miscellaneous_services_outlined,
                                    color: AppColors.primary,
                                    size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: context.appTextPrimary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15)),
                                    const SizedBox(height: 2),
                                    Text(s.category,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: context.appTextSecondary,
                                            fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        _MiniStat(
                                            text:
                                                '${s.providerCount} proveedores'),
                                        _MiniStat(
                                            text: '${s.bookingCount} reservas'),
                                        if (s.basePrice > 0)
                                          _MiniStat(
                                              text:
                                                  '\$${s.basePrice.toStringAsFixed(0)}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: s.isActive,
                                activeThumbColor: AppColors.primary,
                                onChanged: (_) => _toggleService(s),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
  }
}

class _ReportsTab extends StatefulWidget {
  final AdminRepository repository;
  const _ReportsTab({required this.repository});

  @override
  State<_ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<_ReportsTab> {
  late Future<AdminReportsData> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.loadReports();
  }

  Future<void> _load() async {
    setState(() => _future = widget.repository.loadReports());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminReportsData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget(message: 'Cargando reportes...');
        }
        if (snapshot.hasError) {
          return _AdminErrorView(
            message: _extractReportError(snapshot.error),
            onRetry: _load,
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return _AdminErrorView(
            message: 'No se recibieron reportes.',
            onRetry: _load,
          );
        }

        return RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _ReportsHeader(updatedAt: DateTime.now()),
              const SizedBox(height: 18),
              _ReportMetricsGrid(metrics: data.overview),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Actividad de 30 días',
                subtitle: 'Usuarios, reservas, pagos y mensajes',
              ),
              const SizedBox(height: 12),
              _DailyActivityPanel(items: data.dailyActivity),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Reservas por estado',
                subtitle: 'Distribución operativa',
              ),
              const SizedBox(height: 12),
              _BookingStatusPanel(items: data.bookingStatus),
            ],
          ),
        );
      },
    );
  }

  String _extractReportError(dynamic error) {
    if (error is Exception) {
      final s = error.toString();
      return s.startsWith('Exception: ') ? s.substring(11) : s;
    }
    return error?.toString() ?? 'Error desconocido';
  }
}

class _ReportsHeader extends StatelessWidget {
  final DateTime updatedAt;
  const _ReportsHeader({required this.updatedAt});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm', 'es_ES').format(updatedAt);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.insights_rounded,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Centro de reportes',
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Actualizado hoy a las $time',
                  style:
                      TextStyle(color: context.appTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified_user_outlined, color: AppColors.success),
        ],
      ),
    );
  }
}

class _ReportMetricsGrid extends StatelessWidget {
  final List<AdminReportMetric> metrics;
  const _ReportMetricsGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const _EmptyPanel(text: 'No hay métricas disponibles.');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 720 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.75,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _ReportMetricCard(
                metric: metric, color: _reportColor(index));
          },
        );
      },
    );
  }

  Color _reportColor(int index) {
    const colors = [
      AppColors.primary,
      Color(0xFF5C6BC0),
      Color(0xFF26A69A),
      AppColors.warning,
      AppColors.success,
      AppColors.info,
    ];
    return colors[index % colors.length];
  }
}

class _ReportMetricCard extends StatelessWidget {
  final AdminReportMetric metric;
  final Color color;
  const _ReportMetricCard({required this.metric, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: [
          BoxShadow(
              color: context.appShadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_metricIcon(metric.metric), color: color, size: 19),
          ),
          const Spacer(),
          Text(
            _formatMetricValue(metric),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            metric.metric,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.appTextSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  IconData _metricIcon(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('usuario')) return Icons.people_outline_rounded;
    if (lower.contains('proveedor')) return Icons.engineering_outlined;
    if (lower.contains('servicio')) {
      return Icons.miscellaneous_services_outlined;
    }
    if (lower.contains('reserva')) return Icons.event_note_rounded;
    if (lower.contains('ingreso') || lower.contains('pago')) {
      return Icons.payments_outlined;
    }
    if (lower.contains('calificacion')) return Icons.star_rounded;
    if (lower.contains('mensaje')) return Icons.chat_bubble_outline_rounded;
    return Icons.analytics_outlined;
  }
}

class _DailyActivityPanel extends StatelessWidget {
  final List<AdminDailyActivity> items;
  const _DailyActivityPanel({required this.items});

  @override
  Widget build(BuildContext context) {
    final lastItems =
        items.length > 10 ? items.sublist(items.length - 10) : items;
    final maxActivity = lastItems.fold<int>(
      1,
      (max, item) => item.activityTotal > max ? item.activityTotal : max,
    );
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: r'$');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
      ),
      child: lastItems.isEmpty
          ? const _EmptyPanel(text: 'No hay actividad reciente.')
          : Column(
              children: lastItems.map((item) {
                final ratio = item.activityTotal / maxActivity;
                final label = item.day == null
                    ? 'Sin fecha'
                    : DateFormat('dd MMM', 'es_ES').format(item.day!);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 54,
                            child: Text(label,
                                style: TextStyle(
                                  color: context.appTextSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: ratio.clamp(0.04, 1.0),
                                minHeight: 8,
                                backgroundColor: context.appMutedSurface,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 34,
                            child: Text(
                              '${item.activityTotal}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: context.appTextPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const SizedBox(width: 54),
                          Expanded(
                            child: Text(
                              '${item.newUsers} usuarios, ${item.bookingsCreated} reservas, ${currency.format(item.paymentsAmount)} pagos',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: context.appTextSecondary,
                                  fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _BookingStatusPanel extends StatelessWidget {
  final List<AdminBookingStatusReport> items;
  const _BookingStatusPanel({required this.items});

  @override
  Widget build(BuildContext context) {
    final totalBookings =
        items.fold<int>(0, (sum, item) => sum + item.bookings);
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: r'$');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
      ),
      child: items.isEmpty
          ? const _EmptyPanel(text: 'No hay reservas para graficar.')
          : Column(
              children: items.map((item) {
                final percent =
                    totalBookings == 0 ? 0.0 : item.bookings / totalBookings;
                final color = _statusColor(item.status);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _statusLabel(item.status),
                              style: TextStyle(
                                color: context.appTextPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '${item.bookings} - ${currency.format(item.totalAmount)}',
                            style: TextStyle(
                                color: context.appTextSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: percent.clamp(0.02, 1.0),
                          minHeight: 7,
                          backgroundColor: context.appMutedSurface,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'in_progress':
        return AppColors.secondary;
      case 'confirmed':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pendientes';
      case 'requested':
        return 'Solicitadas';
      case 'confirmed':
        return 'Confirmadas';
      case 'in_progress':
        return 'En curso';
      case 'completed':
        return 'Completadas';
      case 'cancelled':
        return 'Canceladas';
      default:
        return status.isEmpty ? 'Sin estado' : status;
    }
  }
}

String _formatMetricValue(AdminReportMetric metric) {
  final lower = metric.metric.toLowerCase();
  if (lower.contains('ingreso') || lower.contains('pago')) {
    return NumberFormat.currency(locale: 'es_EC', symbol: r'$')
        .format(metric.value);
  }
  if (lower.contains('calificacion')) {
    return metric.value.toStringAsFixed(2);
  }
  if (metric.value % 1 == 0) {
    return NumberFormat.decimalPattern('es_EC').format(metric.value.toInt());
  }
  return NumberFormat.decimalPattern('es_EC').format(metric.value);
}

class _MiniStat extends StatelessWidget {
  final String text;
  const _MiniStat({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(color: context.appTextSecondary, fontSize: 11)),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  final String text;
  const _EmptyPanel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56,
                color: context.appTextSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.appTextSecondary)),
          ],
        ),
      ),
    );
  }
}

class _AdminErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _AdminErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Error al cargar',
                style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: context.appTextSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
