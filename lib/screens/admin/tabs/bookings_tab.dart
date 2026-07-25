part of '../admin_dashboard.dart';

class _BookingsTab extends StatefulWidget {
  final AdminRepository repository;
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  const _BookingsTab(
      {required this.repository,
      required this.statusFilter,
      required this.onStatusFilterChanged});

  @override
  State<_BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<_BookingsTab> {
  List<AdminBookingSummary> _bookings = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.repository
          .loadBookings(statusFilter: widget.statusFilter);
      if (!mounted) return;
      setState(() {
        _bookings = result.items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: context.appBackground,
          child: SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                {'key': 'all', 'label': 'Todas'},
                {'key': 'pending', 'label': 'Pendientes'},
                {'key': 'confirmed', 'label': 'Confirmadas'},
                {'key': 'in_progress', 'label': 'En curso'},
                {'key': 'completed', 'label': 'Completadas'},
                {'key': 'cancelled', 'label': 'Canceladas'},
              ]
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: f['label']!,
                          selected: widget.statusFilter == f['key'],
                          onTap: () => widget.onStatusFilterChanged(f['key']!),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingWidget(message: 'Cargando reservas...')
              : _error != null
                  ? _AdminErrorView(message: _error!, onRetry: _load)
                  : _bookings.isEmpty
                      ? _EmptyPanel(
                          text:
                              'No hay reservas ${widget.statusFilter == 'all' ? '' : 'con ese estado'}.')
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            itemCount: _bookings.length,
                            itemBuilder: (context, index) {
                              final b = _bookings[index];
                              return _BookingFullCard(booking: b);
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}

class _BookingFullCard extends StatelessWidget {
  final AdminBookingSummary booking;
  const _BookingFullCard({required this.booking});

  Color _statusColor() {
    switch (booking.status) {
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'in_progress':
        return AppColors.secondary;
      case 'confirmed':
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }

  IconData _statusIcon() {
    switch (booking.status) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'in_progress':
        return Icons.play_circle_rounded;
      case 'confirmed':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  String _statusLabel() {
    switch (booking.status) {
      case 'pending':
        return 'Pendiente';
      case 'confirmed':
        return 'Confirmada';
      case 'in_progress':
        return 'En curso';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return booking.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_statusIcon(), color: _statusColor(), size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.serviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: context.appTextPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 13, color: context.appTextSecondary),
                        const SizedBox(width: 4),
                        Text(booking.clientName,
                            style: TextStyle(
                                color: context.appTextSecondary, fontSize: 12)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward,
                            size: 12, color: context.appTextSecondary),
                        const SizedBox(width: 8),
                        Icon(Icons.engineering_outlined,
                            size: 13, color: context.appTextSecondary),
                        const SizedBox(width: 4),
                        Text(booking.providerName,
                            style: TextStyle(
                                color: context.appTextSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${booking.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: context.appTextPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 18)),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor().withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_statusLabel(),
                        style: TextStyle(
                            color: _statusColor(),
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
          if (booking.scheduledDate != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: context.appTextSecondary),
                const SizedBox(width: 6),
                Text(
                  '${booking.scheduledDate!.day}/${booking.scheduledDate!.month}/${booking.scheduledDate!.year}',
                  style:
                      TextStyle(color: context.appTextSecondary, fontSize: 12),
                ),
                const Spacer(),
                if (booking.createdAt != null)
                  Text(
                      'Creada: ${booking.createdAt!.day}/${booking.createdAt!.month}/${booking.createdAt!.year}',
                      style: TextStyle(
                          color: context.appTextSecondary, fontSize: 11)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
