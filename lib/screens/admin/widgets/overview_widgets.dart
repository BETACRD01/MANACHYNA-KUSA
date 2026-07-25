part of '../admin_dashboard.dart';

class _AdminHeader extends StatelessWidget {
  final String name;
  const _AdminHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panel de Administración',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Bienvenido, $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fiber_manual_record_rounded,
                    size: 10, color: Colors.greenAccent),
                SizedBox(width: 6),
                Text('En vivo',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AdminStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'es_EC', symbol: r'$');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen general',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            )),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 600 ? 4 : 2;
            final items = [
              _StatCardData(
                  'Usuarios',
                  stats.totalUsers,
                  Icons.people_outline_rounded,
                  const Color(0xFF5C6BC0),
                  '${stats.newUsersThisMonth} nuevos'),
              _StatCardData(
                  'Proveedores',
                  stats.totalProviders,
                  Icons.engineering_outlined,
                  AppColors.primary,
                  '${stats.activeProviders} activos'),
              _StatCardData('Pendientes', stats.pendingProviders,
                  Icons.pending_actions_rounded, AppColors.warning, 'revisar'),
              _StatCardData(
                  'Reservas',
                  stats.totalBookings,
                  Icons.event_note_rounded,
                  const Color(0xFF26A69A),
                  '${stats.pendingBookings} pend.'),
              _StatCardData(
                  'Servicios',
                  stats.activeServices,
                  Icons.miscellaneous_services_outlined,
                  AppColors.success,
                  'activos'),
              _StatCardData('Completadas', stats.completedBookings,
                  Icons.check_circle_outline_rounded, AppColors.success, ''),
              _StatCardData('Canceladas', stats.cancelledBookings,
                  Icons.cancel_outlined, AppColors.error, ''),
              _StatCardData('Ingresos', currency.format(stats.revenueTotal),
                  Icons.payments_outlined, const Color(0xFF00897B), 'pagado'),
              _StatCardData('Valoración', stats.avgRating.toStringAsFixed(1),
                  Icons.star_rounded, const Color(0xFFFFA726), 'promedio'),
            ];
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.7,
              ),
              itemBuilder: (context, index) => _StatCard(item: items[index]),
            );
          },
        ),
      ],
    );
  }
}

class _StatCardData {
  final String label;
  final dynamic value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCardData(
      this.label, this.value, this.icon, this.color, this.subtitle);
}

class _StatCard extends StatelessWidget {
  final _StatCardData item;
  const _StatCard({required this.item});

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              const Spacer(),
              if (item.subtitle.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(item.subtitle,
                      style: TextStyle(
                          fontSize: 9,
                          color: item.color,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const Spacer(),
          Text(
            '${item.value}',
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
                color: context.appTextSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onReloadSilent;
  final VoidCallback onOpenReports;
  const _QuickActions(
      {required this.onReloadSilent, required this.onOpenReports});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acciones rápidas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            )),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _ActionCard(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Nuevo\nProveedor',
              color: AppColors.primary,
              onTap: () => _showSoon(context,
                  'Gestiona proveedores desde la pestaña Proveedores.'),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _ActionCard(
              icon: Icons.add_circle_outline_rounded,
              label: 'Nuevo\nServicio',
              color: AppColors.secondary,
              onTap: () => _showSoon(
                  context, 'Gestiona servicios desde la pestaña Servicios.'),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _ActionCard(
              icon: Icons.analytics_rounded,
              label: 'Reporte\nCompleto',
              color: AppColors.warning,
              onTap: onOpenReports,
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _ActionCard(
              icon: Icons.sync_rounded,
              label: 'Sincronizar\nDatos',
              color: const Color(0xFF5C6BC0),
              onTap: onReloadSilent,
            )),
          ],
        ),
      ],
    );
  }

  void _showSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: context.appTextPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 2),
              Text(subtitle,
                  style:
                      TextStyle(color: context.appTextSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderMiniCard extends StatelessWidget {
  final AdminProvider provider;
  const _ProviderMiniCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final statusColor = provider.isPending
        ? AppColors.warning
        : provider.isSuspended
            ? AppColors.error
            : AppColors.success;
    final statusLabel = provider.isPending
        ? 'Pendiente'
        : provider.isSuspended
            ? 'Pausado'
            : 'Activo';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: context.appSoftGreen,
            child: Text(
              provider.name.isNotEmpty ? provider.name[0].toUpperCase() : 'P',
              style: TextStyle(
                  color: context.appPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                    provider.email.isNotEmpty ? provider.email : provider.phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(statusLabel,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _BookingMiniCard extends StatelessWidget {
  final AdminBookingSummary booking;
  const _BookingMiniCard({required this.booking});

  Color _statusColor() {
    switch (booking.status) {
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

  String _statusLabel() {
    switch (booking.status) {
      case 'pending':
        return 'Pendiente';
      case 'confirmed':
        return 'Confirmada';
      case 'in_progress':
        return 'En curso';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return booking.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _statusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.receipt_long_outlined,
                color: _statusColor(), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextPrimary,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('${booking.clientName} → ${booking.providerName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: context.appTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${booking.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: context.appTextPrimary,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(_statusLabel(),
                    style: TextStyle(
                        color: _statusColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
