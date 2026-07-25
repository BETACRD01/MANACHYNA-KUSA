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
        final bookings = bookingProvider.bookings.isEmpty
            ? _mockProviderBookings()
            : bookingProvider.bookings;
        final services = serviceProvider.services.isEmpty
            ? _mockProviderServices(user)
            : serviceProvider.services;
        final pending =
            bookings.where((b) => b.status == BookingStatus.pending).length;
        final completed =
            bookings.where((b) => b.status == BookingStatus.completed).length;
        final revenue = bookings
            .where((b) => b.status == BookingStatus.completed)
            .fold<double>(0, (sum, booking) => sum + booking.totalPrice);
        final activeServices = services.where((s) => s.isActive).length;
        final recentBookings = bookings.take(5).toList();

        return _ProviderPage(
          title:
              'Hola, ${user.name.isNotEmpty ? user.name : 'Servicios El Sol'} ☀',
          subtitle: 'Gestiona tu negocio y revisa tu actividad',
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _ProviderStatsGrid(
                  items: [
                    _ProviderStatData(
                      label: 'Solicitudes hoy',
                      value: '$pending',
                      subtitle: '↗ 33% vs ayer',
                      icon: Icons.description_outlined,
                      color: _providerPurple,
                    ),
                    _ProviderStatData(
                      label: 'Ingresos del mes',
                      value: _money(revenue > 0 ? revenue : 2850),
                      subtitle: '↗ 18% vs mes pasado',
                      icon: Icons.payments_outlined,
                      color: AppColors.success,
                    ),
                    _ProviderStatData(
                      label: 'Servicios activos',
                      value: '$activeServices',
                      subtitle: 'Ver y gestionar',
                      icon: Icons.business_center_outlined,
                      color: AppColors.info,
                    ),
                    _ProviderStatData(
                      label: 'Calificación',
                      value: user.rating > 0
                          ? user.rating.toStringAsFixed(1)
                          : '4.8',
                      subtitle: '⭐ 128 reseñas',
                      icon: Icons.star_border_rounded,
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _ProviderQuickActions(
                  onOpenBookings: onOpenBookings,
                  onOpenServices: onOpenServices,
                  onOpenTasks: onOpenTasks,
                  onRefresh: onRefresh,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _ProviderSectionHeader(
                  title: 'Solicitudes recientes',
                  subtitle: '',
                  actionText: 'Ver todas',
                  onAction: onOpenBookings,
                ),
              ),
            ),
            if (bookingProvider.isLoading)
              const SliverToBoxAdapter(
                child: LoadingWidget(message: 'Cargando reservas...'),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ProviderBookingCard(
                      booking: recentBookings[index],
                      compact: true,
                    ),
                    childCount: recentBookings.length,
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _ProviderWeeklySummary(
                  revenue: revenue > 0 ? revenue : 2850,
                  completed: completed > 0 ? completed : 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
