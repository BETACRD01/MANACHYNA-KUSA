import 'package:flutter/material.dart';
import '../../../../features/admin/data/admin_repository.dart'; // For AdminDashboardData
import '../../shared/ui/admin_shared_widgets.dart';
import '../../shared/ui/overview_widgets.dart';

class OverviewTab extends StatelessWidget {
  final AdminDashboardData data;
  final Future<void> Function() onRefresh;
  final VoidCallback onReloadSilent;
  final VoidCallback onOpenProviders;
  final VoidCallback onOpenReports;

  const OverviewTab({super.key, 
    required this.data,
    required this.onRefresh,
    required this.onReloadSilent,
    required this.onOpenProviders,
    required this.onOpenReports,
  });

  @override
  Widget build(BuildContext context) {
    final stats = data.stats;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AdminPageHeader(
            title: 'Hola, Admin 👋',
            subtitle: 'Gestiona la plataforma y supervisa la actividad',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: AdminStatsGrid(stats: stats),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: AdminQuickActions(
              onApprove: onOpenProviders,
              onCategories: onReloadSilent,
              onReports: onOpenReports,
              onAlerts: onReloadSilent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: AdminSectionTitle(
              title: 'Pendientes de revisión',
              action: 'Ver todas',
              onAction: onOpenProviders,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: AdminPendingReviewPanel(
              providers: data.providers.isEmpty
                  ? mockAdminProviders()
                  : data.providers.take(5).toList(),
              onOpenProviders: onOpenProviders,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            child: AdminOverviewWeeklySummary(stats: stats),
          ),
        ],
      ),
    );
  }
}
