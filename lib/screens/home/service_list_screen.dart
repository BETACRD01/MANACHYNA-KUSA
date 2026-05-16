import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/error_widget.dart';
import '../../core/utils/helpers.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final _searchController = TextEditingController();
  String _sortBy = 'rating';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).loadServices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          _buildSearchBar(),

          // Filtros de categoría
          _buildCategoryFilters(),

          // Lista de servicios
          Expanded(
            child: Consumer<ServiceProvider>(
              builder: (context, serviceProvider, child) {
                if (serviceProvider.isLoading) {
                  return const LoadingWidget(message: 'Cargando servicios...');
                }

                if (serviceProvider.errorMessage != null) {
                  return CustomErrorWidget(
                    message: serviceProvider.errorMessage!,
                    onRetry: () => serviceProvider.loadServices(),
                  );
                }

                final services = serviceProvider.services;

                if (services.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No se encontraron servicios',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Intenta con otros filtros de búsqueda',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return _buildServiceCard(services[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar servicios...',
          hintStyle: const TextStyle(color: AppColors.textHint),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<ServiceProvider>(context, listen: false)
                        .setSearchQuery('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          Provider.of<ServiceProvider>(context, listen: false)
              .setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<ServiceProvider>(
        builder: (context, serviceProvider, child) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryChip('Todos', null, serviceProvider),
              _buildCategoryChip(
                  'Limpieza', ServiceCategory.cleaning, serviceProvider),
              _buildCategoryChip(
                  'Plomería', ServiceCategory.plumbing, serviceProvider),
              _buildCategoryChip(
                  'Electricidad', ServiceCategory.electricity, serviceProvider),
              _buildCategoryChip(
                  'Carpintería', ServiceCategory.carpentry, serviceProvider),
              _buildCategoryChip(
                  'Jardinería', ServiceCategory.gardening, serviceProvider),
              _buildCategoryChip(
                  'Otros', ServiceCategory.other, serviceProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    ServiceCategory? category,
    ServiceProvider serviceProvider,
  ) {
    final isSelected = serviceProvider.selectedCategory == category;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          serviceProvider.setCategory(selected ? category : null);
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.divider,
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ]),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.serviceDetail,
            arguments: service,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen del servicio
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.home_repair_service,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 16),

              // Información del servicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.providerName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            Helpers.getServiceCategoryName(service.category),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              service.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${service.totalRatings})',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Precio
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${service.pricePerHour.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    'por hora',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ordenar por'),
        content: RadioGroup<String>(
          groupValue: _sortBy,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _sortBy = value;
            });
            Navigator.pop(context);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Calificación'),
                value: 'rating',
              ),
              RadioListTile<String>(
                title: Text('Precio (menor a mayor)'),
                value: 'price_asc',
              ),
              RadioListTile<String>(
                title: Text('Precio (mayor a menor)'),
                value: 'price_desc',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
