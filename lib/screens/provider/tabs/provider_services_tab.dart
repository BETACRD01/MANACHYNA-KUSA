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
        final user = context.watch<AuthProvider>().currentUser;
        final source = serviceProvider.services.isEmpty && user != null
            ? _mockProviderServices(user)
            : serviceProvider.services;
        final services = _filterServices(source);
        final active = source.where((service) => service.isActive).length;
        return _ProviderPage(
          title: 'Servicios',
          subtitle: 'Administra los servicios que ofreces',
          trailing: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.providerServices)
                  .then((_) => onRefresh());
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo servicio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _providerPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Expanded(child: _ProviderSearchBox()),
                    const SizedBox(width: 10),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: _providerPanelDecoration(context),
                      child: const Icon(Icons.filter_alt_outlined,
                          color: _providerMutedText),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _ProviderFilterBar(
                values: const {
                  'all': 'Todos',
                  'active': 'Activos',
                  'inactive': 'Pausados',
                },
                selected: statusFilter,
                onChanged: onStatusFilterChanged,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _ProviderServicesSummary(
                  active: active,
                  total: source.length,
                  popular: source.isNotEmpty
                      ? Helpers.getServiceCategoryName(source.first.category)
                      : 'Carpintería a domicilio',
                ),
              ),
            ),
            if (serviceProvider.isLoading)
              const SliverToBoxAdapter(
                child: LoadingWidget(message: 'Cargando servicios...'),
              )
            else if (serviceProvider.errorMessage != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ProviderErrorState(
                  message: serviceProvider.errorMessage!,
                  onRetry: onRefresh,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ProviderServiceCard(
                      service: services[index],
                      onToggle: () => _toggleService(context, services[index]),
                      onManage: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.providerServices,
                        ).then((_) => onRefresh());
                      },
                    ),
                    childCount: services.length,
                  ),
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
