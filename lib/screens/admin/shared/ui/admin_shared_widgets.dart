import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme_colors.dart';

import '../admin_colors.dart';

class AdminPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdminPageHeader({super.key, 
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                AdminBrandMark(),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MANACHYNA-KUSA',
                        style: TextStyle(
                          color: Color(0xFF3D248F),
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ADMINISTRACIÓN',
                        style: TextStyle(
                          color: adminMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminBell(),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: const TextStyle(
                color: adminDeep,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              style: const TextStyle(
                color: adminMuted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminBrandMark extends StatelessWidget {
  const AdminBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [adminPurple, Color(0xFF9D60FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 30),
    );
  }
}

class AdminBell extends StatelessWidget {
  const AdminBell({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Notificaciones',
      onPressed: () {},
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: adminDeep,
            size: 31,
          ),
          Positioned(
            right: -4,
            top: -7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: const BoxDecoration(
                color: adminPurple,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNav({super.key, 
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      AdminNavItem(Icons.home_rounded, 'Inicio'),
      AdminNavItem(Icons.people_outline_rounded, 'Usuarios'),
      AdminNavItem(Icons.business_center_outlined, 'Proveedores'),
      AdminNavItem(Icons.bar_chart_rounded, 'Reportes'),
      AdminNavItem(Icons.account_circle_outlined, 'Perfil'),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = index == currentIndex;
            final item = items[index];
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: selected ? adminPurple : adminMuted,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selected ? adminPurple : adminMuted,
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w900 : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AdminNavItem {
  final IconData icon;
  final String label;

  const AdminNavItem(this.icon, this.label);
}

BoxDecoration adminPanelDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0xFFF0EDF6)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.045),
        blurRadius: 22,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

String formatCount(int value, {required int fallback}) {
  final display = value > 0 ? value : fallback;
  return NumberFormat.decimalPattern('en_US').format(display);
}

String adminInitials(String name) {
  final parts =
      name.split(' ').where((part) => part.trim().isNotEmpty).take(2).toList();
  if (parts.isEmpty) return 'A';
  return parts.map((part) => part[0].toUpperCase()).join();
}

class AdminSearchBox extends StatelessWidget {
  final String hint;

  const AdminSearchBox({super.key, 
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: adminPanelDecoration(),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: adminMuted),
          prefixIcon:
              const Icon(Icons.search_rounded, color: adminMuted, size: 28),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

class AdminFilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AdminFilterButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: adminPanelDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list_rounded,
                color: adminPurple, size: 28),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: adminPurple,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminSegmentedFilters extends StatelessWidget {
  final List<String> values;
  final String selected;

  const AdminSegmentedFilters({super.key, 
    required this.values,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: values.map((value) {
          final isSelected = value == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [adminPurple, Color(0xFF7D35F0)],
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0xFFE2DDEC),
                  ),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: isSelected ? Colors.white : adminMuted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AdminLargeMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String trend;
  final Color color;

  const AdminLargeMetricCard({super.key, 
    required this.icon,
    required this.title,
    required this.value,
    required this.trend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: adminPanelDecoration(),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: color, size: 31),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: adminMuted, fontSize: 13),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: adminPurple,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  trend,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminPill extends StatelessWidget {
  final String label;
  final Color color;
  final bool dot;

  const AdminPill({super.key, 
    required this.label,
    required this.color,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSettingsLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool showDivider;
  final VoidCallback onTap;

  const AdminSettingsLine({super.key, 
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color = adminPurple,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 25),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: adminDeep,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: adminMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: color),
              ],
            ),
          ),
          if (showDivider) const Divider(height: 1, color: Color(0xFFE9E5F0)),
        ],
      ),
    );
  }
}

class AdminSystemStatus extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AdminSystemStatus({super.key, 
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.success, size: 28),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: adminDeep,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: adminMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminEmptyPanel extends StatelessWidget {
  final String text;
  const AdminEmptyPanel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56,
                color: context.appTextSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.appTextSecondary)),
          ],
        ),
      ),
    );
  }
}

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdminSectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: adminDeep,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: adminMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const AdminErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Error al cargar',
                style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: context.appTextSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
