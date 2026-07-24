import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../features/admin/data/admin_repository.dart';
import '../../providers/auth_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminRepository _repository = AdminRepository();
  late Future<AdminDashboardData> _dashboardFuture;
  String? _busyProviderId;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _repository.loadDashboard();
  }

  Future<void> _reload() async {
    setState(() {
      _dashboardFuture = _repository.loadDashboard();
    });
    await _dashboardFuture;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Admin'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _reload,
          ),
        ],
      ),
      body: user?.hasAdminAccess != true
          ? const Center(child: Text('Acceso denegado. Solo para administradores.'))
          : FutureBuilder<AdminDashboardData>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Cargando panel...');
                }
                if (snapshot.hasError) {
                  return _AdminErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _reload,
                  );
                }
                final data = snapshot.data;
                if (data == null) {
                  return _AdminErrorView(
                    message: 'No se recibieron datos del panel.',
                    onRetry: _reload,
                  );
                }
                return RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    children: [
                      _AdminHeader(name: user?.name ?? 'Admin'),
                      const SizedBox(height: 16),
                      _StatsGrid(stats: data.stats),
                      const SizedBox(height: 22),
                      _SectionTitle(
                        title: 'Proveedores',
                        subtitle:
                            '${data.stats.pendingProviders} pendientes de revision',
                      ),
                      const SizedBox(height: 12),
                      if (data.providers.isEmpty)
                        const _EmptyPanel(text: 'No hay proveedores registrados.')
                      else
                        ...data.providers.map(_buildProviderCard),
                      const SizedBox(height: 22),
                      const _SectionTitle(
                        title: 'Reservas recientes',
                        subtitle: 'Ultimas operaciones de la plataforma',
                      ),
                      const SizedBox(height: 12),
                      if (data.recentBookings.isEmpty)
                        const _EmptyPanel(text: 'No hay reservas recientes.')
                      else
                        ...data.recentBookings.map(_BookingTile.new),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProviderCard(AdminProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: context.appSoftGreen,
                child: Text(
                  provider.name.isEmpty ? 'P' : provider.name[0].toUpperCase(),
                  style: TextStyle(
                    color: context.appPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.appTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      provider.email.isEmpty ? provider.phone : provider.email,
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
              _StatusChip(provider: provider),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(icon: Icons.place_outlined, text: provider.city.isEmpty ? 'Sin ciudad' : provider.city),
              _InfoChip(icon: Icons.star_rounded, text: provider.rating.toStringAsFixed(1)),
              _InfoChip(icon: Icons.rate_review_outlined, text: '${provider.reviewsCount} reviews'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (provider.isPending || provider.isSuspended)
                Expanded(
                  child: _AdminActionButton(
                    label: provider.isPending ? 'Aprobar' : 'Reactivar',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    isBusy: _busyProviderId == provider.id,
                    onPressed: () => _setProviderAction(
                      provider,
                      provider.isPending ? 'approve' : 'reactivate',
                    ),
                  ),
                ),
              if (provider.isPending || provider.isSuspended)
                const SizedBox(width: 10),
              if (!provider.isSuspended)
                Expanded(
                  child: _AdminActionButton(
                    label: 'Pausar',
                    icon: Icons.pause_circle_outline_rounded,
                    color: AppColors.warning,
                    isBusy: _busyProviderId == provider.id,
                    onPressed: () => _setProviderAction(provider, 'suspend'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _setProviderAction(AdminProvider provider, String action) async {
    setState(() => _busyProviderId = provider.id);
    try {
      if (action == 'approve') {
        await _repository.approveProvider(provider.id);
      } else if (action == 'suspend') {
        await _repository.suspendProvider(provider.id);
      } else {
        await _repository.reactivateProvider(provider.id);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proveedor actualizado.')),
      );
      await _reload();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo actualizar: $error')),
      );
    } finally {
      if (mounted) setState(() => _busyProviderId = null);
    }
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Hola, $name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final AdminStats stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem('Usuarios', stats.totalUsers, Icons.people_outline_rounded, AppColors.secondary),
      _StatItem('Proveedores', stats.totalProviders, Icons.engineering_outlined, AppColors.primary),
      _StatItem('Pendientes', stats.pendingProviders, Icons.pending_actions_rounded, AppColors.warning),
      _StatItem('Reservas', stats.totalBookings, Icons.event_note_rounded, AppColors.info),
      _StatItem('Servicios', stats.activeServices, Icons.home_repair_service_outlined, AppColors.success),
      _StatItem('Por confirmar', stats.pendingBookings, Icons.schedule_rounded, AppColors.accent),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 720 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: count == 3 ? 2.9 : 1.8,
          ),
          itemBuilder: (context, index) => _StatCard(item: items[index]),
        );
      },
    );
  }
}

class _StatItem {
  const _StatItem(this.label, this.value, this.icon, this.color);

  final String label;
  final int value;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _StatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: item.color, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value.toString(),
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.appTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.appTextPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: context.appTextSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.provider});

  final AdminProvider provider;

  @override
  Widget build(BuildContext context) {
    final color = provider.isPending
        ? AppColors.warning
        : provider.isSuspended
            ? AppColors.error
            : AppColors.success;
    final label = provider.isPending
        ? 'Pendiente'
        : provider.isSuspended
            ? 'Pausado'
            : 'Activo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: context.appTextSecondary),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: context.appTextSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AdminActionButton extends StatelessWidget {
  const _AdminActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isBusy,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isBusy ? null : onPressed,
      icon: isBusy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.55)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile(this.booking);

  final AdminBookingSummary booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, color: AppColors.info),
          const SizedBox(width: 10),
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
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${booking.clientName} -> ${booking.providerName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.appTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '\$${booking.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              color: context.appTextPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: context.appTextSecondary)),
    );
  }
}

class _AdminErrorView extends StatelessWidget {
  const _AdminErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appTextSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
