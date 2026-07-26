import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_theme_colors.dart';
import '../../../../../providers/notification_provider.dart';

class HomeInicioHeroSection extends StatelessWidget {
  const HomeInicioHeroSection({
    required this.userName,
    required this.onSearchTap,
    Key? key,
  }) : super(key: key);

  final String userName;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, $userName! 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '¿Qué servicio\nnecesitas hoy?',
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.08,
                        fontWeight: FontWeight.w900,
                        color: context.appTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer<NotificationProvider>(
              builder: (context, notifProvider, _) {
                return GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.notifications),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: context.appSurface,
                      shape: BoxShape.circle,
                      boxShadow: context.appCardShadow,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: context.appTextPrimary,
                          size: 28,
                        ),
                        if (notifProvider.unreadCount > 0)
                          const Positioned(
                            top: 14,
                            right: 13,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: context.appSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.appBorder),
                boxShadow: context.appCardShadow,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: context.appTextSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Buscar limpieza, plomería, electricidad...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.appTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeInicioTrustFeatureRow extends StatelessWidget {
  const HomeInicioTrustFeatureRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const items = [
      _FeatureData(
        title: 'Rápido',
        subtitle: 'Atención ágil',
        icon: Icons.timer_outlined,
      ),
      _FeatureData(
        title: 'Confiable',
        subtitle: 'Proveedores verificados',
        icon: Icons.verified_user_rounded,
      ),
      _FeatureData(
        title: 'Seguro',
        subtitle: 'Pagos y datos protegidos',
        icon: Icons.lock_rounded,
      ),
    ];

    return Row(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Expanded(child: _FeatureCard(data: items[index])),
          if (index != items.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class HomeInicioSectionHeader extends StatelessWidget {
  const HomeInicioSectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            ),
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeInicioPromoCard extends StatelessWidget {
  const HomeInicioPromoCard({required this.onTap, Key? key}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 22, 0, 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: context.isDarkMode
                ? const [Color(0xFF152018), Color(0xFF1F3221)]
                : const [Color(0xFFF8FBF7), Color(0xFFEAF5E8)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¿Tienes una tarea\nen casa?',
                    style: TextStyle(
                      fontSize: 24,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Describe lo que necesitas y recibe opciones cercanas.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: context.appTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Solicitar servicio',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 132,
              height: 148,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 10,
                    right: 26,
                    child: Icon(
                      Icons.light_rounded,
                      color: Colors.amber.shade600,
                      size: 20,
                    ),
                  ),
                  const Positioned(
                    right: -12,
                    bottom: -4,
                    child: _PromoMiniCard(),
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

class HomeInicioSafetyCard extends StatelessWidget {
  const HomeInicioSafetyCard({required this.servicesCount, Key? key})
      : super(key: key);

  final int servicesCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Row(
        children: [
          const _BigSoftIcon(icon: Icons.shield_rounded),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tu seguridad es nuestra prioridad',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Trabajamos con proveedores verificados para que tengas una experiencia segura y confiable.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class HomeInicioQuickStats extends StatelessWidget {
  const HomeInicioQuickStats({required this.servicesCount, Key? key})
      : super(key: key);

  final int servicesCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              label: 'Servicios\npublicados',
              value: servicesCount.toString(),
              icon: Icons.assignment_turned_in_rounded,
            ),
          ),
          const _StatDivider(),
          const Expanded(
            child: _StatTile(
              label: 'Respuesta\npromedio',
              value: '24h',
              icon: Icons.bolt_rounded,
            ),
          ),
          const _StatDivider(),
          const Expanded(
            child: _StatTile(
              label: 'Cobertura\nen tu zona',
              value: 'Napo',
              icon: Icons.location_on_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.data});

  final _FeatureData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 158),
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BigSoftIcon(icon: data.icon),
          const SizedBox(height: 14),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: context.appTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 36),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              color: context.appTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 78,
      color: context.appBorder,
    );
  }
}

class _BigSoftIcon extends StatelessWidget {
  const _BigSoftIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: context.appSoftGreen,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 34),
    );
  }
}

class _PromoMiniCard extends StatelessWidget {
  const _PromoMiniCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 118,
      decoration: BoxDecoration(
        color: context.appSurface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        boxShadow: context.appCardShadow,
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 18,
            child: Icon(
              Icons.weekend_rounded,
              size: 58,
              color: Color(0xFF9ABF87),
            ),
          ),
          Positioned(
            left: 28,
            bottom: 22,
            child: Icon(
              Icons.eco_rounded,
              size: 28,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
