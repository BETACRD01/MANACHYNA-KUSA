import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;
import '../../core/utils/helpers.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/service_model.dart';
import '../../models/booking_model.dart';
// providers/auth_provider.dart

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({Key? key}) : super(key: key);

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTime;
  int _estimatedHours = 1;
  bool _isFirstLoad = true; // <-- Agrega este flag

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _loadUserAddress();
      _isFirstLoad = false;
    }
  }

  void _loadUserAddress() {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs == null) return const SizedBox.shrink();
    final service = routeArgs as ServiceModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Servicio'),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoading) {
            return const LoadingWidget(message: 'Creando reserva...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del servicio
                  _buildServiceInfo(service),
                  const SizedBox(height: 24),

                  // Selección de fecha
                  _buildDateSelection(),
                  const SizedBox(height: 20),

                  // Selección de hora
                  _buildTimeSelection(),
                  const SizedBox(height: 20),

                  // Duración estimada
                  _buildDurationSelection(),
                  const SizedBox(height: 20),

                  // Dirección del servicio
                  _buildAddressField(),
                  const SizedBox(height: 20),

                  // Notas adicionales
                  _buildNotesField(),
                  const SizedBox(height: 24),

                  // Resumen de precio
                  _buildPriceSummary(service),
                  const SizedBox(height: 32),

                  // Botón de confirmación
                  _buildConfirmButton(service),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceInfo(ServiceModel service) {
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1 * 255),
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
                  service.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service.providerName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${service.pricePerHour.toStringAsFixed(0)}/hora',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha del Servicio',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? app_date_utils.DateUtils.formatDateForDisplay(
                            _selectedDate!)
                        : 'Seleccionar fecha',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hora del Servicio',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedDate != null) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                app_date_utils.DateUtils.getAvailableTimeSlots().map((time) {
              final isSelected = _selectedTime == time;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedTime = time;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Selecciona una fecha primero',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDurationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Duración Estimada',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: _estimatedHours > 1
                  ? () {
                      setState(() {
                        _estimatedHours--;
                      });
                    }
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_estimatedHours ${_estimatedHours == 1 ? 'hora' : 'horas'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              onPressed: _estimatedHours < 8
                  ? () {
                      setState(() {
                        _estimatedHours++;
                      });
                    }
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return CustomTextField(
      label: 'Dirección del Servicio',
      controller: _addressController,
      validator: (value) => Validators.validateRequired(value, 'Dirección'),
      prefixIcon: Icons.location_on_outlined,
      isMultiline: true,
      maxLines: 2,
    );
  }

  Widget _buildNotesField() {
    return CustomTextField(
      label: 'Notas Adicionales (Opcional)',
      hint: 'Describe detalles específicos del trabajo...',
      controller: _notesController,
      prefixIcon: Icons.note_outlined,
      isMultiline: true,
      maxLines: 3,
    );
  }

  Widget _buildPriceSummary(ServiceModel service) {
    final subtotal = service.pricePerHour * _estimatedHours;
    final total = subtotal;

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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Precio por hora',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                Helpers.formatCurrency(service.pricePerHour),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duración ($_estimatedHours ${_estimatedHours == 1 ? 'hora' : 'horas'})',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'x $_estimatedHours',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                Helpers.formatCurrency(total),
                style: const TextStyle(
                  fontSize: 18,
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

  Widget _buildConfirmButton(ServiceModel service) {
    return CustomButton(
      text: 'Confirmar Reserva',
      onPressed: _canConfirmBooking() ? () => _confirmBooking(service) : null,
      icon: Icons.check_circle,
    );
  }

  bool _canConfirmBooking() {
    return _selectedDate != null &&
        _selectedTime != null &&
        _addressController.text.isNotEmpty;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null; // Reset time selection
      });
    }
  }

  Future<void> _confirmBooking(ServiceModel service) async {
    if (!_formKey.currentState!.validate() || !_canConfirmBooking()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user == null) {
      Helpers.showCustomSnackBar(
        context,
        message: 'Debes iniciar sesión para reservar',
        isError: true,
      );
      return;
    }

    final booking = BookingModel(
      id: '',
      clientId: user.id,
      clientProfileId: user.profileId,
      clientName: user.name,
      providerId: service.providerId,
      providerProfileId: service.providerProfileId,
      providerName: service.providerName,
      serviceId: service.catalogServiceId,
      serviceName: service.name,
      scheduledDate: _selectedDate!,
      scheduledTime: _selectedTime!,
      status: BookingStatus.pending,
      totalPrice: service.pricePerHour * _estimatedHours,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      address: _addressController.text.trim(),
      createdAt: DateTime.now(),
    );

    bool success = await bookingProvider.createBooking(booking);

    if (success && mounted) {
      final createdBooking =
          bookingProvider.bookings.isNotEmpty ? bookingProvider.bookings.first : booking;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.bookingDetail,
        arguments: createdBooking,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reserva creada exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(bookingProvider.errorMessage ?? 'Error al crear la reserva'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
