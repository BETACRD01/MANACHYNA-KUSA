part of '../provider_dashboard.dart';

class _ProviderBookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool compact;
  final ValueChanged<BookingStatus>? onStatusChanged;

  const _ProviderBookingCard({
    required this.booking,
    this.compact = false,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _bookingStatusColor(booking.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: _providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long_outlined,
                    color: statusColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.appTextPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Cliente: ${booking.clientName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.appTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _ProviderStatusPill(
                label: Helpers.getBookingStatusName(booking.status),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProviderInfoChip(
                icon: Icons.calendar_today_outlined,
                text: Helpers.formatDate(booking.scheduledDate),
              ),
              _ProviderInfoChip(
                icon: Icons.access_time_rounded,
                text: booking.scheduledTime.isEmpty
                    ? 'Sin hora'
                    : booking.scheduledTime,
              ),
              _ProviderInfoChip(
                icon: Icons.payments_outlined,
                text: _money(booking.totalPrice),
              ),
              if (!compact && (booking.address ?? '').isNotEmpty)
                _ProviderInfoChip(
                  icon: Icons.location_on_outlined,
                  text: booking.address!,
                ),
            ],
          ),
          if (!compact && onStatusChanged != null) ...[
            const SizedBox(height: 12),
            _ProviderBookingActions(
              booking: booking,
              onStatusChanged: onStatusChanged!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProviderBookingActions extends StatelessWidget {
  final BookingModel booking;
  final ValueChanged<BookingStatus> onStatusChanged;

  const _ProviderBookingActions({
    required this.booking,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];
    if (booking.status == BookingStatus.pending) {
      actions.addAll([
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => onStatusChanged(BookingStatus.cancelled),
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Rechazar'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onStatusChanged(BookingStatus.confirmed),
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Confirmar'),
          ),
        ),
      ]);
    } else if (booking.status == BookingStatus.confirmed) {
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onStatusChanged(BookingStatus.inProgress),
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Iniciar trabajo'),
          ),
        ),
      );
    } else if (booking.status == BookingStatus.inProgress) {
      actions.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => onStatusChanged(BookingStatus.completed),
            icon: const Icon(Icons.done_all_rounded, size: 18),
            label: const Text('Completar'),
          ),
        ),
      );
    }

    if (actions.isEmpty) return const SizedBox.shrink();
    return Row(children: actions);
  }
}
