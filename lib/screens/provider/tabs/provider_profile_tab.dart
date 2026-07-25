part of '../provider_dashboard.dart';

class _ProviderProfileTab extends StatelessWidget {
  final UserModel user;
  const _ProviderProfileTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProviderSectionHeader(
          title: 'Perfil de proveedor',
          subtitle: 'Datos visibles para clientes y operación',
          actionText: 'Editar',
          onAction: () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _providerPanelDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: context.appSoftGreen,
                    backgroundImage: user.profileImageUrl != null &&
                            user.profileImageUrl!.isNotEmpty
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null ||
                            user.profileImageUrl!.isEmpty
                        ? Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : 'P',
                            style: TextStyle(
                              color: context.appPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        : null,
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
                          style: TextStyle(
                            color: context.appTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
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
                  const _ProviderStatusPill(
                    label: 'Proveedor',
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ProviderInfoChip(
                    icon: Icons.star_rounded,
                    text: '${user.rating.toStringAsFixed(1)} valoración',
                  ),
                  _ProviderInfoChip(
                    icon: Icons.location_on_outlined,
                    text: user.address.isNotEmpty
                        ? user.address
                        : 'Sin dirección',
                  ),
                  _ProviderInfoChip(
                    icon: Icons.phone_outlined,
                    text: user.phone.isNotEmpty ? user.phone : 'Sin teléfono',
                  ),
                ],
              ),
              if ((user.description ?? '').isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  user.description!,
                  style: TextStyle(
                    color: context.appTextSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _ProviderSectionHeader(
          title: 'Mantenimiento',
          subtitle: 'Accesos rápidos para configurar tu operación',
        ),
        const SizedBox(height: 12),
        _ProviderMenuTile(
          icon: Icons.edit_outlined,
          title: 'Editar perfil público',
          subtitle: 'Nombre, foto, teléfono, descripción y ubicación',
          onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
        _ProviderMenuTile(
          icon: Icons.home_repair_service_outlined,
          title: 'Gestionar servicios',
          subtitle: 'Crear, activar, pausar o editar servicios',
          onTap: () => Navigator.pushNamed(context, AppRoutes.providerServices),
        ),
        _ProviderMenuTile(
          icon: Icons.notifications_outlined,
          title: 'Notificaciones',
          subtitle: 'Reservas, mensajes y avisos de cuenta',
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
        ),
      ],
    );
  }
}
