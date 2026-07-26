import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../models/user/user_model.dart';
import '../../../../providers/auth_provider.dart';

import '../../shared/ui/provider_shared_widgets.dart';
class ProviderProfileTab extends StatelessWidget {
  final UserModel user;
  const ProviderProfileTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final panels = _buildProfilePanels(context);
    return ProviderPage(
      title: 'Perfil del proveedor',
      subtitle: 'Gestiona tu información profesional',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: SliverToBoxAdapter(
            child: ProviderProfileHero(user: user),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 640;
                final itemWidth = isWide
                    ? (constraints.maxWidth - 14) / 2
                    : constraints.maxWidth;
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: panels
                      .map((panel) => SizedBox(width: itemWidth, child: panel))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildProfilePanels(BuildContext context) {
    return [
      ProfileInfoPanel(
        title: 'Información del negocio',
        icon: Icons.storefront_outlined,
        children: [
          ProfileLine(
            icon: Icons.location_on_outlined,
            text: user.address.isNotEmpty ? user.address : 'Av. Arequipa 1234',
          ),
          ProfileLine(
            icon: Icons.phone_outlined,
            text: user.phone.isNotEmpty ? user.phone : '+51 987 654 321',
          ),
          ProfileLine(
            icon: Icons.mail_outline,
            text: user.email.isNotEmpty ? user.email : 'contacto@servicios.pe',
          ),
        ],
      ),
      const ProfileInfoPanel(
        title: 'Horarios',
        icon: Icons.schedule_rounded,
        children: [
          ScheduleRow(day: 'Lunes - Viernes', time: '8:00 a. m. - 6:00 p. m.'),
          ScheduleRow(day: 'Sábado', time: '8:00 a. m. - 2:00 p. m.'),
          ScheduleRow(day: 'Domingo', time: 'Cerrado'),
          ResponseBadge(),
        ],
      ),
      ProfileInfoPanel(
        title: 'Especialidades',
        icon: Icons.business_center_outlined,
        children: [
          ChipWrap(
            labels: user.services.isNotEmpty
                ? user.services.take(4).toList()
                : const ['Carpintería', 'Electricidad', 'Plomería', 'Pintura'],
          ),
        ],
      ),
      const ProfileInfoPanel(
        title: 'Cobertura',
        icon: Icons.pin_drop_outlined,
        children: [
          ChipWrap(
            labels: [
              'Miraflores',
              'Surco',
              'San Borja',
              'Barranco',
              'San Isidro',
              '+2',
            ],
          ),
        ],
      ),
      const ProfileInfoPanel(
        title: 'Documentos',
        icon: Icons.description_outlined,
        children: [
          DocLine(label: 'RUC', value: '20601234567'),
          DocLine(label: 'Identidad', value: 'Completada'),
          DocLine(label: 'Domicilio', value: 'Completada'),
        ],
      ),
      ProfileInfoPanel(
        title: 'Configuración',
        icon: Icons.settings_outlined,
        children: [
          SettingsLine(
            icon: Icons.notifications_outlined,
            label: 'Notificaciones',
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          SettingsLine(
            icon: Icons.shield_outlined,
            label: 'Privacidad',
            onTap: () {},
          ),
          SettingsLine(
            icon: Icons.help_outline_rounded,
            label: 'Ayuda',
            onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter),
          ),
          SettingsLine(
            icon: Icons.logout_rounded,
            label: 'Cerrar sesión',
            color: AppColors.error,
            onTap: () => _signOut(context),
          ),
        ],
      ),
    ];
  }

  Future<void> _signOut(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (_) => false,
    );
  }
}
