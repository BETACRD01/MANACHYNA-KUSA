import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/utils/helpers.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs == null) return const SizedBox.shrink();
    final booking = routeArgs as BookingModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Reserva'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Compartir detalles de la reserva
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado de la reserva
            _buildStatusCard(booking),
            const SizedBox(height: 20),

            // Información del servicio
            _buildServiceInfo(booking),
            const SizedBox(height: 20),

            // Detalles de la cita
            _buildAppointmentDetails(booking),
            const SizedBox(height: 20),

            // Información de contacto
            _buildContactInfo(booking),
            const SizedBox(height: 20),

            // Resumen de precio
            _buildPriceSummary(booking),
            const SizedBox(height: 20),

            // Notas adicionales
            if (booking.notes != null) ...[
              _buildNotes(booking),
              const SizedBox(height: 20),
            ],

            // Calificación (si existe)
            if (booking.rating != null) ...[
              _buildRating(booking),
              const SizedBox(height: 20),
            ],

            // Acciones
            _buildActions(context, booking),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BookingModel booking) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String statusText = Helpers.getBookingStatusName(booking.status);

    switch (booking.status) {
      case BookingStatus.pending:
        backgroundColor = AppColors.warning;
        textColor = Colors.white;
        icon = Icons.schedule;
        break;
      case BookingStatus.confirmed:
        backgroundColor = AppColors.info;
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case BookingStatus.inProgress:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        icon = Icons.work;
        break;
      case BookingStatus.completed:
        backgroundColor = AppColors.success;
        textColor = Colors.white;
        icon = Icons.done_all;
        break;
      case BookingStatus.cancelled:
        backgroundColor = AppColors.error;
        textColor = Colors.white;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusDescription(booking.status),
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfo(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información del Servicio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.home_repair_service,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.serviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Proveedor: ${booking.providerName}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetails(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles de la Cita',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.calendar_today,
            'Fecha',
            Helpers.formatDate(booking.scheduledDate),
          ),
          _buildDetailRow(
            Icons.access_time,
            'Hora',
            booking.scheduledTime,
          ),
          _buildDetailRow(
            Icons.location_on,
            'Dirección',
            booking.address ?? 'No especificada',
          ),
          _buildDetailRow(
            Icons.event_note,
            'Creado',
            Helpers.formatDateTime(booking.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Contacto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.providerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Proveedor de servicios',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: AppColors.primary),
                onPressed: () {
                  // Llamar al proveedor
                },
              ),
              IconButton(
                icon: const Icon(Icons.message, color: AppColors.primary),
                onPressed: () {
                  // Enviar mensaje
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de Precio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total del servicio',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                Helpers.formatCurrency(booking.totalPrice),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notas Adicionales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            booking.notes!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating(BookingModel booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tu Calificación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < booking.rating!.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 24,
                );
              }),
              const SizedBox(width: 12),
              Text(
                booking.rating!.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (booking.review != null) ...[
            const SizedBox(height: 12),
            Text(
              booking.review!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, BookingModel booking) {
    List<Widget> actions = [];

    if (booking.status == BookingStatus.pending) {
      actions.add(
        CustomButton(
          text: 'Cancelar Reserva',
          onPressed: () => _cancelBooking(context, booking),
          backgroundColor: AppColors.error,
          isOutlined: true,
        ),
      );
    }

    if (booking.status == BookingStatus.completed && booking.rating == null) {
      actions.add(
        CustomButton(
          text: 'Calificar Servicio',
          onPressed: () => _rateService(context, booking),
          icon: Icons.star,
        ),
      );
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: actions.map((action) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: action,
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Esperando confirmación del proveedor';
      case BookingStatus.confirmed:
        return 'Reserva confirmada por el proveedor';
      case BookingStatus.inProgress:
        return 'Servicio en progreso';
      case BookingStatus.completed:
        return 'Servicio completado exitosamente';
      case BookingStatus.cancelled:
        return 'Reserva cancelada';
    }
  }

  void _cancelBooking(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
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
              if (!context.mounted) return;

              final bookingProvider =
                  Provider.of<BookingProvider>(context, listen: false);
              bool success = await bookingProvider.cancelBooking(
                booking.id,
                'Cancelado por el usuario',
              );

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reserva cancelada'),
                    backgroundColor: AppColors.success,
                  ),
                );
                Navigator.pop(context);
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

  void _rateService(BuildContext context, BookingModel booking) {
    // Implementar calificación del servicio
    // Similar a la implementación en booking_list_screen.dart
  }
}
