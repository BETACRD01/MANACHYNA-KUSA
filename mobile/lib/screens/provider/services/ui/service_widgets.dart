import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../models/service/service_model.dart';

import '../../shared/ui/provider_shared_widgets.dart';
class ProviderSearchBox extends StatelessWidget {
  const ProviderSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: providerPanelDecoration(context),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: providerMutedText, size: 28),
          SizedBox(width: 12),
          Text(
            'Buscar servicios',
            style: TextStyle(
              color: Color(0xFFA4A0B8),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderServicesSummary extends StatelessWidget {
  final int active;
  final int total;
  final String popular;

  const ProviderServicesSummary({super.key, 
    required this.active,
    required this.total,
    required this.popular,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: providerPanelDecoration(context),
            child: Row(
              children: [
                const SoftIcon(
                  icon: Icons.business_center_outlined,
                  color: AppColors.success,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Servicios activos',
                          style: TextStyle(color: providerMutedText)),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$active',
                              style: const TextStyle(
                                color: providerPurple,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: ' de $total',
                              style: const TextStyle(
                                color: providerMutedText,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text('↗ 10% vs mes pasado',
                          style: TextStyle(
                              color: AppColors.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: providerPanelDecoration(context),
            child: Row(
              children: [
                const SoftIcon(
                    icon: Icons.star_border_rounded, color: AppColors.warning),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Más solicitado:',
                          style: TextStyle(color: providerMutedText)),
                      const SizedBox(height: 4),
                      Text(
                        popular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: providerDeep,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text('32% de las solicitudes',
                          style: TextStyle(
                              color: providerMutedText, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProviderServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onToggle;
  final VoidCallback onManage;

  const ProviderServiceCard({super.key, 
    required this.service,
    required this.onToggle,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        service.isActive ? AppColors.success : AppColors.warning;
    final serviceIcon = Container(
      width: 92,
      height: 86,
      decoration: BoxDecoration(
        color: _serviceColor(service.category).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        _serviceIcon(service.category),
        color: _serviceColor(service.category),
        size: 38,
      ),
    );
    final serviceInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: providerDeep,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          service.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: providerMutedText, fontSize: 13),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              providerFormatMoney(service.pricePerHour),
              style: const TextStyle(
                color: providerPurple,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Icon(
              Icons.schedule_rounded,
              color: providerMutedText,
              size: 16,
            ),
            Text(
              _durationRange(service.estimatedDuration),
              style: const TextStyle(
                color: providerMutedText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
    final serviceActions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProviderStatusPill(
          label: service.isActive ? 'Activo' : 'Pausado',
          color: statusColor,
        ),
        const SizedBox(width: 10),
        SquareIconButton(
          icon: Icons.edit_outlined,
          onTap: onManage,
        ),
        const SizedBox(width: 8),
        SquareIconButton(
          icon: Icons.more_horiz_rounded,
          onTap: onToggle,
        ),
      ],
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: providerPanelDecoration(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 390) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    serviceIcon,
                    const SizedBox(width: 14),
                    Expanded(child: serviceInfo),
                  ],
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: serviceActions,
                  ),
                ),
              ],
            );
          }

          return Row(
            children: [
              serviceIcon,
              const SizedBox(width: 14),
              Expanded(child: serviceInfo),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ProviderStatusPill(
                    label: service.isActive ? 'Activo' : 'Pausado',
                    color: statusColor,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SquareIconButton(
                        icon: Icons.edit_outlined,
                        onTap: onManage,
                      ),
                      const SizedBox(width: 8),
                      SquareIconButton(
                        icon: Icons.more_horiz_rounded,
                        onTap: onToggle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class SoftIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SoftIcon({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SquareIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9E5F0)),
        ),
        child: Icon(icon, color: providerPurple),
      ),
    );
  }
}

IconData _serviceIcon(ServiceCategory category) {
  switch (category) {
    case ServiceCategory.electricity:
      return Icons.electrical_services_rounded;
    case ServiceCategory.plumbing:
      return Icons.plumbing_rounded;
    case ServiceCategory.carpentry:
      return Icons.chair_alt_rounded;
    case ServiceCategory.cleaning:
      return Icons.cleaning_services_rounded;
    default:
      return Icons.format_paint_rounded;
  }
}

Color _serviceColor(ServiceCategory category) {
  switch (category) {
    case ServiceCategory.electricity:
      return AppColors.warning;
    case ServiceCategory.plumbing:
      return AppColors.info;
    case ServiceCategory.carpentry:
      return const Color(0xFFA76A2A);
    case ServiceCategory.cleaning:
      return AppColors.success;
    default:
      return const Color(0xFFE83F91);
  }
}

String _durationRange(int minutes) {
  final hours = (minutes / 60).round().clamp(1, 8);
  final start = hours == 1 ? 1 : hours - 1;
  return '$start - $hours horas';
}
