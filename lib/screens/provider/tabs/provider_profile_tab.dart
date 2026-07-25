part of '../provider_dashboard.dart';

class _ProviderProfileTab extends StatelessWidget {
  final UserModel user;
  const _ProviderProfileTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return _ProviderPage(
      title: 'Perfil del proveedor',
      subtitle: 'Gestiona tu información profesional',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          sliver: SliverToBoxAdapter(
            child: _ProviderProfileHero(user: user),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.12,
            children: [
              _ProfileInfoPanel(
                title: 'Información del negocio',
                icon: Icons.storefront_outlined,
                children: [
                  _ProfileLine(
                    icon: Icons.location_on_outlined,
                    text: user.address.isNotEmpty
                        ? user.address
                        : 'Av. Arequipa 1234, Miraflores',
                  ),
                  _ProfileLine(
                    icon: Icons.phone_outlined,
                    text:
                        user.phone.isNotEmpty ? user.phone : '+51 987 654 321',
                  ),
                  _ProfileLine(
                    icon: Icons.mail_outline,
                    text: user.email.isNotEmpty
                        ? user.email
                        : 'contacto@servicioselsol.pe',
                  ),
                ],
              ),
              const _ProfileInfoPanel(
                title: 'Horarios',
                icon: Icons.schedule_rounded,
                children: [
                  _ScheduleRow(
                      day: 'Lunes - Viernes', time: '8:00 a. m. - 6:00 p. m.'),
                  _ScheduleRow(day: 'Sábado', time: '8:00 a. m. - 2:00 p. m.'),
                  _ScheduleRow(day: 'Domingo', time: 'Cerrado'),
                  _ResponseBadge(),
                ],
              ),
              _ProfileInfoPanel(
                title: 'Especialidades',
                icon: Icons.business_center_outlined,
                children: [
                  _ChipWrap(
                      labels: user.services.isNotEmpty
                          ? user.services.take(4).toList()
                          : const [
                              'Carpintería',
                              'Electricidad',
                              'Plomería',
                              'Pintura'
                            ]),
                ],
              ),
              const _ProfileInfoPanel(
                title: 'Cobertura',
                icon: Icons.pin_drop_outlined,
                children: [
                  _ChipWrap(labels: [
                    'Miraflores',
                    'Surco',
                    'San Borja',
                    'Barranco',
                    'San Isidro',
                    '+2'
                  ]),
                ],
              ),
              const _ProfileInfoPanel(
                title: 'Documentos',
                icon: Icons.description_outlined,
                children: [
                  _DocLine(label: 'RUC', value: '20601234567'),
                  _DocLine(
                      label: 'Verificación de identidad', value: 'Completada'),
                  _DocLine(
                      label: 'Verificación de domicilio', value: 'Completada'),
                ],
              ),
              _ProfileInfoPanel(
                title: 'Configuración',
                icon: Icons.settings_outlined,
                children: [
                  _SettingsLine(
                    icon: Icons.notifications_outlined,
                    label: 'Notificaciones',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                  _SettingsLine(
                    icon: Icons.shield_outlined,
                    label: 'Privacidad',
                    onTap: () {},
                  ),
                  _SettingsLine(
                    icon: Icons.help_outline_rounded,
                    label: 'Ayuda',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.helpCenter),
                  ),
                  _SettingsLine(
                    icon: Icons.logout_rounded,
                    label: 'Cerrar sesión',
                    color: AppColors.error,
                    onTap: () => context.read<AuthProvider>().signOut(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
