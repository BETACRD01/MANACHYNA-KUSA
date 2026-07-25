part of '../provider_dashboard.dart';

class _ProviderOverviewTab extends StatelessWidget {
  final UserModel user;
  final VoidCallback onOpenBookings;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenTasks;
  final Future<void> Function() onRefresh;

  const _ProviderOverviewTab({
    required this.user,
    required this.onOpenBookings,
    required this.onOpenServices,
    required this.onOpenTasks,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<BookingProvider, ServiceProvider>(
      builder: (context, bookingProvider, serviceProvider, _) {
        final bookings = bookingProvider.bookings;
        final services = serviceProvider.services;
        final pending =
            bookings.where((b) => b.status == BookingStatus.pending).length;
        final confirmed =
            bookings.where((b) => b.status == BookingStatus.confirmed).length;
        final completed =
            bookings.where((b) => b.status == BookingStatus.completed).length;
        final revenue = bookings
            .where((b) => b.status == BookingStatus.completed)
            .fold<double>(0, (sum, booking) => sum + booking.totalPrice);
        final activeServices = services.where((s) => s.isActive).length;
        final recentBookings = bookings.take(5).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _ProviderHeroCard(user: user),
            const SizedBox(height: 18),
            _ProviderStatsGrid(
              items: [
                _ProviderStatData(
                  label: 'Reservas',
                  value: '${bookings.length}',
                  subtitle: '$pending pendientes',
                  icon: Icons.event_note_rounded,
                  color: AppColors.info,
                ),
                _ProviderStatData(
                  label: 'Confirmadas',
                  value: '$confirmed',
                  subtitle: 'por atender',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.primary,
                ),
                _ProviderStatData(
                  label: 'Servicios',
                  value: '$activeServices',
                  subtitle: '${services.length} total',
                  icon: Icons.home_repair_service_rounded,
                  color: AppColors.success,
                ),
                _ProviderStatData(
                  label: 'Ingresos',
                  value: _money(revenue),
                  subtitle: '$completed completadas',
                  icon: Icons.payments_outlined,
                  color: const Color(0xFF00897B),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _ProviderQuickActions(
              onOpenBookings: onOpenBookings,
              onOpenServices: onOpenServices,
              onOpenTasks: onOpenTasks,
              onRefresh: onRefresh,
            ),
            const SizedBox(height: 22),
            _ProviderSectionHeader(
              title: 'Reservas recientes',
              subtitle: 'Últimos movimientos del proveedor',
              actionText: 'Ver todas',
              onAction: onOpenBookings,
            ),
            const SizedBox(height: 12),
            if (bookingProvider.isLoading)
              const LoadingWidget(message: 'Cargando reservas...')
            else if (recentBookings.isEmpty)
              const _ProviderEmptyState(
                icon: Icons.calendar_today_outlined,
                text: 'No hay reservas recientes.',
              )
            else
              ...recentBookings.map(
                (booking) => _ProviderBookingCard(
                  booking: booking,
                  compact: true,
                ),
              ),
          ],
        );
      },
    );
  }
}
