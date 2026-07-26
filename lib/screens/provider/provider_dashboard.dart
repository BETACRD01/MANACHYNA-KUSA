import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/service_provider.dart';

import 'shared/ui/provider_shared_widgets.dart';
import 'overview/ui/overview_screen.dart';
import 'bookings/ui/bookings_screen.dart';
import 'services/ui/services_screen.dart';
import 'work_feed/ui/work_feed_screen.dart';
import 'profile/ui/profile_screen.dart';

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
      backgroundColor: providerShellBg,
      body: !hasProviderAccess
          ? const ProviderAccessDenied()
          : RefreshIndicator(
              onRefresh: _loadPanelData,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ProviderOverviewTab(
                    user: user!,
                    onOpenBookings: () => _openTab(1),
                    onOpenServices: () => _openTab(2),
                    onOpenTasks: () => _openTab(3),
                    onRefresh: _loadPanelData,
                  ),
                  ProviderBookingsTab(
                    statusFilter: _bookingStatusFilter,
                    onStatusFilterChanged: (value) {
                      setState(() => _bookingStatusFilter = value);
                    },
                    onRefresh: _loadPanelData,
                  ),
                  ProviderServicesTab(
                    statusFilter: _serviceStatusFilter,
                    onStatusFilterChanged: (value) {
                      setState(() => _serviceStatusFilter = value);
                    },
                    onRefresh: _loadPanelData,
                  ),
                  ProviderWorkFeedTab(
                    categoryFilter: _taskCategoryFilter,
                    onCategoryChanged: (value) {
                      setState(() => _taskCategoryFilter = value);
                    },
                  ),
                  ProviderProfileTab(user: user),
                ],
              ),
            ),
      bottomNavigationBar: hasProviderAccess
          ? ProviderBottomNav(
              currentIndex: _currentIndex,
              onTap: _openTab,
            )
          : null,
    );
  }
}
