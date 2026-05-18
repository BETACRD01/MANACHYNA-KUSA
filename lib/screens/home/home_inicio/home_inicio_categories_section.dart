import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_colors.dart';

class HomeInicioCategoryGrid extends StatelessWidget {
  const HomeInicioCategoryGrid({
    required this.onNavigateToSearch,
    Key? key,
  }) : super(key: key);

  final Function({String? initialQuery, String? category}) onNavigateToSearch;

  @override
  Widget build(BuildContext context) {
    const categories = [
      _CategoryData('Limpieza', '🧹'),
      _CategoryData('Plomería', '🔧'),
      _CategoryData('Electricidad', '💡'),
      _CategoryData('Carpintería', '🔨'),
      _CategoryData('Pintura', '🎨'),
      _CategoryData('Jardinería', '🌿'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.83,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(
          category: category,
          onTap: () => onNavigateToSearch(category: category.name),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final _CategoryData category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(10, 16, 10, 14),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.appBorder),
            boxShadow: context.appCardShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      blurRadius: 18,
                      offset: const Offset(0, 9),
                    ),
                  ],
                ),
                child: Text(
                  category.emoji,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 44),
                ),
              ),
              const Spacer(),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: context.appTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData(this.name, this.emoji);

  final String name;
  final String emoji;
}
