import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../features/admin/data/admin_repository.dart';
import '../../shared/ui/admin_shared_widgets.dart';

class ReportsTab extends StatefulWidget {
  final AdminRepository repository;
  const ReportsTab({super.key, required this.repository});

  @override
  State<ReportsTab> createState() => ReportsTabState();
}

class ReportsTabState extends State<ReportsTab> {
  late Future<AdminReportsData> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.loadReports();
  }

  Future<void> _load() async {
    setState(() => _future = widget.repository.loadReports());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminReportsData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget(message: 'Cargando reportes...');
        }
        if (snapshot.hasError) {
          return AdminErrorView(
            message: extractReportError(snapshot.error),
            onRetry: _load,
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return AdminErrorView(
            message: 'No se recibieron reportes.',
            onRetry: _load,
          );
        }

        return RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              ReportsHeader(updatedAt: DateTime.now()),
              const SizedBox(height: 18),
              ReportMetricsGrid(metrics: data.overview),
              const SizedBox(height: 24),
              const AdminSectionHeader(
                title: 'Actividad de 30 días',
                subtitle: 'Usuarios, reservas, pagos y mensajes',
              ),
              const SizedBox(height: 12),
              DailyActivityPanel(items: data.dailyActivity),
              const SizedBox(height: 24),
              const AdminSectionHeader(
                title: 'Reservas por estado',
                subtitle: 'Distribución operativa',
              ),
              const SizedBox(height: 12),
              BookingStatusPanel(items: data.bookingStatus),
            ],
          ),
        );
      },
    );
  }

  String extractReportError(dynamic error) {
    if (error is Exception) {
      final s = error.toString();
      return s.startsWith('Exception: ') ? s.substring(11) : s;
    }
    return error?.toString() ?? 'Error desconocido';
  }
}

class ReportsHeader extends StatelessWidget {
  final DateTime updatedAt;
  const ReportsHeader({super.key, required this.updatedAt});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm', 'es_ES').format(updatedAt);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.insights_rounded,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Centro de reportes',
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Actualizado hoy a las $time',
                  style:
                      TextStyle(color: context.appTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified_user_outlined, color: AppColors.success),
        ],
      ),
    );
  }
}

class ReportMetricsGrid extends StatelessWidget {
  final List<AdminReportMetric> metrics;
  const ReportMetricsGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const AdminEmptyPanel(text: 'No hay métricas disponibles.');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 720 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.75,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return ReportMetricCard(
                metric: metric, color: reportColor(index));
          },
        );
      },
    );
  }

  Color reportColor(int index) {
    const colors = [
      AppColors.primary,
      Color(0xFF5C6BC0),
      Color(0xFF26A69A),
      AppColors.warning,
      AppColors.success,
      AppColors.info,
    ];
    return colors[index % colors.length];
  }
}

class ReportMetricCard extends StatelessWidget {
  final AdminReportMetric metric;
  final Color color;
  const ReportMetricCard({super.key, required this.metric, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: [
          BoxShadow(
              color: context.appShadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(metricIcon(metric.metric), color: color, size: 19),
          ),
          const Spacer(),
          Text(
            formatMetricValue(metric),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            metric.metric,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.appTextSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  IconData metricIcon(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('usuario')) return Icons.people_outline_rounded;
    if (lower.contains('proveedor')) return Icons.engineering_outlined;
    if (lower.contains('servicio')) {
      return Icons.miscellaneous_services_outlined;
    }
    if (lower.contains('reserva')) return Icons.event_note_rounded;
    if (lower.contains('ingreso') || lower.contains('pago')) {
      return Icons.payments_outlined;
    }
    if (lower.contains('calificacion')) return Icons.star_rounded;
    if (lower.contains('mensaje')) return Icons.chat_bubble_outline_rounded;
    return Icons.analytics_outlined;
  }
}

class DailyActivityPanel extends StatelessWidget {
  final List<AdminDailyActivity> items;
  const DailyActivityPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final lastItems =
        items.length > 10 ? items.sublist(items.length - 10) : items;
    final maxActivity = lastItems.fold<int>(
      1,
      (max, item) => item.activityTotal > max ? item.activityTotal : max,
    );
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: r'$');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
      ),
      child: lastItems.isEmpty
          ? const AdminEmptyPanel(text: 'No hay actividad reciente.')
          : Column(
              children: lastItems.map((item) {
                final ratio = item.activityTotal / maxActivity;
                final label = item.day == null
                    ? 'Sin fecha'
                    : DateFormat('dd MMM', 'es_ES').format(item.day!);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 54,
                            child: Text(label,
                                style: TextStyle(
                                  color: context.appTextSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: ratio.clamp(0.04, 1.0),
                                minHeight: 8,
                                backgroundColor: context.appMutedSurface,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 34,
                            child: Text(
                              '${item.activityTotal}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: context.appTextPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const SizedBox(width: 54),
                          Expanded(
                            child: Text(
                              '${item.newUsers} usuarios, ${item.bookingsCreated} reservas, ${currency.format(item.paymentsAmount)} pagos',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: context.appTextSecondary,
                                  fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class BookingStatusPanel extends StatelessWidget {
  final List<AdminBookingStatusReport> items;
  const BookingStatusPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final totalBookings =
        items.fold<int>(0, (sum, item) => sum + item.bookings);
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: r'$');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
      ),
      child: items.isEmpty
          ? const AdminEmptyPanel(text: 'No hay reservas para graficar.')
          : Column(
              children: items.map((item) {
                final percent =
                    totalBookings == 0 ? 0.0 : item.bookings / totalBookings;
                final color = statusColor(item.status);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              statusLabel(item.status),
                              style: TextStyle(
                                color: context.appTextPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '${item.bookings} - ${currency.format(item.totalAmount)}',
                            style: TextStyle(
                                color: context.appTextSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: percent.clamp(0.02, 1.0),
                          minHeight: 7,
                          backgroundColor: context.appMutedSurface,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'in_progress':
        return AppColors.secondary;
      case 'confirmed':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pendientes';
      case 'requested':
        return 'Solicitadas';
      case 'confirmed':
        return 'Confirmadas';
      case 'in_progress':
        return 'En curso';
      case 'completed':
        return 'Completadas';
      case 'cancelled':
        return 'Canceladas';
      default:
        return status.isEmpty ? 'Sin estado' : status;
    }
  }
}

String formatMetricValue(AdminReportMetric metric) {
  final lower = metric.metric.toLowerCase();
  if (lower.contains('ingreso') || lower.contains('pago')) {
    return NumberFormat.currency(locale: 'es_EC', symbol: r'$')
        .format(metric.value);
  }
  if (lower.contains('calificacion')) {
    return metric.value.toStringAsFixed(2);
  }
  if (metric.value % 1 == 0) {
    return NumberFormat.decimalPattern('es_EC').format(metric.value.toInt());
  }
  return NumberFormat.decimalPattern('es_EC').format(metric.value);
}
