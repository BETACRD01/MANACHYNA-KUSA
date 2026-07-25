part of '../provider_dashboard.dart';

class _ProviderRequestSummary extends StatelessWidget {
  final int today;
  final int pending;
  final int accepted;

  const _ProviderRequestSummary({
    required this.today,
    required this.pending,
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _providerPanelDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: _RequestSummaryItem(
              icon: Icons.description_outlined,
              title: 'Hoy',
              value: '$today',
              subtitle: 'solicitudes',
              color: _providerPurple,
            ),
          ),
          _SummaryDivider(),
          Expanded(
            child: _RequestSummaryItem(
              icon: Icons.schedule_rounded,
              title: 'Pendientes',
              value: '$pending',
              subtitle: '',
              color: AppColors.warning,
            ),
          ),
          _SummaryDivider(),
          Expanded(
            child: _RequestSummaryItem(
              icon: Icons.check_circle_outline_rounded,
              title: 'Aceptadas',
              value: '$accepted',
              subtitle: '',
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestSummaryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _RequestSummaryItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      const TextStyle(color: _providerMutedText, fontSize: 12)),
              Text(
                value,
                style: const TextStyle(
                  color: _providerPurple,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(subtitle,
                    style: const TextStyle(
                        color: _providerMutedText, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFFE9E5F0),
    );
  }
}

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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: _providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: compact ? 22 : 31,
                backgroundColor: statusColor.withValues(alpha: 0.1),
                child: Icon(Icons.person_rounded,
                    color: statusColor, size: compact ? 20 : 28),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long_outlined,
                    color: statusColor, size: 20),
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
                        color: _providerDeep,
                        fontSize: compact ? 14 : 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Cliente: ${booking.clientName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _providerMutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _money(booking.totalPrice),
                    style: const TextStyle(
                      color: _providerDeep,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ProviderStatusPill(
                    label: Helpers.getBookingStatusName(booking.status),
                    color: statusColor,
                  ),
                ],
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
