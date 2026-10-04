import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../models/booking/booking_model.dart';

import '../../shared/ui/provider_shared_widgets.dart';
class ProviderStatsGrid extends StatelessWidget {
  final List<ProviderStatData> items;
  const ProviderStatsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 650 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (context, index) =>
              ProviderStatCard(data: items[index]),
        );
      },
    );
  }
}

class ProviderStatData {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const ProviderStatData({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class ProviderStatCard extends StatelessWidget {
  final ProviderStatData data;
  const ProviderStatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(data.icon, color: data.color, size: 25),
          ),
          const SizedBox(height: 12),
          Text(
            data.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: providerMutedText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: providerPurple,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: data.subtitle.startsWith('↗')
                  ? AppColors.success
                  : providerPurple,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderQuickActions extends StatelessWidget {
  final VoidCallback onOpenBookings;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenTasks;
  final Future<void> Function() onRefresh;

  const ProviderQuickActions({super.key, 
    required this.onOpenBookings,
    required this.onOpenServices,
    required this.onOpenTasks,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones rápidas',
            style: TextStyle(
              color: providerDeep,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ProviderActionCard(
                  icon: Icons.add_rounded,
                  label: 'Nuevo servicio',
                  color: providerPurple,
                  onTap: onOpenServices,
                ),
              ),
              Expanded(
                child: ProviderActionCard(
                  icon: Icons.list_alt_rounded,
                  label: 'Ver solicitudes',
                  color: const Color(0xFF7A4CE4),
                  onTap: onOpenBookings,
                ),
              ),
              Expanded(
                child: ProviderActionCard(
                  icon: Icons.calendar_month_rounded,
                  label: 'Disponibilidad',
                  color: AppColors.info,
                  onTap: onOpenTasks,
                ),
              ),
              Expanded(
                child: ProviderActionCard(
                  icon: Icons.local_offer_outlined,
                  label: 'Promociones',
                  color: const Color(0xFFE346A8),
                  onTap: onRefresh,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProviderActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ProviderActionCard({super.key, 
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.72)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 27),
              ),
              const SizedBox(height: 9),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: providerDeep,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderRecentRequestsPanel extends StatelessWidget {
  final List<BookingModel> bookings;
  final VoidCallback onOpenBookings;

  const ProviderRecentRequestsPanel({super.key, 
    required this.bookings,
    required this.onOpenBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: providerPanelDecoration(context),
      child: Column(
        children: [
          for (var index = 0; index < bookings.length; index++) ...[
            ProviderRecentRequestRow(
              booking: bookings[index],
              onTap: onOpenBookings,
            ),
            if (index != bookings.length - 1)
              const Divider(height: 1, color: Color(0xFFEAE6F1)),
          ],
        ],
      ),
    );
  }
}

class ProviderRecentRequestRow extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const ProviderRecentRequestRow({super.key, 
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = providerBookingStatusColor(booking.status);
    final serviceColor = _overviewServiceColor(booking.serviceName);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: serviceColor.withValues(alpha: 0.13),
              child: Text(
                _initials(booking.clientName),
                style: TextStyle(
                  color: serviceColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 26,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.clientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: providerDeep,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_relativeDay(booking.scheduledDate)}, ${booking.scheduledTime}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: providerMutedText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: serviceColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _overviewServiceIcon(booking.serviceName),
                color: serviceColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 34,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: providerDeep,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    booking.address ?? 'Servicio a domicilio',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: providerMutedText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 74,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    providerFormatMoney(booking.totalPrice),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: providerDeep,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  ProviderStatusPill(
                    label: _shortBookingStatus(booking.status),
                    color: statusColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderWeeklySummary extends StatelessWidget {
  final double revenue;
  final int completed;

  const ProviderWeeklySummary({super.key, 
    required this.revenue,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    const values = [500.0, 700.0, 800.0, 1200.0, 620.0, 740.0, 420.0];
    const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Resumen semanal',
                  style: TextStyle(
                    color: providerDeep,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F5FC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8E2F3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Esta semana',
                        style: TextStyle(color: providerMutedText)),
                    SizedBox(width: 6),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: providerMutedText, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              final chart = ProviderWeeklyChart(
                values: values,
                labels: labels,
                compact: compact,
              );
              final metrics = Column(
                children: [
                  ProviderSummaryMiniCard(
                    icon: Icons.payments_outlined,
                    title: 'Ingresos',
                    value: providerFormatMoney(revenue),
                    trend: '↗ 18% vs semana pasada',
                  ),
                  const SizedBox(height: 10),
                  ProviderSummaryMiniCard(
                    icon: Icons.business_center_outlined,
                    title: 'Trabajos completados',
                    value: '$completed',
                    trend: '↗ 25% vs semana pasada',
                  ),
                ],
              );

              if (compact) {
                return Column(
                  children: [
                    chart,
                    const SizedBox(height: 12),
                    metrics,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 3, child: chart),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: metrics),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProviderWeeklyChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final bool compact;

  const ProviderWeeklyChart({super.key, 
    required this.values,
    required this.labels,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 150 : 174,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 32,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1.2k',
                    style: TextStyle(color: providerMutedText, fontSize: 11)),
                Text('900',
                    style: TextStyle(color: providerMutedText, fontSize: 11)),
                Text('600',
                    style: TextStyle(color: providerMutedText, fontSize: 11)),
                Text('300',
                    style: TextStyle(color: providerMutedText, fontSize: 11)),
                Text('0',
                    style: TextStyle(color: providerMutedText, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (_) => Container(
                      height: 1,
                      color: const Color(0xFFE3DFEA),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(values.length, (index) {
                    final isLast = index == values.length - 1;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 3 : 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height:
                                  (compact ? 88 : 110) * (values[index] / 1200),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    providerPurple.withValues(
                                        alpha: isLast ? 0.24 : 0.92),
                                    providerPurple.withValues(
                                        alpha: isLast ? 0.16 : 0.55),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              labels[index],
                              style: const TextStyle(
                                color: providerMutedText,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderSummaryMiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String trend;

  const ProviderSummaryMiniCard({super.key, 
    required this.icon,
    required this.title,
    required this.value,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: providerPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: providerPurple, size: 23),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: providerMutedText)),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: providerDeep,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  trend,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _initials(String name) {
  final parts =
      name.split(' ').where((part) => part.trim().isNotEmpty).take(2).toList();
  if (parts.isEmpty) return 'U';
  return parts.map((part) => part[0].toUpperCase()).join();
}

String _relativeDay(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final diff = target.difference(today).inDays;
  if (diff == 0) return 'Hoy';
  if (diff == -1) return 'Ayer';
  if (diff == 1) return 'Mañana';
  return Helpers.formatDate(date);
}

String _shortBookingStatus(BookingStatus status) {
  switch (status) {
    case BookingStatus.pending:
      return 'Pendiente';
    case BookingStatus.confirmed:
      return 'Confirmada';
    case BookingStatus.inProgress:
      return 'En curso';
    case BookingStatus.completed:
      return 'Completada';
    case BookingStatus.cancelled:
      return 'Cancelada';
  }
}

IconData _overviewServiceIcon(String serviceName) {
  final value = serviceName.toLowerCase();
  if (value.contains('eléctr') || value.contains('luminaria')) {
    return Icons.bolt_rounded;
  }
  if (value.contains('fuga') ||
      value.contains('tuber') ||
      value.contains('plom')) {
    return Icons.water_drop_outlined;
  }
  if (value.contains('mueble') ||
      value.contains('closet') ||
      value.contains('carp')) {
    return Icons.chair_outlined;
  }
  if (value.contains('pint')) return Icons.format_paint_outlined;
  return Icons.home_repair_service_outlined;
}

Color _overviewServiceColor(String serviceName) {
  final value = serviceName.toLowerCase();
  if (value.contains('eléctr') || value.contains('luminaria')) {
    return AppColors.warning;
  }
  if (value.contains('fuga') ||
      value.contains('tuber') ||
      value.contains('plom')) {
    return AppColors.info;
  }
  if (value.contains('mueble') ||
      value.contains('closet') ||
      value.contains('carp')) {
    return providerPurple;
  }
  if (value.contains('pint')) return const Color(0xFFE346A8);
  return providerPurple;
}
