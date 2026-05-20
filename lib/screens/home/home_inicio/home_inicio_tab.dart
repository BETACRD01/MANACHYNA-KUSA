import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/service_provider.dart';
import 'home_inicio_categories_section.dart';
import 'home_inicio_hero_section.dart';
import 'home_inicio_services_section.dart';

class HomeInicioTab extends StatelessWidget {
  const HomeInicioTab({required this.onNavigateToSearch, Key? key})
      : super(key: key);

  final Function({String? initialQuery, String? category}) onNavigateToSearch;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ServiceProvider>(
      builder: (context, authProvider, serviceProvider, child) {
        final services = serviceProvider.services;
        final popularServices = serviceProvider.getPopularServices().isNotEmpty
            ? serviceProvider.getPopularServices()
            : services.take(5).toList();

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () => serviceProvider.loadServices(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        HomeInicioHeroSection(
                          userName: authProvider.currentUser?.name ?? 'Usuario',
                          onSearchTap: () => onNavigateToSearch(),
                        ),
                        const SizedBox(height: 26),
                        HomeInicioSectionHeader(
                          title: 'Categorías',
                          actionLabel: 'Ver todas',
                          onActionTap: () => onNavigateToSearch(),
                        ),
                        const SizedBox(height: 14),
                        HomeInicioCategoryGrid(
                          onNavigateToSearch: onNavigateToSearch,
                        ),
                        const SizedBox(height: 26),
                        HomeInicioSafetyCard(
                          servicesCount: services.length,
                        ),
                        const SizedBox(height: 26),
                        HomeInicioQuickStats(servicesCount: services.length),
                        const SizedBox(height: 26),
                        HomeInicioHelpCard(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.chat,
                          ),
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          'Servicios para tu hogar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0E151B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const HomeInicioTrustFeatureRow(),
                        const SizedBox(height: 26),
                        HomeInicioPromoCard(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.customTaskForm,
                          ),
                        ),
                        const SizedBox(height: 28),
                        HomeInicioSectionHeader(
                          title: 'Servicios populares',
                          actionLabel: 'Ver todos',
                          onActionTap: () => onNavigateToSearch(),
                        ),
                        const SizedBox(height: 14),
                        if (serviceProvider.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 36, bottom: 18),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (serviceProvider.errorMessage != null)
                          HomeInicioEmptyStateCard(
                            icon: Icons.cloud_off_rounded,
                            title: 'No pudimos cargar los servicios',
                            subtitle: serviceProvider.errorMessage!,
                            actionLabel: 'Reintentar',
                            onTap: () => serviceProvider.loadServices(),
                          )
                        else if (popularServices.isEmpty)
                          const HomeInicioPopularServicesList(services: [])
                        else
                          HomeInicioPopularServicesList(
                            services: popularServices.take(3).toList(),
                          ),
                        const SizedBox(height: 12),
                        HomeInicioMoreServicesButton(
                          onTap: () => onNavigateToSearch(),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
