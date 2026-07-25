part of '../provider_dashboard.dart';

class _ProviderServicesTab extends StatelessWidget {
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final Future<void> Function() onRefresh;

  const _ProviderServicesTab({
    required this.statusFilter,
    required this.onStatusFilterChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, _) {
        final services = _filterServices(serviceProvider.services);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _ProviderFilterBar(
                      values: const {
                        'all': 'Todos',
                        'active': 'Activos',
                        'inactive': 'Inactivos',
                      },
                      selected: statusFilter,
                      onChanged: onStatusFilterChanged,
                      outerPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Gestionar servicios',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.providerServices)
                          .then((_) => onRefresh());
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: serviceProvider.isLoading
                  ? const LoadingWidget(message: 'Cargando servicios...')
                  : serviceProvider.errorMessage != null
                      ? _ProviderErrorState(
                          message: serviceProvider.errorMessage!,
                          onRetry: onRefresh,
                        )
                      : services.isEmpty
                          ? _ProviderEmptyState(
                              icon: Icons.home_repair_service_outlined,
                              text: statusFilter == 'all'
                                  ? 'Todavía no tienes servicios registrados.'
                                  : 'No hay servicios con ese filtro.',
                              actionText: 'Agregar servicio',
                              onAction: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.providerServices,
                                ).then((_) => onRefresh());
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                return _ProviderServiceCard(
                                  service: services[index],
                                  onToggle: () =>
                                      _toggleService(context, services[index]),
                                  onManage: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.providerServices,
                                    ).then((_) => onRefresh());
                                  },
                                );
                              },
                            ),
            ),
          ],
        );
      },
    );
  }

  List<ServiceModel> _filterServices(List<ServiceModel> services) {
    if (statusFilter == 'active') {
      return services.where((service) => service.isActive).toList();
    }
    if (statusFilter == 'inactive') {
      return services.where((service) => !service.isActive).toList();
    }
    return services;
  }

  Future<void> _toggleService(
      BuildContext context, ServiceModel service) async {
    final updated = service.copyWith(
      isActive: !service.isActive,
      updatedAt: DateTime.now(),
    );
    final ok = await context.read<ServiceProvider>().updateService(updated);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? (service.isActive ? 'Servicio desactivado' : 'Servicio activado')
            : 'No se pudo actualizar el servicio'),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ),
    );
  }
}
