part of '../provider_dashboard.dart';

class _ProviderAccessDenied extends StatelessWidget {
  const _ProviderAccessDenied();

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

class _ProviderFilterBar extends StatelessWidget {
  final Map<String, String> values;
  final String selected;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry outerPadding;

  const _ProviderFilterBar({
    required this.values,
    required this.selected,
    required this.onChanged,
    this.outerPadding = const EdgeInsets.fromLTRB(16, 12, 16, 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: outerPadding,
      color: context.appBackground,
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
              selectedColor: AppColors.primary,
              backgroundColor: context.appMutedSurface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : context.appTextSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected ? Colors.transparent : context.appBorder,
              ),
              onSelected: (_) => onChanged(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProviderSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const _ProviderSectionHeader({
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
                style: TextStyle(
                  color: context.appTextPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: context.appTextSecondary, fontSize: 12),
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

class _ProviderStatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _ProviderStatusPill({
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

class _ProviderInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProviderInfoChip({
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

class _ProviderMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProviderMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _providerPanelDecoration(context),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            color: context.appTextPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _ProviderEmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? actionText;
  final VoidCallback? onAction;

  const _ProviderEmptyState({
    required this.icon,
    required this.text,
    this.actionText,
    this.onAction,
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
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProviderErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ProviderErrorState({
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

BoxDecoration _providerPanelDecoration(BuildContext context) {
  return BoxDecoration(
    color: context.appElevatedSurface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: context.appBorder),
    boxShadow: [
      BoxShadow(
        color: context.appShadow,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

Color _bookingStatusColor(BookingStatus status) {
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

IconData _taskCategoryIcon(String category) {
  switch (category) {
    case 'Limpieza':
      return Icons.cleaning_services_rounded;
    case 'Plomería':
      return Icons.water_drop_rounded;
    case 'Electricidad':
      return Icons.bolt_rounded;
    case 'Jardinería':
      return Icons.yard_rounded;
    case 'Pintura':
      return Icons.format_paint_rounded;
    default:
      return Icons.assignment_rounded;
  }
}

String _money(double value) {
  return NumberFormat.currency(locale: 'es_EC', symbol: r'$').format(value);
}

String _timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
  return 'Hace ${diff.inDays} d';
}
