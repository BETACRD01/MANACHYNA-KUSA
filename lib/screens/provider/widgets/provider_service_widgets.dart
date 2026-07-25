part of '../provider_dashboard.dart';

class _ProviderSearchBox extends StatelessWidget {
  const _ProviderSearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _providerPanelDecoration(context),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: _providerMutedText, size: 28),
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

class _ProviderServicesSummary extends StatelessWidget {
  final int active;
  final int total;
  final String popular;

  const _ProviderServicesSummary({
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
            decoration: _providerPanelDecoration(context),
            child: Row(
              children: [
                const _SoftIcon(
                  icon: Icons.business_center_outlined,
                  color: AppColors.success,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Servicios activos',
                          style: TextStyle(color: _providerMutedText)),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$active',
                              style: const TextStyle(
                                color: _providerPurple,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: ' de $total',
                              style: const TextStyle(
                                color: _providerMutedText,
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
            decoration: _providerPanelDecoration(context),
            child: Row(
              children: [
                const _SoftIcon(
                    icon: Icons.star_border_rounded, color: AppColors.warning),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Más solicitado:',
                          style: TextStyle(color: _providerMutedText)),
                      const SizedBox(height: 4),
                      Text(
                        popular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _providerDeep,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text('32% de las solicitudes',
                          style: TextStyle(
                              color: _providerMutedText, fontSize: 11)),
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

class _ProviderServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onToggle;
  final VoidCallback onManage;

  const _ProviderServiceCard({
    required this.service,
    required this.onToggle,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        service.isActive ? AppColors.success : AppColors.warning;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: _providerPanelDecoration(context),
      child: Row(
        children: [
          Container(
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
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _providerDeep,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  service.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: _providerMutedText, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${_money(service.pricePerHour)} ',
                      style: const TextStyle(
                        color: _providerPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text('· ',
                        style: TextStyle(color: _providerMutedText)),
                    const Icon(Icons.schedule_rounded,
                        color: _providerMutedText, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _durationRange(service.estimatedDuration),
                      style: const TextStyle(
                          color: _providerMutedText,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              _ProviderStatusPill(
                label: service.isActive ? 'Activo' : 'Pausado',
                color: statusColor,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SquareIconButton(
                    icon: Icons.edit_outlined,
                    onTap: onManage,
                  ),
                  const SizedBox(width: 8),
                  _SquareIconButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: onToggle,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SoftIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SoftIcon({required this.icon, required this.color});

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

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareIconButton({required this.icon, required this.onTap});

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
        child: Icon(icon, color: _providerPurple),
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
