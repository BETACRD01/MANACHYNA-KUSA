import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_provider.dart';
import 'search_screen.dart';
import '../auth/profile_screen.dart'; // ✅ AGREGAR ESTE IMPORT

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).loadServices();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Método para navegar a la tab de búsqueda con parámetros
  void navigateToSearch({String? initialQuery, String? category}) {
    setState(() {
      _currentIndex = 1; // Tab de búsqueda
    });
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _HomeTab(onNavigateToSearch: navigateToSearch),
          const SearchScreen(),
          const _BookingsTab(),
          const ProfileScreen(), // ✅ CAMBIO: Usar ProfileScreen real en lugar de _ProfileTab
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: AppStrings.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: AppStrings.bookings,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final Function({String? initialQuery, String? category}) onNavigateToSearch;

  const _HomeTab({required this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 24),

            // Categorías de servicios
            _buildServiceCategories(context),
            const SizedBox(height: 24),

            // Servicios populares
            _buildPopularServices(context),
            const SizedBox(height: 24),

            // Proveedores destacados
            _buildFeaturedProviders(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Hola, ${user?.name ?? 'Usuario'}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '¿Qué servicio necesitas hoy?',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notificaciones próximamente'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildServiceCategories(BuildContext context) {
    // Solo las 4 categorías que ofreces + "Más"
    final categories = [
      {
        'name': 'Limpieza',
        'icon': Icons.cleaning_services,
        'category': 'Limpieza'
      },
      {'name': 'Plomería', 'icon': Icons.plumbing, 'category': 'Plomería'},
      {
        'name': 'Electricidad',
        'icon': Icons.electrical_services,
        'category': 'Electricidad'
      },
      {
        'name': 'Carpintería',
        'icon': Icons.handyman,
        'category': 'Carpintería'
      },
      {'name': 'Más', 'icon': Icons.more_horiz, 'category': null},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categorías',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                onNavigateToSearch();
              },
              child: const Text(
                'Ver todas',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Layout en fila horizontal para las 5 categorías
        Row(
          children: [
            // 4 categorías principales
            ...categories.take(4).map((category) => Expanded(
                  child: _buildCategoryItem(
                    context,
                    category['name'] as String,
                    category['icon'] as IconData,
                    category['category'] as String?,
                  ),
                )),
            // Botón "Más"
            Expanded(
              child: _buildCategoryItem(
                context,
                categories[4]['name'] as String,
                categories[4]['icon'] as IconData,
                null,
                isMore: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, String name, IconData icon, String? category,
      {bool isMore = false}) {
    return GestureDetector(
      onTap: () {
        if (isMore) {
          // Mostrar mensaje de próximas actualizaciones
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Más categorías próximamente'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Mostrar mensaje temporal de proveedores en desarrollo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Proveedores de $category próximamente'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isMore
                    ? Colors.grey[200]
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMore
                      ? Colors.grey[400]!
                      : AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                icon,
                color: isMore ? Colors.grey[600] : AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isMore ? Colors.grey[600] : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularServices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Servicios Populares',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                onNavigateToSearch();
              },
              child: const Text(
                'Ver todos',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 12),
                Text(
                  'Servicios populares',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'En desarrollo',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProviders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Proveedores Destacados',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 12),
                Text(
                  'Proveedores destacados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'En desarrollo',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
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

class _BookingsTab extends StatelessWidget {
  const _BookingsTab();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Pantalla de Reservas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'En desarrollo',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ ELIMINAR: Ya no necesitamos _ProfileTab porque usamos ProfileScreen directamente
