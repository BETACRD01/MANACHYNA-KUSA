part of '../provider_dashboard.dart';

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
    final statusColor = service.isActive ? AppColors.success : AppColors.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: _providerPanelDecoration(context),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home_repair_service_outlined,
                color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${Helpers.getServiceCategoryName(service.category)} · ${_money(service.pricePerHour)}/hora',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: context.appTextSecondary, fontSize: 12),
                ),
                const SizedBox(height: 7),
                _ProviderStatusPill(
                  label: service.isActive ? 'Activo' : 'Inactivo',
                  color: statusColor,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: service.isActive ? 'Desactivar' : 'Activar',
            onPressed: onToggle,
            icon: Icon(
              service.isActive
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Gestionar',
            onPressed: onManage,
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
    );
  }
}
