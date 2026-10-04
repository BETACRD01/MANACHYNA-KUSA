import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../models/service/service_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/service_provider.dart';

import '../../shared/ui/provider_shared_widgets.dart';
import 'service_widgets.dart';
class ProviderServicesTab extends StatelessWidget {
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final Future<void> Function() onRefresh;

  const ProviderServicesTab({super.key, 
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
            ? mockProviderServices(user)
            : serviceProvider.services;
        final services = _filterServices(source);
        final active = source.where((service) => service.isActive).length;
        return ProviderPage(
          title: 'Servicios',
          subtitle: 'Administra los servicios que ofreces',
          trailing: ElevatedButton.icon(
            onPressed: () => _showServiceEditor(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo servicio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: providerPurple,
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
                    const Expanded(child: ProviderSearchBox()),
                    const SizedBox(width: 10),
                    Container(
                      width: 54,
                      height: 54,
                      decoration: providerPanelDecoration(context),
                      child: const Icon(Icons.filter_alt_outlined,
                          color: providerMutedText),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ProviderFilterBar(
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
                child: ProviderServicesSummary(
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
                child: ProviderErrorState(
                  message: serviceProvider.errorMessage!,
                  onRetry: onRefresh,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProviderServiceCard(
                      service: services[index],
                      onToggle: () => _toggleService(context, services[index]),
                      onManage: () =>
                          _showServiceEditor(context, services[index]),
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

  void _showServiceEditor(BuildContext context, [ServiceModel? service]) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isEditing = service != null;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2DDED),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  isEditing ? 'Gestionar servicio' : 'Nuevo servicio',
                  style: const TextStyle(
                    color: providerDeep,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing
                      ? service.name
                      : 'El formulario completo queda pendiente para conectar con la tabla provider_services.',
                  style: const TextStyle(
                    color: providerMutedText,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6FD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE8E2F3)),
                  ),
                  child: const Text(
                    'Mientras usamos datos mock, la edición real se hará desde este mismo panel cuando conectemos el CRUD nuevo.',
                    style: TextStyle(color: providerMutedText, height: 1.35),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: providerPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Entendido'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
