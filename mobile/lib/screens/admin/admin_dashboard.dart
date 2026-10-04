import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../features/admin/data/admin_repository.dart';
import '../../providers/auth_provider.dart';

import 'shared/admin_colors.dart';
import 'shared/ui/admin_shared_widgets.dart';

import 'overview/ui/overview_screen.dart';
import 'users/ui/users_screen.dart';
import 'providers/ui/providers_screen.dart';
import 'providers/controllers/providers_controller.dart';
import 'reports/ui/reports_screen.dart';
import 'profile/ui/profile_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final AdminRepository _repository = AdminRepository();
  late TabController _tabController;
  int _currentIndex = 0;

  Future<AdminDashboardData>? _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_currentIndex != _tabController.index) {
        setState(() => _currentIndex = _tabController.index);
      }
    });
    _dashboardFuture = _repository.loadDashboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      backgroundColor: adminShellBg,
      body: isAdmin
          ? FutureBuilder<AdminDashboardData>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Cargando panel...');
                }
                if (snapshot.hasError) {
                  return AdminErrorView(
                    message: _extractMessage(snapshot.error),
                    onRetry: _reload,
                  );
                }
                final data = snapshot.data;
                if (data == null) {
                  return AdminErrorView(
                    message: 'No se recibieron datos del panel.',
                    onRetry: _reload,
                  );
                }
                return TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    OverviewTab(
                      data: data,
                      onRefresh: _reload,
                      onReloadSilent: _reloadSilent,
                      onOpenProviders: () => _tabController.animateTo(2),
                      onOpenReports: () => _tabController.animateTo(4),
                    ),
                    AdminUsersTab(stats: data.stats),
                    ChangeNotifierProvider(
                      create: (_) => ProvidersController(repository: _repository),
                      child: const ProvidersScreen(),
                    ),
                    ReportsTab(repository: _repository),
                    AdminProfileTab(user: user!, stats: data.stats),
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
      bottomNavigationBar: isAdmin
          ? AdminBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) => _tabController.animateTo(index),
            )
          : null,
    );
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
