import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../models/booking/booking_model.dart';
import '../../../../providers/booking_provider.dart';

import '../../shared/ui/provider_shared_widgets.dart';
import 'booking_widgets.dart';
class ProviderBookingsTab extends StatelessWidget {
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final Future<void> Function() onRefresh;

  const ProviderBookingsTab({super.key, 
    required this.statusFilter,
    required this.onStatusFilterChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final source = bookingProvider.bookings.isEmpty
            ? mockProviderBookings()
            : bookingProvider.bookings;
        final filtered = _filterBookings(source);
        final pending =
            source.where((b) => b.status == BookingStatus.pending).length;
        final accepted =
            source.where((b) => b.status == BookingStatus.confirmed).length;

        return ProviderPage(
          title: 'Solicitudes',
          subtitle: 'Revisa y responde las solicitudes de clientes',
          slivers: [
            SliverToBoxAdapter(
              child: ProviderFilterBar(
                values: const {
                  'all': 'Todas',
                  'pending': 'Pendientes',
                  'confirmed': 'Aceptadas',
                  'completed': 'Completadas',
                },
                selected: statusFilter,
                onChanged: onStatusFilterChanged,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              sliver: SliverToBoxAdapter(
                child: ProviderRequestSummary(
                  today: source.length,
                  pending: pending,
                  accepted: accepted,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: ProviderSectionHeader(
                  title: 'Solicitudes pendientes',
                  subtitle: '',
                  actionText: 'Ver todas',
                  onAction: onRefresh,
                ),
              ),
            ),
            if (bookingProvider.isLoading)
              const SliverToBoxAdapter(
                child: LoadingWidget(message: 'Cargando reservas...'),
              )
            else if (bookingProvider.errorMessage != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ProviderErrorState(
                  message: bookingProvider.errorMessage!,
                  onRetry: onRefresh,
                ),
              )
            else if (filtered.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: ProviderEmptyState(
                  icon: Icons.calendar_month_outlined,
                  text: 'No hay reservas con ese estado.',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProviderBookingCard(
                      booking: filtered[index],
                      onStatusChanged: (status) =>
                          _updateStatus(context, filtered[index], status),
                    ),
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<BookingModel> _filterBookings(List<BookingModel> bookings) {
    if (statusFilter == 'all') return bookings;
    return bookings.where((booking) {
      return bookingStatusToSupabase(booking.status) == statusFilter;
    }).toList();
  }

  Future<void> _updateStatus(
    BuildContext context,
    BookingModel booking,
    BookingStatus status,
  ) async {
    final bookingProvider = context.read<BookingProvider>();
    if (status == BookingStatus.cancelled) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Rechazar reserva'),
          content: const Text('¿Quieres rechazar esta reserva?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Rechazar',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    final ok = await bookingProvider.updateBookingStatus(booking.id, status);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Reserva actualizada correctamente'
            : 'No se pudo actualizar la reserva'),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ),
    );
  }
}
