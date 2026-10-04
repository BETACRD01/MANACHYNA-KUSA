import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../models/booking/booking_model.dart';

import '../../shared/ui/provider_shared_widgets.dart';
import '../../services/ui/service_widgets.dart';
class ProviderSegmentedTabs extends StatelessWidget {
  final Map<String, int> values;
  final String selected;
  final ValueChanged<String> onChanged;

  const ProviderSegmentedTabs({super.key, 
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(3),
      decoration: providerPanelDecoration(context),
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
                      color: active ? providerPurple : Colors.transparent,
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
                        color: active ? providerPurple : providerMutedText,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: providerPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${entry.value}',
                        style: const TextStyle(
                          color: providerPurple,
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

class ProviderJobsSummary extends StatelessWidget {
  final int newJobs;
  final int activeJobs;
  final int completed;

  const ProviderJobsSummary({super.key, 
    required this.newJobs,
    required this.activeJobs,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: JobSummaryCard(
            icon: Icons.description_outlined,
            label: 'Nuevos',
            value: '$newJobs',
            subtitle: 'Sin asignar',
            color: providerPurple,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: JobSummaryCard(
            icon: Icons.sync_rounded,
            label: 'En curso',
            value: '$activeJobs',
            subtitle: 'Trabajos activos',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: JobSummaryCard(
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

class JobSummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const JobSummaryCard({super.key, 
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
      decoration: providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIcon(icon: icon, color: color),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: providerMutedText)),
          Text(
            value,
            style: const TextStyle(
              color: providerPurple,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: providerMutedText, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ProviderJobCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onComplete;

  const ProviderJobCard({super.key, 
    required this.booking,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final color = providerBookingStatusColor(booking.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: providerPanelDecoration(context),
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
                        color: providerDeep,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    JobLine(
                        icon: Icons.person_outline, text: booking.clientName),
                    JobLine(
                        icon: Icons.location_on_outlined,
                        text: booking.address ?? 'Dirección pendiente'),
                    JobLine(
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
                    providerFormatMoney(booking.totalPrice),
                    style: const TextStyle(
                      color: providerDeep,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProviderStatusPill(
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
                    foregroundColor: providerPurple,
                    side: const BorderSide(color: providerPurple),
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
                    backgroundColor: providerPurple,
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

class JobLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const JobLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, color: providerMutedText, size: 15),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: providerMutedText, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
