part of '../provider_dashboard.dart';

class _ProviderSegmentedTabs extends StatelessWidget {
  final Map<String, int> values;
  final String selected;
  final ValueChanged<String> onChanged;

  const _ProviderSegmentedTabs({
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(3),
      decoration: _providerPanelDecoration(context),
      child: Row(
        children: values.entries.map((entry) {
          final active = selected == entry.key;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onChanged(entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: active ? _providerPurple : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        color: active ? _providerPurple : _providerMutedText,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _providerPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${entry.value}',
                        style: const TextStyle(
                          color: _providerPurple,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProviderJobsSummary extends StatelessWidget {
  final int newJobs;
  final int activeJobs;
  final int completed;

  const _ProviderJobsSummary({
    required this.newJobs,
    required this.activeJobs,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _JobSummaryCard(
            icon: Icons.description_outlined,
            label: 'Nuevos',
            value: '$newJobs',
            subtitle: 'Sin asignar',
            color: _providerPurple,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _JobSummaryCard(
            icon: Icons.sync_rounded,
            label: 'En curso',
            value: '$activeJobs',
            subtitle: 'Trabajos activos',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _JobSummaryCard(
            icon: Icons.check_circle_outline_rounded,
            label: 'Finalizados',
            value: '$completed',
            subtitle: 'Este mes',
            color: AppColors.info,
          ),
        ),
      ],
    );
  }
}

class _JobSummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _JobSummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SoftIcon(icon: icon, color: color),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: _providerMutedText)),
          Text(
            value,
            style: const TextStyle(
              color: _providerPurple,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _providerMutedText, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ProviderJobCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onComplete;

  const _ProviderJobCard({
    required this.booking,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _bookingStatusColor(booking.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: _providerPanelDecoration(context),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child:
                    Icon(_jobIcon(booking.serviceName), color: color, size: 35),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _providerDeep,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _JobLine(
                        icon: Icons.person_outline, text: booking.clientName),
                    _JobLine(
                        icon: Icons.location_on_outlined,
                        text: booking.address ?? 'Dirección pendiente'),
                    _JobLine(
                      icon: Icons.calendar_today_outlined,
                      text:
                          '${Helpers.formatDate(booking.scheduledDate)}, ${booking.scheduledTime}',
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
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProviderStatusPill(
                    label: Helpers.getBookingStatusName(booking.status),
                    color: color,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Ver detalle'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _providerPurple,
                    side: const BorderSide(color: _providerPurple),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: booking.status == BookingStatus.completed
                      ? null
                      : onComplete,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Marcar listo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _providerPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _jobIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('eléctr')) return Icons.lightbulb_outline_rounded;
    if (lower.contains('fuga') || lower.contains('tuber')) {
      return Icons.plumbing;
    }
    if (lower.contains('pint')) return Icons.format_paint_rounded;
    return Icons.chair_alt_rounded;
  }
}

class _JobLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _JobLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, color: _providerMutedText, size: 15),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _providerMutedText, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
