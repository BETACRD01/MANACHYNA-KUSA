import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../features/admin/data/admin_repository.dart';
import '../../../../models/user/user_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../shared/admin_colors.dart';
import '../../shared/ui/admin_shared_widgets.dart';

class AdminProfileTab extends StatelessWidget {
  final UserModel user;
  final AdminStats stats;

  const AdminProfileTab({super.key, 
    required this.user,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final name = user.name.isNotEmpty ? user.name : 'Willian Cerda';
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const AdminPageHeader(
          title: 'Perfil de administrador',
          subtitle: 'Configuración y control de la cuenta',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: adminPanelDecoration(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: adminPurple.withValues(alpha: 0.12),
                  child: Text(
                    adminInitials(name),
                    style: const TextStyle(
                      color: adminPurple,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: adminDeep,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const AdminPill(
                          label: 'Administrador', color: adminPurple),
                      const SizedBox(height: 12),
                      AdminProfileLine(
                        icon: Icons.mail_outline,
                        text: user.email.isNotEmpty
                            ? user.email
                            : 'willian.cerda@manachyna-kusa.com',
                      ),
                      const AdminProfileLine(
                        icon: Icons.calendar_month_outlined,
                        text: 'Miembro desde ene 2024',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: AdminLargeMetricCard(
                  icon: Icons.people_outline_rounded,
                  title: 'Usuarios',
                  value: formatCount(stats.totalUsers, fallback: 4320),
                  trend: '↑ 12% vs semana pasada',
                  color: adminPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminLargeMetricCard(
                  icon: Icons.business_center_outlined,
                  title: 'Proveedores',
                  value: formatCount(stats.totalProviders, fallback: 1250),
                  trend: '↑ 18% vs semana pasada',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: adminPanelDecoration(),
            child: Column(
              children: [
                AdminSettingsLine(
                  icon: Icons.lock_outline_rounded,
                  title: 'Seguridad',
                  subtitle:
                      'Cambia tu contraseña, verificación en dos pasos y dispositivos.',
                  onTap: () {},
                ),
                AdminSettingsLine(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notificaciones',
                  subtitle: 'Personaliza cómo y cuándo recibes notificaciones.',
                  onTap: () {},
                ),
                AdminSettingsLine(
                  icon: Icons.tune_rounded,
                  title: 'Preferencias',
                  subtitle: 'Ajustes de idioma, zona horaria y apariencia.',
                  onTap: () {},
                ),
                AdminSettingsLine(
                  icon: Icons.headset_mic_outlined,
                  title: 'Soporte',
                  subtitle: 'Centro de ayuda, documentos y contacto.',
                  onTap: () {},
                ),
                AdminSettingsLine(
                  icon: Icons.logout_rounded,
                  title: 'Cerrar sesión',
                  subtitle: 'Finaliza tu sesión en la plataforma.',
                  color: AppColors.error,
                  showDivider: false,
                  onTap: () => signOut(context),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: adminPanelDecoration(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado del sistema',
                  style: TextStyle(
                    color: adminDeep,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AdminSystemStatus(
                        icon: Icons.check_circle_outline_rounded,
                        title: 'Plataforma estable',
                        subtitle: 'Todos los servicios operativos',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: AdminSystemStatus(
                        icon: Icons.circle,
                        title: 'API conectada',
                        subtitle: 'Última verificación: hace 2 min',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> signOut(BuildContext context) async {
    await context.read<AuthProvider>().signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }
}

class AdminProfileLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const AdminProfileLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: adminMuted, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: adminMuted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
