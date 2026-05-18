import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_colors.dart';
import '../../../models/booking_model.dart';
import 'booking_reservas_data.dart';

class BookingReservaCard extends StatelessWidget {
  const BookingReservaCard({
    required this.item,
    required this.onDetail,
    required this.onCancel,
    required this.onRate,
    required this.onChat,
    required this.onReschedule,
    Key? key,
  }) : super(key: key);

  final BookingReservaItem item;
  final VoidCallback onDetail;
  final VoidCallback onCancel;
  final VoidCallback onRate;
  final VoidCallback onChat;
  final VoidCallback onReschedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingReservaArtworkBox(artwork: item.artwork),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.2,
                              fontWeight: FontWeight.w900,
                              color: context.appTextPrimary,
                            ),
                          ),
                        ),
                        const Icon(Icons.more_vert_rounded, size: 22),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        ProviderAvatar(name: item.providerName),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            item.providerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: context.appTextPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified_rounded,
                          size: 13,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${item.rating.toStringAsFixed(1)} (${item.reviews})',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.appTextSecondary,
                          ),
                        ),
                        const Spacer(),
                        BookingStatusChip(status: item.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetaLine(
                  icon: Icons.calendar_month_outlined,
                  label: item.dateLabel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetaLine(
                  icon: Icons.location_on_outlined,
                  label: item.location,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BookingCardActions(
            item: item,
            onDetail: onDetail,
            onCancel: onCancel,
            onRate: onRate,
            onChat: onChat,
            onReschedule: onReschedule,
          ),
        ],
      ),
    );
  }
}

class BookingReservaArtworkBox extends StatelessWidget {
  const BookingReservaArtworkBox({required this.artwork, Key? key})
      : super(key: key);

  final BookingReservaArtwork artwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? const Color(0xFF202820)
            : Color(artwork.background),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.appShadow,
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Text(
        artwork.emoji,
        style: const TextStyle(fontSize: 46),
      ),
    );
  }
}

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({required this.status, Key? key}) : super(key: key);

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final data = _StatusData.fromStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: context.isDarkMode ? data.darkBackground : data.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: data.color),
          const SizedBox(width: 6),
          Text(
            data.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: data.color,
            ),
          ),
        ],
      ),
    );
  }
}

class ProviderAvatar extends StatelessWidget {
  const ProviderAvatar({required this.name, Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final letter = name.trim().isEmpty ? 'P' : name.trim()[0].toUpperCase();
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: context.isDarkMode
            ? const LinearGradient(
                colors: [Color(0xFF245B31), Color(0xFF173821)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BookingCardActions extends StatelessWidget {
  const _BookingCardActions({
    required this.item,
    required this.onDetail,
    required this.onCancel,
    required this.onRate,
    required this.onChat,
    required this.onReschedule,
  });

  final BookingReservaItem item;
  final VoidCallback onDetail;
  final VoidCallback onCancel;
  final VoidCallback onRate;
  final VoidCallback onChat;
  final VoidCallback onReschedule;

  @override
  Widget build(BuildContext context) {
    if (item.status == BookingStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.calendar_month_outlined,
              label: 'Reprogramar',
              color: AppColors.primary,
              onTap: onReschedule,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionButton(
              icon: Icons.close_rounded,
              label: 'Cancelar',
              color: AppColors.error,
              onTap: onCancel,
            ),
          ),
        ],
      );
    }

    if (item.status == BookingStatus.completed) {
      return InkWell(
        onTap: onRate,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.appBorder),
          ),
          child: Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: context.appTextSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.booking?.rating == null
                      ? 'Calificaste este servicio'
                      : 'Tu calificación del servicio',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
              ),
              const Text(
                '★★★★★',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '5.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18),
            ],
          ),
        ),
      );
    }

    if (item.providerAssignedLabel != null) {
      return InkWell(
        onTap: onDetail,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.appBorder),
          ),
          child: Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: context.appTextPrimary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.providerAssignedLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.visibility_outlined,
            label: 'Ver detalle',
            color: AppColors.primary,
            onTap: onDetail,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chatear',
            color: AppColors.primary,
            filled: true,
            onTap: onChat,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              filled ? color.withValues(alpha: 0.10) : context.appSurface,
          foregroundColor: color,
          side:
              BorderSide(color: color.withValues(alpha: filled ? 0.08 : 0.45)),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: context.appTextPrimary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: context.appTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusData {
  const _StatusData({
    required this.label,
    required this.color,
    required this.background,
    required this.darkBackground,
  });

  final String label;
  final Color color;
  final Color background;
  final Color darkBackground;

  factory _StatusData.fromStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return const _StatusData(
          label: 'Pendiente',
          color: AppColors.warning,
          background: Color(0xFFFFF2E4),
          darkBackground: Color(0xFF332313),
        );
      case BookingStatus.confirmed:
      case BookingStatus.inProgress:
        return const _StatusData(
          label: 'Confirmada',
          color: AppColors.primary,
          background: Color(0xFFEAF6EB),
          darkBackground: Color(0xFF17301D),
        );
      case BookingStatus.completed:
        return const _StatusData(
          label: 'Finalizada',
          color: AppColors.textSecondary,
          background: Color(0xFFF0F1F0),
          darkBackground: Color(0xFF252A25),
        );
      case BookingStatus.cancelled:
        return const _StatusData(
          label: 'Cancelada',
          color: AppColors.error,
          background: Color(0xFFFFEEEE),
          darkBackground: Color(0xFF351717),
        );
    }
  }
}
