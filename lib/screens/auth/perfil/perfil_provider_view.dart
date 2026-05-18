import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_colors.dart';

class PerfilProviderView extends StatelessWidget {
  const PerfilProviderView({
    required this.onBack,
    required this.onApply,
    Key? key,
  }) : super(key: key);

  final VoidCallback onBack;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 42, 28, 28),
            child: Column(
              children: [
                const ProviderToolsIllustration(),
                const SizedBox(height: 34),
                Text(
                  'Conviértete en proveedor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Ofrece tus servicios en nuestra plataforma y conecta con clientes que necesitan tu experiencia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.55,
                    color: context.appTextSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                const ProviderBenefitItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Más oportunidades',
                  subtitle:
                      'Recibe reservas de clientes interesados en tus servicios.',
                ),
                const ProviderDivider(),
                const ProviderBenefitItem(
                  icon: Icons.calendar_month_outlined,
                  title: 'Gestiona tus servicios',
                  subtitle:
                      'Configura tu disponibilidad, precios y servicios fácilmente.',
                ),
                const ProviderDivider(),
                const ProviderBenefitItem(
                  icon: Icons.verified_user_outlined,
                  title: 'Confianza y seguridad',
                  subtitle:
                      'Verificamos a todos los proveedores para garantizar un servicio seguro.',
                ),
                const ProviderDivider(),
                const ProviderBenefitItem(
                  icon: Icons.bar_chart_rounded,
                  title: 'Haz crecer tu negocio',
                  subtitle: 'Construye tu reputación y consigue más clientes.',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Quiero ser proveedor'),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: onApply,
                child: const Text(
                  'Más información',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProviderBenefitItem extends StatelessWidget {
  const ProviderBenefitItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: context.appSoftGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 26),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: context.appTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProviderDivider extends StatelessWidget {
  const ProviderDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 72, top: 24, bottom: 24),
      child: Divider(height: 1, color: context.appBorder),
    );
  }
}

class ProviderToolsIllustration extends StatelessWidget {
  const ProviderToolsIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 22,
            child: Container(
              width: 170,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          const Positioned(
            top: 40,
            left: 62,
            child: _ToolIcon(icon: Icons.construction_rounded, angle: -0.35),
          ),
          const Positioned(
            top: 26,
            left: 100,
            child: _ToolIcon(icon: Icons.handyman_rounded, angle: 0.05),
          ),
          const Positioned(
            top: 42,
            right: 60,
            child: _ToolIcon(icon: Icons.build_rounded, angle: 0.42),
          ),
          Positioned(
            bottom: 32,
            child: Container(
              width: 150,
              height: 82,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          Positioned(
            right: 34,
            bottom: 18,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: context.appSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 44,
              ),
            ),
          ),
          const Positioned(
            left: 24,
            top: 86,
            child: Icon(Icons.auto_awesome, color: Color(0xFF63B774), size: 20),
          ),
          const Positioned(
            right: 54,
            top: 24,
            child: Icon(Icons.auto_awesome, color: Color(0xFF63B774), size: 18),
          ),
          const Positioned(
            right: 18,
            top: 86,
            child: Icon(Icons.auto_awesome, color: Color(0xFFC4E4CA), size: 24),
          ),
        ],
      ),
    );
  }
}

class _ToolIcon extends StatelessWidget {
  const _ToolIcon({
    required this.icon,
    required this.angle,
  });

  final IconData icon;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Icon(icon, color: AppColors.primary, size: 54),
    );
  }
}
