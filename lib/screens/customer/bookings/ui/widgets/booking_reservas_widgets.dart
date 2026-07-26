import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_theme_colors.dart';
import 'booking_reserva_card.dart';
import '../../data/booking_reservas_data.dart';

class BookingReservasHeader extends StatelessWidget {
  const BookingReservasHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mis reservas',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gestiona tus servicios programados',
                style: TextStyle(
                  fontSize: 13,
                  color: context.appTextSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: context.appSurface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.appShadow,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.tune_rounded,
            color: context.appTextPrimary,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class BookingReservasTabs extends StatelessWidget {
  const BookingReservasTabs({
    required this.controller,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);

  final TabController controller;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final selectedColor = _accentForIndex(selectedIndex);
    return Container(
      height: 52,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: selectedColor.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(14),
        ),
        labelPadding: EdgeInsets.zero,
        labelColor: selectedColor,
        unselectedLabelColor: context.appTextPrimary,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Todas'),
          Tab(text: 'Pendientes'),
          Tab(text: 'Confirmadas'),
          Tab(text: 'Finalizadas'),
        ],
      ),
    );
  }

  Color _accentForIndex(int index) {
    switch (index) {
      case 1:
        return AppColors.warning;
      case 3:
        return const Color(0xFF4A4D42);
      default:
        return AppColors.primary;
    }
  }
}

class BookingReservasTabContent extends StatelessWidget {
  const BookingReservasTabContent({
    required this.filter,
    required this.items,
    required this.totalBookings,
    required this.onRefresh,
    required this.onDetail,
    required this.onCancel,
    required this.onRate,
    required this.onChat,
    required this.onReschedule,
    Key? key,
  }) : super(key: key);

  final BookingReservasFilter filter;
  final List<BookingReservaItem> items;
  final int totalBookings;
  final Future<void> Function() onRefresh;
  final ValueChanged<BookingReservaItem> onDetail;
  final ValueChanged<BookingReservaItem> onCancel;
  final ValueChanged<BookingReservaItem> onRate;
  final ValueChanged<BookingReservaItem> onChat;
  final ValueChanged<BookingReservaItem> onReschedule;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          BookingReservasSummaryCard(
            filter: filter,
            count: _summaryCount,
          ),
          const SizedBox(height: 16),
          for (final item in _visibleItems)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: BookingReservaCard(
                item: item,
                onDetail: () => onDetail(item),
                onCancel: () => onCancel(item),
                onRate: () => onRate(item),
                onChat: () => onChat(item),
                onReschedule: () => onReschedule(item),
              ),
            ),
          if (filter == BookingReservasFilter.pending)
            const BookingReservaInfoBanner(
              tone: BookingReservaBannerTone.warning,
              icon: Icons.notifications_none_rounded,
              title: 'Esperando confirmación',
              subtitle:
                  'Te notificaremos cuando el proveedor confirme tu reserva.',
            ),
          if (filter == BookingReservasFilter.confirmed)
            const BookingReservaInfoBanner(
              tone: BookingReservaBannerTone.success,
              icon: Icons.shield_outlined,
              title: 'Pago seguro',
              subtitle: 'El pago se realiza al finalizar el servicio.',
            ),
          if (filter == BookingReservasFilter.completed)
            const BookingReservaInfoBanner(
              tone: BookingReservaBannerTone.neutral,
              icon: Icons.thumb_up_alt_outlined,
              title: 'Tu opinión nos ayuda',
              subtitle:
                  'Sigue calificando para que más personas encuentren proveedores confiables.',
            ),
        ],
      ),
    );
  }

  List<BookingReservaItem> get _visibleItems {
    if (items.isNotEmpty) {
      return items;
    }
    return bookingReservasMockItems(filter);
  }

  int get _summaryCount {
    if (items.isEmpty) {
      return bookingReservasMockItems(filter).length;
    }
    if (filter == BookingReservasFilter.all) {
      return totalBookings;
    }
    return items.length;
  }
}

class BookingReservasSummaryCard extends StatelessWidget {
  const BookingReservasSummaryCard({
    required this.filter,
    required this.count,
    Key? key,
  }) : super(key: key);

  final BookingReservasFilter filter;
  final int count;

  @override
  Widget build(BuildContext context) {
    final data = _SummaryData.fromFilter(filter, count);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.isDarkMode ? data.darkBackground : data.background,
            context.appSurface,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: data.accent.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: context.appSurface.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.accent, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: data.accent,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          _SummaryArtwork(filter: filter),
        ],
      ),
    );
  }
}

class BookingReservaInfoBanner extends StatelessWidget {
  const BookingReservaInfoBanner({
    required this.tone,
    required this.icon,
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  final BookingReservaBannerTone tone;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final data = _BannerData.fromTone(tone);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.isDarkMode ? data.darkBackground : data.background,
            context.appSurface,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: data.accent, size: 34),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: data.accent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: context.appTextPrimary,
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

enum BookingReservaBannerTone { success, warning, neutral }

class _SummaryArtwork extends StatelessWidget {
  const _SummaryArtwork({required this.filter});

  final BookingReservasFilter filter;

  @override
  Widget build(BuildContext context) {
    final icon = _iconForFilter(filter);
    final color = _colorForFilter(filter);
    return SizedBox(
      width: 82,
      height: 58,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              icon,
              size: 54,
              color: color.withValues(alpha: 0.75),
            ),
          ),
          Positioned(
            left: 12,
            top: 8,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: color.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForFilter(BookingReservasFilter filter) {
    switch (filter) {
      case BookingReservasFilter.pending:
        return Icons.assignment_outlined;
      case BookingReservasFilter.completed:
        return Icons.thumb_up_alt_outlined;
      case BookingReservasFilter.all:
      case BookingReservasFilter.confirmed:
        return Icons.house_siding_rounded;
    }
  }

  Color _colorForFilter(BookingReservasFilter filter) {
    switch (filter) {
      case BookingReservasFilter.pending:
        return AppColors.warning;
      case BookingReservasFilter.completed:
        return const Color(0xFF4A4D42);
      case BookingReservasFilter.all:
      case BookingReservasFilter.confirmed:
        return AppColors.primary;
    }
  }
}

class _SummaryData {
  const _SummaryData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.background,
    required this.darkBackground,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color background;
  final Color darkBackground;

  factory _SummaryData.fromFilter(BookingReservasFilter filter, int count) {
    switch (filter) {
      case BookingReservasFilter.all:
        return _SummaryData(
          title: '$count reservas activas',
          subtitle: 'Próxima visita hoy, 3:30 PM',
          icon: Icons.event_available_rounded,
          accent: AppColors.primary,
          background: const Color(0xFFEFF8EE),
          darkBackground: const Color(0xFF17301D),
        );
      case BookingReservasFilter.pending:
        return _SummaryData(
          title: '$count reservas pendientes',
          subtitle: 'Tienes servicios por confirmar',
          icon: Icons.schedule_rounded,
          accent: AppColors.warning,
          background: const Color(0xFFFFF2E4),
          darkBackground: const Color(0xFF332313),
        );
      case BookingReservasFilter.confirmed:
        return _SummaryData(
          title: '$count reservas confirmadas',
          subtitle: 'Todo listo para tu servicio',
          icon: Icons.check_circle_outline_rounded,
          accent: AppColors.primary,
          background: const Color(0xFFEFF8EE),
          darkBackground: const Color(0xFF17301D),
        );
      case BookingReservasFilter.completed:
        return _SummaryData(
          title: '$count reservas finalizadas',
          subtitle: '¡Gracias por confiar en nosotros!',
          icon: Icons.star_border_rounded,
          accent: const Color(0xFF4A4D42),
          background: const Color(0xFFF3F4F1),
          darkBackground: const Color(0xFF252A25),
        );
    }
  }
}

class _BannerData {
  const _BannerData({
    required this.accent,
    required this.background,
    required this.darkBackground,
  });

  final Color accent;
  final Color background;
  final Color darkBackground;

  factory _BannerData.fromTone(BookingReservaBannerTone tone) {
    switch (tone) {
      case BookingReservaBannerTone.success:
        return const _BannerData(
          accent: AppColors.primary,
          background: Color(0xFFEFF8EE),
          darkBackground: Color(0xFF17301D),
        );
      case BookingReservaBannerTone.warning:
        return const _BannerData(
          accent: AppColors.warning,
          background: Color(0xFFFFF2E4),
          darkBackground: Color(0xFF332313),
        );
      case BookingReservaBannerTone.neutral:
        return const _BannerData(
          accent: Color(0xFF4A4D42),
          background: Color(0xFFF3F4F1),
          darkBackground: Color(0xFF252A25),
        );
    }
  }
}
