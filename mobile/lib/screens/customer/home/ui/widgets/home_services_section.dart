import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/theme/app_theme_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../models/service/service_model.dart';

class HomeInicioPopularServicesList extends StatelessWidget {
  const HomeInicioPopularServicesList({required this.services, Key? key})
      : super(key: key);

  final List<ServiceModel> services;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      const mockServices = [
        _MockServiceData(
          name: 'Reparación de fugas de agua',
          category: 'Plomería',
          rating: '4.8',
          reviews: '128',
          emoji: '🚰',
        ),
        _MockServiceData(
          name: 'Instalación eléctrica',
          category: 'Electricidad',
          rating: '4.7',
          reviews: '96',
          emoji: '🔌',
        ),
        _MockServiceData(
          name: 'Limpieza profunda de casa',
          category: 'Limpieza',
          rating: '4.9',
          reviews: '152',
          emoji: '🪣',
        ),
      ];

      return Column(
        children: [
          for (final service in mockServices)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _MockServiceCard(service: service),
            ),
        ],
      );
    }

    return Column(
      children: services.map((service) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: HomeInicioCompactServiceCard(service: service),
        );
      }).toList(),
    );
  }
}

class HomeInicioCompactServiceCard extends StatelessWidget {
  const HomeInicioCompactServiceCard({required this.service, Key? key})
      : super(key: key);

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.serviceDetail,
            arguments: service,
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: _cardDecoration(context),
          child: Row(
            children: [
              const _ServiceThumb(emoji: '🛠️'),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: context.appTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      Helpers.getServiceCategoryName(service.category),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.appTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 9),
                    _ServiceMetaRow(
                      rating: service.rating.toStringAsFixed(1),
                      reviews: service.totalRatings.toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeInicioMoreServicesButton extends StatelessWidget {
  const HomeInicioMoreServicesButton({required this.onTap, Key? key})
      : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 230,
        height: 54,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Text(
            'Ver más servicios',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          label: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeInicioEmptyStateCard extends StatelessWidget {
  const HomeInicioEmptyStateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: context.appTextSecondary,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class HomeInicioHelpCard extends StatelessWidget {
  const HomeInicioHelpCard({required this.onTap, Key? key}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(context),
          child: Row(
            children: [
              const _ServiceThumb(emoji: '🎧'),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Necesitas ayuda?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: context.appTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nuestro equipo de soporte está listo para asistirte.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: context.appTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockServiceCard extends StatelessWidget {
  const _MockServiceCard({required this.service});

  final _MockServiceData service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(context),
      child: Row(
        children: [
          _ServiceThumb(emoji: service.emoji),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  service.category,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.appTextSecondary,
                  ),
                ),
                const SizedBox(height: 9),
                _ServiceMetaRow(
                  rating: service.rating,
                  reviews: service.reviews,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ServiceMetaRow extends StatelessWidget {
  const _ServiceMetaRow({
    required this.rating,
    required this.reviews,
  });

  final String rating;
  final String reviews;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          rating,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: context.appTextPrimary,
          ),
        ),
        Text(
          ' ($reviews)',
          style: TextStyle(
            fontSize: 14,
            color: context.appTextSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: context.appTextSecondary,
        ),
        const SizedBox(width: 2),
        Text(
          'Napo',
          style: TextStyle(
            fontSize: 13,
            color: context.appTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _ServiceThumb extends StatelessWidget {
  const _ServiceThumb({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: context.appCardShadow,
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 40)),
    );
  }
}

class _MockServiceData {
  const _MockServiceData({
    required this.name,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.emoji,
  });

  final String name;
  final String category;
  final String rating;
  final String reviews;
  final String emoji;
}

BoxDecoration _cardDecoration(BuildContext context) {
  return BoxDecoration(
    color: context.appSurface,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: context.appBorder),
    boxShadow: context.appCardShadow,
  );
}
