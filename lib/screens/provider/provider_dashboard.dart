import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/utils/helpers.dart';
import '../../core/widgets/loading_widget.dart';
import '../../models/booking_model.dart';
import '../../models/custom_task_model.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/custom_task_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/service_provider.dart';

part 'tabs/provider_bookings_tab.dart';
part 'tabs/provider_overview_tab.dart';
part 'tabs/provider_profile_tab.dart';
part 'tabs/provider_services_tab.dart';
part 'tabs/provider_work_feed_tab.dart';
part 'widgets/provider_booking_widgets.dart';
part 'widgets/provider_common_widgets.dart';
part 'widgets/provider_overview_widgets.dart';
part 'widgets/provider_service_widgets.dart';
part 'widgets/provider_task_widgets.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({Key? key}) : super(key: key);

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _bookingStatusFilter = 'all';
  String _serviceStatusFilter = 'all';
  String _taskCategoryFilter = 'Todas';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPanelData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPanelData() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    await Future.wait([
      context
          .read<BookingProvider>()
          .loadUserBookings(user.id, isProvider: true),
      context.read<ServiceProvider>().loadServicesByProvider(user.id),
    ]);
  }

  void _openTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final hasProviderAccess = user?.hasProviderAccess == true;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text('Panel de Proveedor'),
        centerTitle: false,
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notifProvider, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    tooltip: 'Notificaciones',
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                  ),
                  if (notifProvider.unreadCount > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadPanelData,
          ),
        ],
        bottom: hasProviderAccess
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
                    text: 'Resumen',
                  ),
                  Tab(
                    icon: Icon(Icons.calendar_month_rounded, size: 20),
                    text: 'Reservas',
                  ),
                  Tab(
                    icon: Icon(Icons.home_repair_service_rounded, size: 20),
                    text: 'Servicios',
                  ),
                  Tab(
                    icon: Icon(Icons.work_outline_rounded, size: 20),
                    text: 'Trabajos',
                  ),
                  Tab(
                    icon: Icon(Icons.badge_outlined, size: 20),
                    text: 'Perfil',
                  ),
                ],
              )
            : null,
      ),
      body: !hasProviderAccess
          ? const _ProviderAccessDenied()
          : RefreshIndicator(
              onRefresh: _loadPanelData,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ProviderOverviewTab(
                    user: user!,
                    onOpenBookings: () => _openTab(1),
                    onOpenServices: () => _openTab(2),
                    onOpenTasks: () => _openTab(3),
                    onRefresh: _loadPanelData,
                  ),
                  _ProviderBookingsTab(
                    statusFilter: _bookingStatusFilter,
                    onStatusFilterChanged: (value) {
                      setState(() => _bookingStatusFilter = value);
                    },
                    onRefresh: _loadPanelData,
                  ),
                  _ProviderServicesTab(
                    statusFilter: _serviceStatusFilter,
                    onStatusFilterChanged: (value) {
                      setState(() => _serviceStatusFilter = value);
                    },
                    onRefresh: _loadPanelData,
                  ),
                  _ProviderWorkFeedTab(
                    categoryFilter: _taskCategoryFilter,
                    onCategoryChanged: (value) {
                      setState(() => _taskCategoryFilter = value);
                    },
                  ),
                  _ProviderProfileTab(user: user),
                ],
              ),
            ),
    );
  }
}
