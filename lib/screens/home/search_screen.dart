// lib/screens/home/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/error_widget.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const SearchScreen({
    Key? key,
    this.initialQuery,
    this.initialCategory,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  late TabController _tabController;
  String _selectedCategory = 'Todos';
  String _selectedLocation = 'Todas las ubicaciones';
  RangeValues _priceRange = const RangeValues(10, 200);
  double _selectedRating = 0;
  bool _isAvailableNow = false;

  // Lista de categorías de servicios
  final List<String> _categories = [
    'Todos',
    'Limpieza',
    'Jardinería',
    'Plomería',
    'Electricidad',
    'Pintura',
    'Carpintería',
    'Otros'
  ];

  // Lista de ubicaciones de Quito
  final List<String> _locations = [
    'Todas las ubicaciones',
    'Centro Norte',
    'La Carolina',
    'Cumbayá',
    'Valle de los Chillos',
    'Sur de Quito',
    'Calderón',
    'Sangolquí',
    'Tumbaco',
    'Conocoto',
    'Centro Histórico',
    'La Floresta',
    'Quicentro',
    'El Bosque',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Aplicar parámetros iniciales si existen
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
    if (widget.initialCategory != null && widget.initialCategory != 'Más') {
      _selectedCategory = widget.initialCategory!;
    }

    // Cargar servicios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceProvider = context.read<ServiceProvider>();
      serviceProvider.loadServices();

      // Realizar búsqueda inicial si hay parámetros
      if (widget.initialQuery != null || widget.initialCategory != null) {
        _performSearch();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final serviceProvider = context.read<ServiceProvider>();
    serviceProvider.setSearchQuery(_searchController.text);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'Todos';
      _selectedLocation = 'Todas las ubicaciones';
      _priceRange = const RangeValues(10, 200);
      _selectedRating = 0;
      _isAvailableNow = false;
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Buscar Servicios',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
        actions: [
          IconButton(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpiar filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda principal
          _buildSearchBar(),

          // Tabs para vista rápida y filtros avanzados
          _buildTabBar(),

          // Contenido de las tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuickSearchView(),
                _buildAdvancedFiltersView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Buscar servicios, proveedores...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _performSearch();
                    }
                  },
                  onSubmitted: (value) => _performSearch(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _performSearch,
                  icon: const Icon(Icons.search, color: Colors.white),
                  tooltip: 'Buscar',
                ),
              ),
            ],
          ),

          // Chips de filtros activos
          if (_hasActiveFilters()) ...[
            const SizedBox(height: 12),
            _buildActiveFiltersChips(),
          ],
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategory != 'Todos' ||
        _selectedLocation != 'Todas las ubicaciones' ||
        _priceRange.start != 10 ||
        _priceRange.end != 200 ||
        _selectedRating > 0 ||
        _isAvailableNow;
  }

  Widget _buildActiveFiltersChips() {
    List<Widget> chips = [];

    if (_selectedCategory != 'Todos') {
      chips.add(_buildFilterChip('Categoría: $_selectedCategory', () {
        setState(() => _selectedCategory = 'Todos');
        _performSearch();
      }));
    }

    if (_selectedLocation != 'Todas las ubicaciones') {
      chips.add(_buildFilterChip('Ubicación: $_selectedLocation', () {
        setState(() => _selectedLocation = 'Todas las ubicaciones');
        _performSearch();
      }));
    }

    if (_priceRange.start != 10 || _priceRange.end != 200) {
      chips.add(_buildFilterChip(
        'Precio: \$${_priceRange.start.toInt()}-\$${_priceRange.end.toInt()}',
        () {
          setState(() => _priceRange = const RangeValues(10, 200));
          _performSearch();
        },
      ));
    }

    if (_selectedRating > 0) {
      chips.add(_buildFilterChip('Min ${_selectedRating.toInt()}⭐', () {
        setState(() => _selectedRating = 0);
        _performSearch();
      }));
    }

    if (_isAvailableNow) {
      chips.add(_buildFilterChip('Disponible ahora', () {
        setState(() => _isAvailableNow = false);
        _performSearch();
      }));
    }

    return Wrap(
      spacing: 8,
      children: chips,
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDelete,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      deleteIconColor: AppColors.primary,
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        indicatorColor: AppColors.primary,
        tabs: const [
          Tab(
            icon: Icon(Icons.list_alt),
            text: 'Resultados',
          ),
          Tab(
            icon: Icon(Icons.filter_list),
            text: 'Filtros',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearchView() {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        if (serviceProvider.isLoading) {
          return const LoadingWidget();
        }

        final services = serviceProvider.services;

        return Column(
          children: [
            // Estadísticas de búsqueda
            _buildSearchStats(services.length),

            // Resultados de búsqueda directamente (SIN categorías populares)
            Expanded(
              child: services.isEmpty
                  ? _buildEmptyState()
                  : _buildServicesList(services),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchStats(int totalResults) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '$totalResults servicio${totalResults != 1 ? 's' : ''} encontrado${totalResults != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _tabController.animateTo(1),
            icon: const Icon(Icons.tune, size: 16),
            label: const Text('Filtros', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<ServiceModel> services) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.serviceDetail,
              arguments: service,
            );
          },
          borderRadius: BorderRadius.circular(16),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(service.category.name),
                    color: AppColors.primary,
                    size: 32,
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
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.providerName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            service.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.location_on,
                            color: AppColors.textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _getServiceLocation(service),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Precio y estado
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${service.pricePerHour.toStringAsFixed(0)}/h',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getServiceAvailability(service)
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getServiceAvailability(service)
                            ? 'Disponible'
                            : 'Ocupado',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getServiceAvailability(service)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getServiceLocation(ServiceModel service) {
    final locations = [
      'Centro Norte',
      'La Carolina',
      'Cumbayá',
      'Valle de los Chillos',
      'Sur de Quito',
      'Calderón',
      'Sangolquí'
    ];
    return locations[service.id.hashCode % locations.length];
  }

  bool _getServiceAvailability(ServiceModel service) {
    return service.rating > 3.5;
  }

  Widget _buildAdvancedFiltersView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de filtros
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: AppColors.primary,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Refina tu búsqueda con filtros avanzados',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Filtros por categoría
          _buildFilterSection(
            'Categoría de servicio',
            Icons.category,
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixIcon: const Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
                _performSearch();
              },
            ),
          ),

          // Filtros por ubicación
          _buildFilterSection(
            'Ubicación',
            Icons.location_on,
            DropdownButtonFormField<String>(
              initialValue: _selectedLocation,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixIcon: const Icon(Icons.location_on),
              ),
              items: _locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value!;
                });
                _performSearch();
              },
            ),
          ),

          // Filtro de precio
          _buildFilterSection(
            'Rango de precio por hora',
            Icons.attach_money,
            Column(
              children: [
                RangeSlider(
                  values: _priceRange,
                  min: 5,
                  max: 500,
                  divisions: 99,
                  activeColor: AppColors.primary,
                  labels: RangeLabels(
                    '\$${_priceRange.start.toInt()}',
                    '\$${_priceRange.end.toInt()}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                  onChangeEnd: (values) {
                    _performSearch();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Desde \$${_priceRange.start.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Hasta \$${_priceRange.end.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filtro de calificación
          _buildFilterSection(
            'Calificación mínima',
            Icons.star,
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRating = index + 1.0;
                        });
                        _performSearch();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.star,
                          color: index < _selectedRating
                              ? Colors.amber
                              : Colors.grey[300],
                          size: 32,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                if (_selectedRating > 0)
                  Text(
                    'Mínimo ${_selectedRating.toInt()} estrella${_selectedRating > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Disponibilidad inmediata
          _buildFilterSection(
            'Disponibilidad',
            Icons.schedule,
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('Disponible ahora'),
                subtitle: const Text(
                    'Solo mostrar servicios disponibles inmediatamente'),
                value: _isAvailableNow,
                activeThumbColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _isAvailableNow = value;
                  });
                  _performSearch();
                },
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.clear_all, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Limpiar filtros',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _tabController.animateTo(0);
                    _performSearch();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Ver resultados',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, IconData icon, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.search_off,
      message:
          'No se encontraron servicios\n\nIntenta ajustar tus criterios de búsqueda o explora nuestras categorías',
      actionText: 'Limpiar filtros',
      onAction: () => _clearFilters(),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'limpieza':
        return Icons.cleaning_services;
      case 'jardinería':
        return Icons.yard;
      case 'plomería':
        return Icons.plumbing;
      case 'electricidad':
        return Icons.electrical_services;
      case 'pintura':
        return Icons.format_paint;
      case 'carpintería':
        return Icons.handyman;
      default:
        return Icons.build;
    }
  }
}
