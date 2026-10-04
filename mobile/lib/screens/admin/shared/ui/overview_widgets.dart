import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

import '../admin_colors.dart';
import 'admin_shared_widgets.dart';
import '../../../../features/admin/data/admin_repository.dart';

class AdminStatsGrid extends StatelessWidget {
  final AdminStats stats;

  const AdminStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      AdminStatData(
        label: 'Usuarios',
        value: formatCount(stats.totalUsers, fallback: 4320),
        trend: '↑ 12% vs semana pasada',
        icon: Icons.people_outline_rounded,
        color: adminPurple,
      ),
      AdminStatData(
        label: 'Proveedores',
        value: formatCount(stats.totalProviders, fallback: 1250),
        trend: '↑ 18% vs semana pasada',
        icon: Icons.business_center_outlined,
        color: AppColors.success,
      ),
      AdminStatData(
        label: 'Servicios',
        value: formatCount(stats.activeServices, fallback: 86),
        trend: '↑ 5% vs semana pasada',
        icon: Icons.work_outline_rounded,
        color: AppColors.info,
      ),
      AdminStatData(
        label: 'Solicitudes',
        value: formatCount(stats.totalBookings, fallback: 328),
        trend: '↑ 22% vs semana pasada',
        icon: Icons.description_outlined,
        color: AppColors.warning,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 640 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) => AdminStatCard(data: items[index]),
        );
      },
    );
  }
}

class AdminStatData {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;

  const AdminStatData({
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
  });
}

class AdminStatCard extends StatelessWidget {
  final AdminStatData data;

  const AdminStatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: adminPanelDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(data.icon, color: data.color, size: 31),
          ),
          const SizedBox(height: 14),
          Text(
            data.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: adminMuted, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: adminPurple,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.trend,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminQuickActions extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onCategories;
  final VoidCallback onReports;
  final VoidCallback onAlerts;

  const AdminQuickActions({super.key, 
    required this.onApprove,
    required this.onCategories,
    required this.onReports,
    required this.onAlerts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: adminPanelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones rápidas',
            style: TextStyle(
              color: adminDeep,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AdminActionTile(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Aprobar',
                  color: adminPurple,
                  onTap: onApprove,
                ),
              ),
              Expanded(
                child: AdminActionTile(
                  icon: Icons.grid_view_rounded,
                  label: 'Categorías',
                  color: AppColors.info,
                  onTap: onCategories,
                ),
              ),
              Expanded(
                child: AdminActionTile(
                  icon: Icons.bar_chart_rounded,
                  label: 'Reportes',
                  color: AppColors.success,
                  onTap: onReports,
                ),
              ),
              Expanded(
                child: AdminActionTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Alertas',
                  color: const Color(0xFFE94378),
                  onTap: onAlerts,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AdminActionTile({super.key, 
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.72)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 29),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: adminDeep,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSectionTitle extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;

  const AdminSectionTitle({super.key, 
    required this.title,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: adminDeep,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onAction,
          label: Text(action),
          icon: const Icon(Icons.chevron_right_rounded),
          iconAlignment: IconAlignment.end,
          style: TextButton.styleFrom(foregroundColor: adminPurple),
        ),
      ],
    );
  }
}

class AdminPendingReviewPanel extends StatelessWidget {
  final List<AdminProvider> providers;
  final VoidCallback onOpenProviders;

  const AdminPendingReviewPanel({super.key, 
    required this.providers,
    required this.onOpenProviders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      decoration: adminPanelDecoration(),
      child: Column(
        children: [
          for (var index = 0; index < providers.length; index++) ...[
            AdminPendingProviderRow(
              provider: providers[index],
              onTap: onOpenProviders,
            ),
            if (index != providers.length - 1)
              const Divider(height: 1, color: Color(0xFFEAE6F1)),
          ],
        ],
      ),
    );
  }
}

class AdminPendingProviderRow extends StatelessWidget {
  final AdminProvider provider;
  final VoidCallback onTap;

  const AdminPendingProviderRow({super.key, 
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category =
        provider.services.isNotEmpty ? provider.services.first : 'Electricidad';
    final color = adminCategoryColor(category);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Text(
                adminInitials(provider.name),
                style: TextStyle(color: color, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: adminDeep,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'RUC ${provider.id.hashCode.abs().toString().padLeft(10, '0').substring(0, 10)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: adminMuted, fontSize: 12),
                  ),
                  Text(
                    provider.city.isNotEmpty ? provider.city : 'Lima, Lima',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: adminMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(adminCategoryIcon(category), color: color, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: adminDeep,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Instalaciones',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: adminMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AdminPill(
              label: provider.isPending ? 'Pendiente' : 'Verificación',
              color: provider.isPending ? AppColors.warning : AppColors.info,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminOverviewWeeklySummary extends StatelessWidget {
  final AdminStats stats;

  const AdminOverviewWeeklySummary({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: adminPanelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Resumen semanal',
                  style: TextStyle(
                    color: adminDeep,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AdminPill(label: 'Esta semana', color: adminPurple),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(flex: 3, child: AdminBarChart()),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const AdminSmallMetric(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Nuevos proveedores',
                      value: '138',
                      trend: '↑ 24% vs semana pasada',
                      color: adminPurple,
                    ),
                    const SizedBox(height: 10),
                    AdminSmallMetric(
                      icon: Icons.check_circle_outline_rounded,
                      title: 'Solicitudes resueltas',
                      value: formatCount(
                        stats.completedBookings,
                        fallback: 276,
                      ),
                      trend: '↑ 16% vs semana pasada',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminBarChart extends StatelessWidget {
  const AdminBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    const values = [160.0, 230.0, 270.0, 405.0, 235.0, 250.0, 135.0];
    const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return SizedBox(
      height: 155,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (index) {
          final isLast = index == values.length - 1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 100 * (values[index] / 405),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          adminPurple.withValues(alpha: isLast ? 0.24 : 0.92),
                          adminPurple.withValues(alpha: isLast ? 0.15 : 0.55),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index],
                    style: const TextStyle(color: adminMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AdminSmallMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String trend;
  final Color color;

  const AdminSmallMetric({super.key, 
    required this.icon,
    required this.title,
    required this.value,
    required this.trend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: adminMuted, fontSize: 12),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: adminDeep,
                    fontSize: 19,
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
                    fontWeight: FontWeight.w800,
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

List<AdminProvider> mockAdminProviders() {
  return const [
    AdminProvider(
      id: 'mock-admin-provider-1',
      uid: 'mock-1',
      name: 'Carlos Mayancha',
      email: 'carlos.mayancha@manachyna.test',
      phone: '+593 99 421 1101',
      city: 'Tena',
      status: 'pending',
      isActive: false,
      rating: 4.8,
      reviewsCount: 42,
      services: ['Carpinteria'],
    ),
    AdminProvider(
      id: 'mock-admin-provider-2',
      uid: 'mock-2',
      name: 'Nelly Cerda',
      email: 'nelly.cerda@manachyna.test',
      phone: '+593 96 118 4404',
      city: 'Puerto Napo',
      status: 'pending',
      isActive: false,
      rating: 4.6,
      reviewsCount: 35,
      services: ['Cocina tradicional'],
    ),
    AdminProvider(
      id: 'mock-admin-provider-3',
      uid: 'mock-3',
      name: 'Luis Grefa',
      email: 'luis.grefa@manachyna.test',
      phone: '+593 95 730 5505',
      city: 'Misahualli',
      status: 'pending',
      isActive: false,
      rating: 4.7,
      reviewsCount: 51,
      services: ['Plomeria'],
    ),
    AdminProvider(
      id: 'mock-admin-provider-4',
      uid: 'mock-4',
      name: 'Maria Shiguango',
      email: 'maria.shiguango@manachyna.test',
      phone: '+593 98 225 2202',
      city: 'Archidona',
      status: 'approved',
      isActive: true,
      rating: 4.9,
      reviewsCount: 64,
      services: ['Limpieza'],
    ),
    AdminProvider(
      id: 'mock-admin-provider-5',
      uid: 'mock-5',
      name: 'Karla Tapuy',
      email: 'karla.tapuy@manachyna.test',
      phone: '+593 94 225 6606',
      city: 'Ahuano',
      status: 'approved',
      isActive: true,
      rating: 4.5,
      reviewsCount: 28,
      services: ['Jardineria'],
    ),
  ];
}

IconData adminCategoryIcon(String category) {
  final lower = category.toLowerCase();
  if (lower.contains('electric')) return Icons.bolt_rounded;
  if (lower.contains('carp')) return Icons.carpenter_rounded;
  if (lower.contains('plom')) return Icons.plumbing_rounded;
  if (lower.contains('pint')) return Icons.format_paint_rounded;
  if (lower.contains('limp')) return Icons.cleaning_services_rounded;
  return Icons.business_center_outlined;
}

Color adminCategoryColor(String category) {
  final lower = category.toLowerCase();
  if (lower.contains('electric')) return AppColors.warning;
  if (lower.contains('carp')) return const Color(0xFF9C6A2F);
  if (lower.contains('plom')) return AppColors.info;
  if (lower.contains('pint')) return const Color(0xFFE94378);
  if (lower.contains('limp')) return AppColors.success;
  return adminPurple;
}
