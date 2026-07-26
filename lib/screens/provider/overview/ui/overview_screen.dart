import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../models/booking/booking_model.dart';
import '../../../../models/user/user_model.dart';
import '../../../../providers/booking_provider.dart';
import '../../../../providers/service_provider.dart';

import '../../shared/ui/provider_shared_widgets.dart';
import 'overview_widgets.dart';
class ProviderOverviewTab extends StatelessWidget {
  final UserModel user;
  final VoidCallback onOpenBookings;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenTasks;
  final Future<void> Function() onRefresh;

  const ProviderOverviewTab({super.key, 
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
            ? mockProviderBookings()
            : bookingProvider.bookings;
        final services = serviceProvider.services.isEmpty
            ? mockProviderServices(user)
            : serviceProvider.services;
        final usingMockBookings = bookingProvider.bookings.isEmpty;
        final usingMockServices = serviceProvider.services.isEmpty;
        final pending =
            bookings.where((b) => b.status == BookingStatus.pending).length;
        final completed =
            bookings.where((b) => b.status == BookingStatus.completed).length;
        final revenue = bookings
            .where((b) => b.status == BookingStatus.completed)
            .fold<double>(0, (sum, booking) => sum + booking.totalPrice);
        final activeServices = services.where((s) => s.isActive).length;
        final recentBookings = bookings.take(4).toList();

        return ProviderPage(
          title:
              'Hola, ${user.name.isNotEmpty ? user.name : 'Servicios El Sol'} ☀',
          subtitle: 'Gestiona tu negocio y revisa tu actividad',
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: ProviderStatsGrid(
                  items: [
                    ProviderStatData(
                      label: 'Solicitudes hoy',
                      value: '${usingMockBookings ? 8 : pending}',
                      subtitle: '↗ 33% vs ayer',
                      icon: Icons.description_outlined,
                      color: providerPurple,
                    ),
                    ProviderStatData(
                      label: 'Ingresos del mes',
                      value: providerFormatMoney(revenue > 0 ? revenue : 2850),
                      subtitle: '↗ 18% vs mes pasado',
                      icon: Icons.payments_outlined,
                      color: AppColors.success,
                    ),
                    ProviderStatData(
                      label: 'Servicios activos',
                      value: '${usingMockServices ? 12 : activeServices}',
                      subtitle: 'Ver y gestionar',
                      icon: Icons.business_center_outlined,
                      color: AppColors.info,
                    ),
                    ProviderStatData(
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
                child: ProviderQuickActions(
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
                child: ProviderSectionHeader(
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
                sliver: SliverToBoxAdapter(
                  child: ProviderRecentRequestsPanel(
                    bookings: recentBookings,
                    onOpenBookings: onOpenBookings,
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: ProviderWeeklySummary(
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
