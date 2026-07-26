import 'package:flutter/material.dart';
import '../../../../features/admin/data/admin_repository.dart'; // For AdminStats
import '../../../../core/constants/app_colors.dart';
import '../../shared/admin_colors.dart';
import '../../shared/ui/admin_shared_widgets.dart';


class AdminUsersTab extends StatelessWidget {
  final AdminStats stats;

  const AdminUsersTab({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final users = mockAdminUsers();
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const AdminPageHeader(
          title: 'Usuarios',
          subtitle: 'Administra cuentas, roles y accesos',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Row(
            children: [
              const Expanded(
                  child: AdminSearchBox(hint: 'Buscar usuarios...')),
              const SizedBox(width: 12),
              AdminFilterButton(label: 'Filtrar', onTap: () {}),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
          child: AdminSegmentedFilters(
            values: ['Todos', 'Activos', 'Bloqueados', 'Admins'],
            selected: 'Todos',
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: AdminLargeMetricCard(
                  icon: Icons.people_outline_rounded,
                  title: 'Total usuarios',
                  value: formatCount(stats.totalUsers, fallback: 4320),
                  trend: '↑ 12% vs semana pasada',
                  color: adminPurple,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: AdminLargeMetricCard(
                  icon: Icons.person_add_alt_1_rounded,
                  title: 'Nuevos hoy',
                  value: '48',
                  trend: '↑ 18% vs ayer',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 120),
          child: Column(
            children: users.map((user) => AdminUserCard(user: user)).toList(),
          ),
        ),
      ],
    );
  }
}

class AdminUserData {
  final String name;
  final String email;
  final String city;
  final String role;
  final bool active;

  const AdminUserData({
    required this.name,
    required this.email,
    required this.city,
    required this.role,
    required this.active,
  });
}

class AdminUserCard extends StatelessWidget {
  final AdminUserData user;

  const AdminUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final roleColor = user.role == 'Administrador'
        ? AppColors.warning
        : user.role == 'Proveedor'
            ? AppColors.info
            : adminPurple;
    final statusColor = user.active ? AppColors.success : AppColors.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: adminPanelDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: roleColor.withValues(alpha: 0.12),
            child: Text(
              adminInitials(user.name),
              style: TextStyle(
                color: roleColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: adminDeep,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: adminMuted, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: adminMuted, size: 15),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: adminMuted, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdminPill(label: user.role, color: roleColor),
              const SizedBox(height: 8),
              AdminPill(
                label: user.active ? 'Activo' : 'Bloqueado',
                color: statusColor,
                dot: true,
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right_rounded, color: adminPurple),
          ),
        ],
      ),
    );
  }
}

List<AdminUserData> mockAdminUsers() {
  return const [
    AdminUserData(
      name: 'Ana Paredes',
      email: 'ana.paredes@gmail.com',
      city: 'Tena, Napo',
      role: 'Cliente',
      active: true,
    ),
    AdminUserData(
      name: 'Carlos Mayancha',
      email: 'carlos.mayancha@manachyna.test',
      city: 'Tena, Napo',
      role: 'Proveedor',
      active: true,
    ),
    AdminUserData(
      name: 'Willian Cerda',
      email: 'williancerda0@gmail.com',
      city: 'Tena, Napo',
      role: 'Administrador',
      active: true,
    ),
    AdminUserData(
      name: 'Maria Shiguango',
      email: 'maria.shiguango@manachyna.test',
      city: 'Archidona, Napo',
      role: 'Proveedor',
      active: true,
    ),
    AdminUserData(
      name: 'Paola Vargas',
      email: 'paola.vargas@gmail.com',
      city: 'Puerto Napo, Napo',
      role: 'Cliente',
      active: false,
    ),
  ];
}
