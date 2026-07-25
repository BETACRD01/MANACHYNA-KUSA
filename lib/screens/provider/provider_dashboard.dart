import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/utils/helpers.dart';
import '../../core/widgets/loading_widget.dart';
import '../../models/booking_model.dart';
import '../../models/service_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
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
  int _currentIndex = 0;
  String _bookingStatusFilter = 'all';
  String _serviceStatusFilter = 'all';
  String _taskCategoryFilter = 'Todas';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_currentIndex != _tabController.index) {
        setState(() => _currentIndex = _tabController.index);
      }
    });
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
      backgroundColor: _providerShellBg,
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
      bottomNavigationBar: hasProviderAccess
          ? _ProviderBottomNav(
              currentIndex: _currentIndex,
              onTap: _openTab,
            )
          : null,
    );
  }
}
