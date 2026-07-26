import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../models/booking/booking_model.dart';
import '../../../../models/service/service_model.dart';
import '../../../../models/user/user_model.dart';
import '../../../../providers/notification_provider.dart';

const Color providerPurple = Color(0xFF6C2FE6);
const Color providerDeep = Color(0xFF13122F);
const Color providerShellBg = Color(0xFFF8F7FC);
const Color providerMutedText = Color(0xFF6B6885);

class ProviderAccessDenied extends StatelessWidget {
  const ProviderAccessDenied({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 58, color: AppColors.error),
            SizedBox(height: 14),
            Text(
              'Acceso denegado',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 6),
            Text(
              'Solo las cuentas aprobadas como proveedor pueden entrar aquí.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> slivers;
  final Widget? trailing;

  const ProviderPage({super.key, 
    required this.title,
    required this.subtitle,
    required this.slivers,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: ProviderHeader(
              title: title,
              subtitle: subtitle,
              trailing: trailing,
            ),
          ),
        ),
        ...slivers,
        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }
}

class ProviderHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const ProviderHeader({super.key, 
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ProviderBrandMark(),
              const SizedBox(width: 10),
              const Expanded(
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
                      'PROVEEDORES',
                      style: TextStyle(
                        color: providerMutedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ?? const ProviderBell(),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            title,
            style: const TextStyle(
              color: providerDeep,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: const TextStyle(
              color: providerMutedText,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderBrandMark extends StatelessWidget {
  const ProviderBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [providerPurple, Color(0xFF9D60FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 27),
    );
  }
}

class ProviderBell extends StatelessWidget {
  const ProviderBell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notifications, _) {
        final count =
            notifications.unreadCount > 0 ? notifications.unreadCount : 3;
        return IconButton(
          tooltip: 'Notificaciones',
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.notifications),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: providerDeep,
                size: 30,
              ),
              Positioned(
                right: -4,
                top: -7,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: const BoxDecoration(
                    color: providerPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
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
      },
    );
  }
}

class ProviderBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ProviderBottomNav({super.key, 
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      ProviderNavItem(Icons.home_rounded, 'Inicio'),
      ProviderNavItem(Icons.list_alt_rounded, 'Solicitudes'),
      ProviderNavItem(Icons.business_center_rounded, 'Servicios'),
      ProviderNavItem(Icons.fact_check_rounded, 'Trabajos'),
      ProviderNavItem(Icons.account_circle_outlined, 'Perfil'),
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
            blurRadius: 26,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = index == currentIndex;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: selected ? providerPurple : providerMutedText,
                        size: 28,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              selected ? providerPurple : providerMutedText,
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

class ProviderNavItem {
  final IconData icon;
  final String label;

  const ProviderNavItem(this.icon, this.label);
}

class ProviderFilterBar extends StatelessWidget {
  final Map<String, String> values;
  final String selected;
  final ValueChanged<String> onChanged;

  const ProviderFilterBar({super.key, 
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: Colors.transparent,
      height: 58,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: values.entries.map((entry) {
          final isSelected = selected == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              selectedColor: providerPurple,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : providerMutedText,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              side: BorderSide(
                color:
                    isSelected ? Colors.transparent : const Color(0xFFE4E0EC),
              ),
              onSelected: (_) => onChanged(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ProviderSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const ProviderSectionHeader({super.key, 
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
  });

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
                  color: providerDeep,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: providerMutedText, fontSize: 12),
              ),
            ],
          ),
        ),
        if (actionText != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionText!)),
      ],
    );
  }
}

class ProviderStatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const ProviderStatusPill({super.key, 
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class ProviderInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProviderInfoChip({super.key, 
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.appTextSecondary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.appTextSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderProfileHero extends StatelessWidget {
  final UserModel user;

  const ProviderProfileHero({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final displayName = user.name.isNotEmpty ? user.name : 'Servicios El Sol';
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: providerPanelDecoration(context),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 430;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFFFFF6DA),
                        backgroundImage: user.profileImageUrl != null &&
                                user.profileImageUrl!.isNotEmpty
                            ? NetworkImage(user.profileImageUrl!)
                            : null,
                        child: user.profileImageUrl == null ||
                                user.profileImageUrl!.isEmpty
                            ? const Icon(
                                Icons.wb_sunny_rounded,
                                color: AppColors.warning,
                                size: 52,
                              )
                            : null,
                      ),
                      const Positioned(
                        right: -2,
                        bottom: 5,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.success,
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: providerDeep,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Hogar y mantenimiento',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: providerMutedText,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              user.rating > 0
                                  ? user.rating.toStringAsFixed(1)
                                  : '4.8',
                              style: const TextStyle(
                                color: providerDeep,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                '(128 reseñas)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: providerMutedText),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.editProfile),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar perfil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: providerPurple,
                        side: const BorderSide(color: Color(0xFFE4DDF2)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 430) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.editProfile),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar perfil'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: providerPurple,
                      side: const BorderSide(color: Color(0xFFE4DDF2)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          const Divider(height: 1, color: Color(0xFFE9E5F0)),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: ProfileStat(
                    icon: Icons.business_center_outlined,
                    value: '12',
                    label: 'Servicios'),
              ),
              VerticalDividerLite(),
              Expanded(
                child: ProfileStat(
                    icon: Icons.fact_check_outlined,
                    value: '158',
                    label: 'Trabajos'),
              ),
              VerticalDividerLite(),
              Expanded(
                child: ProfileStat(
                    icon: Icons.star_border_rounded,
                    value: '128',
                    label: 'Reseñas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ProfileStat({super.key, 
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: providerPurple, size: 26),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            color: providerDeep,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(label, style: const TextStyle(color: providerMutedText)),
      ],
    );
  }
}

class VerticalDividerLite extends StatelessWidget {
  const VerticalDividerLite({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 66, color: const Color(0xFFE9E5F0));
  }
}

class ProfileInfoPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const ProfileInfoPanel({super.key, 
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: providerPurple, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: providerDeep,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class ProfileLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: providerPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: providerMutedText, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleRow extends StatelessWidget {
  final String day;
  final String time;

  const ScheduleRow({super.key, required this.day, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(day, style: const TextStyle(color: providerMutedText)),
          ),
          Text(time,
              style: const TextStyle(
                  color: providerDeep, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class ResponseBadge extends StatelessWidget {
  const ResponseBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, color: AppColors.success, size: 16),
          SizedBox(width: 6),
          Text(
            'Responde en menos de 1 hora',
            style: TextStyle(
                color: AppColors.success, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class ChipWrap extends StatelessWidget {
  final List<String> labels;

  const ChipWrap({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels
          .map(
            (label) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: providerPurple.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: providerPurple,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class DocLine extends StatelessWidget {
  final String label;
  final String value;

  const DocLine({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final completed = value.toLowerCase().contains('complet');
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Expanded(
            child:
                Text(label, style: const TextStyle(color: providerMutedText)),
          ),
          if (completed) ...[
            const Icon(Icons.check_circle_outline_rounded,
                color: AppColors.success, size: 18),
            const SizedBox(width: 6),
          ],
          Text(
            value,
            style: TextStyle(
              color: completed ? AppColors.success : providerDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const SettingsLine({super.key, 
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? providerMutedText;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color ?? providerDeep,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: itemColor, size: 20),
          ],
        ),
      ),
    );
  }
}

class ProviderEmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProviderEmptyState({super.key, 
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 54,
                color: context.appTextSecondary.withValues(alpha: 0.55)),
            const SizedBox(height: 14),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class ProviderErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const ProviderErrorState({super.key, 
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 52),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appTextSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration providerPanelDecoration(BuildContext context) {
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

Color providerBookingStatusColor(BookingStatus status) {
  switch (status) {
    case BookingStatus.pending:
      return AppColors.warning;
    case BookingStatus.confirmed:
      return AppColors.info;
    case BookingStatus.inProgress:
      return AppColors.primary;
    case BookingStatus.completed:
      return AppColors.success;
    case BookingStatus.cancelled:
      return AppColors.error;
  }
}

String providerFormatMoney(double value) {
  final hasDecimals = value.truncateToDouble() != value;
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: 'S/ ',
    decimalDigits: hasDecimals ? 2 : 0,
  ).format(value);
}

List<BookingModel> mockProviderBookings() {
  final now = DateTime.now();
  return [
    BookingModel(
      id: 'mock-1',
      clientId: 'mock-client-1',
      clientProfileId: 'mock-profile-1',
      clientName: 'Juan Pérez',
      providerId: 'mock-provider',
      providerName: 'Servicios El Sol',
      serviceId: 'mock-service-1',
      serviceName: 'Reparación de fuga',
      scheduledDate: now,
      scheduledTime: '9:15 a. m.',
      status: BookingStatus.pending,
      totalPrice: 120,
      address: 'Baño principal',
      createdAt: now,
    ),
    BookingModel(
      id: 'mock-2',
      clientId: 'mock-client-2',
      clientProfileId: 'mock-profile-2',
      clientName: 'María Quispe',
      providerId: 'mock-provider',
      providerName: 'Servicios El Sol',
      serviceId: 'mock-service-2',
      serviceName: 'Instalación eléctrica',
      scheduledDate: now,
      scheduledTime: '8:30 a. m.',
      status: BookingStatus.confirmed,
      totalPrice: 280,
      address: 'Interruptores y tomas',
      createdAt: now,
    ),
    BookingModel(
      id: 'mock-3',
      clientId: 'mock-client-3',
      clientProfileId: 'mock-profile-3',
      clientName: 'Carlos Ramírez',
      providerId: 'mock-provider',
      providerName: 'Servicios El Sol',
      serviceId: 'mock-service-3',
      serviceName: 'Armado de mueble',
      scheduledDate: now.subtract(const Duration(days: 1)),
      scheduledTime: '5:45 p. m.',
      status: BookingStatus.completed,
      totalPrice: 150,
      address: 'Ropero 6 puertas',
      createdAt: now,
    ),
    BookingModel(
      id: 'mock-4',
      clientId: 'mock-client-4',
      clientProfileId: 'mock-profile-4',
      clientName: 'Lucía Fernández',
      providerId: 'mock-provider',
      providerName: 'Servicios El Sol',
      serviceId: 'mock-service-4',
      serviceName: 'Pintura de sala',
      scheduledDate: now.subtract(const Duration(days: 1)),
      scheduledTime: '3:20 p. m.',
      status: BookingStatus.confirmed,
      totalPrice: 350,
      address: 'Color blanco hueso',
      createdAt: now,
    ),
  ];
}

List<ServiceModel> mockProviderServices(UserModel user) {
  final now = DateTime.now();
  return [
    ServiceModel(
      id: 'mock-service-1',
      catalogServiceId: 'mock-catalog-1',
      name: 'Carpintería residencial',
      description: 'Fabricación e instalación de muebles y acabados en madera.',
      category: ServiceCategory.carpentry,
      pricePerHour: 180,
      providerId: user.id,
      providerProfileId: user.providerProfileId ?? 'mock-provider-profile',
      providerName: user.name,
      isActive: true,
      createdAt: now,
      estimatedDuration: 180,
    ),
    ServiceModel(
      id: 'mock-service-2',
      catalogServiceId: 'mock-catalog-2',
      name: 'Reparaciones eléctricas',
      description: 'Diagnóstico y reparación de fallas eléctricas en el hogar.',
      category: ServiceCategory.electricity,
      pricePerHour: 150,
      providerId: user.id,
      providerProfileId: user.providerProfileId ?? 'mock-provider-profile',
      providerName: user.name,
      isActive: true,
      createdAt: now,
      estimatedDuration: 120,
    ),
    ServiceModel(
      id: 'mock-service-3',
      catalogServiceId: 'mock-catalog-3',
      name: 'Instalaciones de plomería',
      description:
          'Instalación y mantenimiento de tuberías, grifería y desagües.',
      category: ServiceCategory.plumbing,
      pricePerHour: 200,
      providerId: user.id,
      providerProfileId: user.providerProfileId ?? 'mock-provider-profile',
      providerName: user.name,
      isActive: true,
      createdAt: now,
      estimatedDuration: 240,
    ),
    ServiceModel(
      id: 'mock-service-4',
      catalogServiceId: 'mock-catalog-4',
      name: 'Pintura interior',
      description: 'Pintado de interiores con acabados de calidad.',
      category: ServiceCategory.other,
      pricePerHour: 120,
      providerId: user.id,
      providerProfileId: user.providerProfileId ?? 'mock-provider-profile',
      providerName: user.name,
      isActive: false,
      createdAt: now,
      estimatedDuration: 300,
    ),
  ];
}
