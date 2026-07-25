part of '../provider_dashboard.dart';

class _ProviderBookingsTab extends StatelessWidget {
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final Future<void> Function() onRefresh;

  const _ProviderBookingsTab({
    required this.statusFilter,
    required this.onStatusFilterChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final filtered = _filterBookings(bookingProvider.bookings);

        return Column(
          children: [
            _ProviderFilterBar(
              values: const {
                'all': 'Todas',
                'pending': 'Pendientes',
                'confirmed': 'Confirmadas',
                'in_progress': 'En curso',
                'completed': 'Completadas',
                'cancelled': 'Canceladas',
              },
              selected: statusFilter,
              onChanged: onStatusFilterChanged,
            ),
            Expanded(
              child: bookingProvider.isLoading
                  ? const LoadingWidget(message: 'Cargando reservas...')
                  : bookingProvider.errorMessage != null
                      ? _ProviderErrorState(
                          message: bookingProvider.errorMessage!,
                          onRetry: onRefresh,
                        )
                      : filtered.isEmpty
                          ? const _ProviderEmptyState(
                              icon: Icons.calendar_month_outlined,
                              text: 'No hay reservas con ese estado.',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return _ProviderBookingCard(
                                  booking: filtered[index],
                                  onStatusChanged: (status) => _updateStatus(
                                      context, filtered[index], status),
                                );
                              },
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
