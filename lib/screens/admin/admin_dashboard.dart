import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../features/admin/data/admin_repository.dart';
import '../../providers/auth_provider.dart';

part 'tabs/overview_tab.dart';
part 'tabs/providers_tab.dart';
part 'tabs/bookings_tab.dart';
part 'tabs/services_tab.dart';
part 'tabs/reports_tab.dart';
part 'widgets/overview_widgets.dart';
part 'widgets/admin_shared_widgets.dart';

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
