part of '../admin_dashboard.dart';

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
