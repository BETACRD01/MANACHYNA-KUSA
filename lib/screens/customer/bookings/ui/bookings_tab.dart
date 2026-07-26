import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../models/booking/booking_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/booking_provider.dart';
import '../data/booking_reservas_data.dart';
import 'widgets/booking_reservas_widgets.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_selectedIndex != _tabController.index) {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    }
  }

  Future<void> _loadBookings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) {
      return;
    }

    await bookingProvider.loadUserBookings(
      user.id,
      isProvider: user.hasProviderAccess,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Consumer<BookingProvider>(
          builder: (context, bookingProvider, child) {
            final bookings = bookingProvider.bookings;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      const BookingReservasHeader(),
                      const SizedBox(height: 18),
                      BookingReservasTabs(
                        controller: _tabController,
                        selectedIndex: _selectedIndex,
                      ),
                    ],
                  ),
                ),
                if (bookingProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: context.appPrimary,
                      backgroundColor: context.appSoftGreen,
                    ),
                  ),
                if (bookingProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: _BookingErrorBanner(
                      message: bookingProvider.errorMessage!,
                      onRetry: _loadBookings,
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent(
                        filter: BookingReservasFilter.all,
                        bookings: bookings,
                      ),
                      _buildTabContent(
                        filter: BookingReservasFilter.pending,
                        bookings: bookings
                            .where(
                              (booking) =>
                                  booking.status == BookingStatus.pending,
                            )
                            .toList(),
                      ),
                      _buildTabContent(
                        filter: BookingReservasFilter.confirmed,
                        bookings: bookings
                            .where(
                              (booking) =>
                                  booking.status == BookingStatus.confirmed ||
                                  booking.status == BookingStatus.inProgress,
                            )
                            .toList(),
                      ),
                      _buildTabContent(
                        filter: BookingReservasFilter.completed,
                        bookings: bookings
                            .where(
                              (booking) =>
                                  booking.status == BookingStatus.completed,
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required BookingReservasFilter filter,
    required List<BookingModel> bookings,
  }) {
    final items = bookings.map(BookingReservaItem.fromBooking).toList();
    return BookingReservasTabContent(
      filter: filter,
      items: items,
      totalBookings: bookings.length,
      onRefresh: _loadBookings,
      onDetail: _openBookingDetail,
      onCancel: _cancelBooking,
      onRate: _rateBooking,
      onChat: _openChat,
      onReschedule: _showComingSoon,
    );
  }

  void _openBookingDetail(BookingReservaItem item) {
    if (item.booking == null) {
      _showMockMessage('Detalle disponible cuando tengas reservas reales.');
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.bookingDetail,
      arguments: item.booking,
    );
  }

  void _openChat(BookingReservaItem item) {
    Navigator.pushNamed(context, AppRoutes.chat);
  }

  void _showComingSoon(BookingReservaItem item) {
    _showMockMessage('Reprogramación lista para conectar con reservas reales.');
  }

  void _showMockMessage(String message) {
    Helpers.showCustomSnackBar(context, message: message);
  }

  void _cancelBooking(BookingReservaItem item) {
    final booking = item.booking;
    if (booking == null) {
      _showMockMessage('Reserva mock: conecta datos reales para cancelar.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content:
            const Text('¿Estás seguro de que quieres cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final bookingProvider =
                  Provider.of<BookingProvider>(context, listen: false);
              final success = await bookingProvider.cancelBooking(
                booking.id,
                'Cancelado por el usuario',
              );

              if (success && mounted) {
                Helpers.showCustomSnackBar(
                  this.context,
                  message: 'Reserva cancelada',
                );
              }
            },
            child: const Text(
              'Sí, cancelar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _rateBooking(BookingReservaItem item) {
    final booking = item.booking;
    if (booking == null) {
      _showMockMessage('Reserva mock: conecta datos reales para calificar.');
      return;
    }

    double rating = 5.0;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Calificar servicio'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('¿Cómo fue tu experiencia?'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          rating = index + 1.0;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reviewController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu reseña (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final bookingProvider =
                      Provider.of<BookingProvider>(context, listen: false);
                  final success = await bookingProvider.rateBooking(
                    booking.id,
                    rating,
                    reviewController.text.trim().isEmpty
                        ? null
                        : reviewController.text.trim(),
                  );

                  if (success && mounted) {
                    Helpers.showCustomSnackBar(
                      this.context,
                      message: 'Gracias por tu calificación',
                    );
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingErrorBanner extends StatelessWidget {
  const _BookingErrorBanner({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? AppColors.error.withValues(alpha: 0.14)
            : const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
