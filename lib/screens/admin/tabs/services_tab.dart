part of '../admin_dashboard.dart';

class _ServicesTab extends StatefulWidget {
  final AdminRepository repository;
  final VoidCallback onRefresh;
  const _ServicesTab({required this.repository, required this.onRefresh});

  @override
  State<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<_ServicesTab> {
  List<AdminServiceSummary> _services = [];
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
      final services = await widget.repository.loadServices();
      if (!mounted) return;
      setState(() {
        _services = services;
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

  Future<void> _toggleService(AdminServiceSummary service) async {
    try {
      await widget.repository
          .toggleServiceStatus(service.id, !service.isActive);
      widget.onRefresh();
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const LoadingWidget(message: 'Cargando servicios...')
        : _error != null
            ? _AdminErrorView(message: _error!, onRetry: _load)
            : _services.isEmpty
                ? const _EmptyPanel(text: 'No hay servicios registrados.')
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        final s = _services[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.appElevatedSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.appBorder),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                    Icons.miscellaneous_services_outlined,
                                    color: AppColors.primary,
                                    size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(s.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: context.appTextPrimary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15)),
                                    const SizedBox(height: 2),
                                    Text(s.category,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: context.appTextSecondary,
                                            fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 8,
                                      children: [
                                        _MiniStat(
                                            text:
                                                '${s.providerCount} proveedores'),
                                        _MiniStat(
                                            text: '${s.bookingCount} reservas'),
                                        if (s.basePrice > 0)
                                          _MiniStat(
                                              text:
                                                  '\$${s.basePrice.toStringAsFixed(0)}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: s.isActive,
                                activeThumbColor: AppColors.primary,
                                onChanged: (_) => _toggleService(s),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
  }
}
