// lib/screens/home/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/loading_widget.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Buscar servicios',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _tabController.animateTo(1);
            },
            icon: Icon(Icons.tune, color: theme.colorScheme.primary),
            tooltip: 'Filtros',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark ? const Color(0xFF2B332D) : Colors.grey[100],
          ),
        ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black54 : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Buscar servicios, proveedor...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (value) {
                      _performSearch();
                    },
                    onSubmitted: (value) => _performSearch(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _performSearch,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
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
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
      ),
      deleteIcon: Icon(Icons.close, size: 16, color: theme.colorScheme.primary),
      onDeleted: onDelete,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      deleteIconColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
    );
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child: TabBar(
        controller: _tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
        indicatorColor: theme.colorScheme.primary,
        indicatorWeight: 3,
        dividerColor: theme.dividerColor,
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list_alt, size: 20),
                SizedBox(width: 8),
                Text('Resultados'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.filter_list, size: 20),
                SizedBox(width: 8),
                Text('Filtros'),
              ],
            ),
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

        final rawServices = serviceProvider.services;

        // Filtrar localmente según el estado de los filtros locales
        final services = rawServices.where((service) {
          // 1. Categoría
          if (_selectedCategory != 'Todos') {
            final categoryEnum = _mapStringToCategory(_selectedCategory);
            if (categoryEnum == null || service.category != categoryEnum) {
              return false;
            }
          }
          // 2. Ubicación
          if (_selectedLocation != 'Todas las ubicaciones') {
            final serviceLoc = _getServiceLocation(service);
            if (serviceLoc.toLowerCase() != _selectedLocation.toLowerCase()) {
              return false;
            }
          }
          // 3. Rango de precio
          if (service.pricePerHour < _priceRange.start || service.pricePerHour > _priceRange.end) {
            return false;
          }
          // 4. Calificación
          if (_selectedRating > 0 && service.rating < _selectedRating) {
            return false;
          }
          // 5. Disponibilidad
          if (_isAvailableNow && !_getServiceAvailability(service)) {
            return false;
          }
          return true;
        }).toList();

        if (services.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            // Tarjeta de estadísticas (X servicios encontrados)
            _buildStatsCard(services.length),

            // Resultados de búsqueda
            Expanded(
              child: _buildServicesList(services),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(int count) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2420) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count servicio${count != 1 ? 's' : ''} encontrado${count != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: () {
              _tabController.animateTo(1); // Cambiar a la pestaña de Filtros
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<ServiceModel> services) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black.withValues(alpha: 0.05),
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
                // Imagen o icono de la categoría
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(service.category.name),
                    color: theme.colorScheme.primary,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.providerName,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.location_on,
                            color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _getServiceLocation(service),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
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
      'Sangolquí',
      'Napo',
      'Tena',
      'Archidona'
    ];
    return locations[service.id.hashCode % locations.length];
  }

  bool _getServiceAvailability(ServiceModel service) {
    return service.rating > 3.5;
  }

  Widget _buildAdvancedFiltersView() {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de filtros
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Refina tu búsqueda con filtros avanzados',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
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
              dropdownColor: theme.cardColor,
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
                  child: Text(
                    category,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
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
              dropdownColor: theme.cardColor,
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
                  child: Text(
                    location,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
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
                  activeColor: theme.colorScheme.primary,
                  inactiveColor: theme.colorScheme.primary.withValues(alpha: 0.2),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Hasta \$${_priceRange.end.toInt()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
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
                              : (theme.brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[300]),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
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
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  'Disponible ahora',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                subtitle: Text(
                  'Solo mostrar servicios disponibles inmediatamente',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary),
                ),
                value: _isAvailableNow,
                activeThumbColor: theme.colorScheme.primary,
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
                    side: BorderSide(color: theme.colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.clear_all, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Limpiar filtros',
                        style: TextStyle(color: theme.colorScheme.primary),
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
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: theme.colorScheme.onPrimary),
                      const SizedBox(width: 8),
                      const Text(
                        'Ver resultados',
                        style: TextStyle(fontWeight: FontWeight.w600),
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
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Tarjeta de estadísticas (0 servicios encontrados)
          _buildStatsCard(0),

          const SizedBox(height: 24),

          // Ilustración vectorial en Flutter
          const HouseSearchIllustration(),

          const SizedBox(height: 24),

          // Título y Subtítulo
          Text(
            'No se encontraron servicios',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Intenta ajustar tus criterios de búsqueda o explora nuestras categorías',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Chips de categorías rápidas
          _buildQuickCategoriesRow(),

          const SizedBox(height: 16),

          // Botones de acción inferiores
          _buildActionButtons(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuickCategoriesRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _buildQuickCategoryItem('Limpieza', Icons.cleaning_services_outlined),
          _buildQuickCategoryItem('Plomería', Icons.plumbing_outlined),
          _buildQuickCategoryItem('Electricidad', Icons.electrical_services_outlined),
        ],
      ),
    );
  }

  Widget _buildQuickCategoryItem(String label, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = label;
          _tabController.animateTo(0); // Volver a Resultados
        });
        _performSearch();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          // Limpiar filtros (Filled green)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: Icon(Icons.tune_outlined, color: theme.colorScheme.onPrimary, size: 20),
              label: Text(
                'Limpiar filtros',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Explorar categorías (Outlined green)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: _exploreCategories,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: theme.cardColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Explorar categorías',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exploreCategories() {
    setState(() {
      _selectedCategory = 'Todos';
      _tabController.animateTo(1); // Mover a la pestaña de Filtros
    });
  }

  ServiceCategory? _mapStringToCategory(String value) {
    switch (value) {
      case 'Limpieza':
        return ServiceCategory.cleaning;
      case 'Plomería':
        return ServiceCategory.plumbing;
      case 'Carpintería':
        return ServiceCategory.carpentry;
      case 'Electricidad':
        return ServiceCategory.electricity;
      case 'Jardinería':
        return ServiceCategory.gardening;
      case 'Otros':
      case 'Pintura':
        return ServiceCategory.other;
      default:
        return null;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cleaning':
      case 'limpieza':
        return Icons.cleaning_services;
      case 'gardening':
      case 'jardinería':
        return Icons.yard;
      case 'plumbing':
      case 'plomería':
        return Icons.plumbing;
      case 'electricity':
      case 'electricidad':
        return Icons.electrical_services;
      case 'painting':
      case 'pintura':
        return Icons.format_paint;
      case 'carpentry':
      case 'carpintería':
        return Icons.handyman;
      default:
        return Icons.build;
    }
  }
}

// ==========================================
// Widgets y Painters de Ilustración Vectorial
// ==========================================

class HouseSearchIllustration extends StatelessWidget {
  const HouseSearchIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return SizedBox(
      height: 180,
      width: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Nube trasera izquierda
          Positioned(
            top: 20,
            left: 30,
            child: Icon(
              Icons.cloud_rounded,
              size: 45,
              color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04),
            ),
          ),
          // Nube trasera derecha
          Positioned(
            top: 35,
            right: 40,
            child: Icon(
              Icons.cloud_rounded,
              size: 35,
              color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04),
            ),
          ),
          
          // Silueta de la casa (dibujada con CustomPaint)
          Positioned(
            bottom: 10,
            child: CustomPaint(
              size: const Size(130, 110),
              painter: _HousePainter(isDark: isDark),
            ),
          ),
          
          // Lupa grande superpuesta (dibujada con CustomPaint)
          Positioned(
            bottom: 0,
            right: 15,
            child: CustomPaint(
              size: const Size(90, 90),
              painter: _MagnifyingGlassPainter(isDark: isDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _HousePainter extends CustomPainter {
  final bool isDark;
  _HousePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paintHouse = Paint()
      ..color = isDark ? const Color(0xFF1E2820) : const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;

    final paintDetails = Paint()
      ..color = isDark ? const Color(0xFF111612) : Colors.white
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = isDark ? const Color(0xFF2E3D31) : const Color(0xFFC8E6C9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Cuerpo de la casa (rectángulo)
    final houseRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(20, 45, 90, 65),
      const Radius.circular(8),
    );
    canvas.drawRRect(houseRect, paintHouse);
    canvas.drawRRect(houseRect, paintStroke);

    // Techo (triángulo)
    final pathRoof = Path()
      ..moveTo(10, 45)
      ..lineTo(65, 5)
      ..lineTo(120, 45)
      ..close();
    canvas.drawPath(pathRoof, paintHouse);
    canvas.drawPath(pathRoof, paintStroke);

    // Ventana central
    const windowRect = Rect.fromLTWH(50, 55, 30, 30);
    canvas.drawRect(windowRect, paintDetails);
    
    final paintWindowFrame = Paint()
      ..color = isDark ? const Color(0xFF2E3D31) : const Color(0xFFC8E6C9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(windowRect, paintWindowFrame);
    
    // Divisiones de la ventana
    canvas.drawLine(const Offset(65, 55), const Offset(65, 85), paintWindowFrame);
    canvas.drawLine(const Offset(50, 70), const Offset(80, 70), paintWindowFrame);

    // Arbustos laterales (Círculos verdes traslapados)
    final paintBush = Paint()
      ..color = (isDark ? const Color(0xFF2E7D32) : const Color(0xFFA5D6A7)).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(const Offset(15, 100), 18, paintBush);
    canvas.drawCircle(const Offset(115, 100), 22, paintBush);
    canvas.drawCircle(const Offset(125, 105), 15, paintBush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MagnifyingGlassPainter extends CustomPainter {
  final bool isDark;
  _MagnifyingGlassPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Sombra de la lupa
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: isDark ? 0.3 : 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      Offset(size.width * 0.45 + 3, size.height * 0.45 + 3),
      size.width * 0.35,
      shadowPaint,
    );

    final greenPrimaryColor = isDark ? const Color(0xFF4CAF50) : const Color(0xFF1B5E20);

    final framePaint = Paint()
      ..color = greenPrimaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final lensPaint = Paint()
      ..color = (isDark ? const Color(0xFF4CAF50) : const Color(0xFFC8E6C9)).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final handlePaint = Paint()
      ..color = greenPrimaryColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    final double cx = size.width * 0.45;
    final double cy = size.height * 0.45;
    final double radius = size.width * 0.32;

    // Lente
    canvas.drawCircle(Offset(cx, cy), radius, lensPaint);
    // Marco
    canvas.drawCircle(Offset(cx, cy), radius, framePaint);

    // Mango de la lupa
    final double startX = cx + radius * 0.707;
    final double startY = cy + radius * 0.707;
    final double endX = size.width * 0.95;
    final double endY = size.height * 0.95;
    
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), handlePaint);

    // Brillo en el cristal
    final glarePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius * 0.7);
    canvas.drawArc(rect, 3.14 + 0.5, 1.0, false, glarePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
