part of '../admin_dashboard.dart';

class _ProvidersTab extends StatefulWidget {
  final AdminRepository repository;
  final String? busyProviderId;
  final TextEditingController searchCtrl;
  final String statusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final ValueChanged<String?> onAction;
  final VoidCallback onActionDone;
  final ValueChanged<String> onError;

  const _ProvidersTab({
    required this.repository,
    required this.busyProviderId,
    required this.searchCtrl,
    required this.statusFilter,
    required this.onStatusFilterChanged,
    required this.onAction,
    required this.onActionDone,
    required this.onError,
  });

  @override
  State<_ProvidersTab> createState() => _ProvidersTabState();
}

class _ProvidersTabState extends State<_ProvidersTab> {
  List<AdminProvider> _providers = [];
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
      final result = await widget.repository.loadProviders(
        search: widget.searchCtrl.text,
        statusFilter: widget.statusFilter,
      );
      if (!mounted) return;
      setState(() {
        _providers = result.items;
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

  Future<void> _doAction(AdminProvider provider, String action) async {
    widget.onAction(provider.id);
    try {
      if (action == 'approve') {
        await widget.repository.approveProvider(provider.id);
      } else if (action == 'suspend') {
        await widget.repository.suspendProvider(provider.id);
      } else {
        await widget.repository.reactivateProvider(provider.id);
      }
      widget.onActionDone();
      widget.onError('Proveedor actualizado correctamente');
      await _load();
    } catch (e) {
      widget.onError('Error: $e');
      widget.onAction(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: context.appBackground,
          child: Column(
            children: [
              TextField(
                controller: widget.searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Buscar proveedor...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 22),
                  suffixIcon: widget.searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            widget.searchCtrl.clear();
                            _load();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: context.appMutedSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _load(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['all', 'pending', 'approved', 'suspended']
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _FilterChip(
                              label: f == 'all'
                                  ? 'Todos'
                                  : f == 'pending'
                                      ? 'Pendientes'
                                      : f == 'approved'
                                          ? 'Activos'
                                          : 'Pausados',
                              selected: widget.statusFilter == f,
                              onTap: () => widget.onStatusFilterChanged(f),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const LoadingWidget(message: 'Cargando proveedores...')
              : _error != null
                  ? _AdminErrorView(message: _error!, onRetry: _load)
                  : _providers.isEmpty
                      ? _EmptyPanel(
                          text: widget.searchCtrl.text.isNotEmpty
                              ? 'Sin resultados para "${widget.searchCtrl.text}"'
                              : 'No hay proveedores registrados.')
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            itemCount: _providers.length,
                            itemBuilder: (context, index) {
                              final p = _providers[index];
                              return _ProviderFullCard(
                                provider: p,
                                isBusy: widget.busyProviderId == p.id,
                                onApprove: () => _doAction(p, 'approve'),
                                onSuspend: () => _doAction(p, 'suspend'),
                                onReactivate: () => _doAction(p, 'reactivate'),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : context.appMutedSurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
              color: selected ? Colors.white : context.appTextSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            )),
      ),
    );
  }
}

class _ProviderFullCard extends StatelessWidget {
  final AdminProvider provider;
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onSuspend;
  final VoidCallback onReactivate;

  const _ProviderFullCard({
    required this.provider,
    required this.isBusy,
    required this.onApprove,
    required this.onSuspend,
    required this.onReactivate,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = provider.isPending
        ? AppColors.warning
        : provider.isSuspended
            ? AppColors.error
            : AppColors.success;
    final statusLabel = provider.isPending
        ? 'Pendiente'
        : provider.isSuspended
            ? 'Pausado'
            : 'Activo';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appElevatedSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: [
          BoxShadow(
              color: context.appShadow,
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: context.appSoftGreen,
                child: Text(
                  provider.name.isNotEmpty
                      ? provider.name[0].toUpperCase()
                      : 'P',
                  style: TextStyle(
                      color: context.appPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: context.appTextPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                        provider.email.isNotEmpty
                            ? provider.email
                            : provider.phone,
                        style: TextStyle(
                            color: context.appTextSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(statusLabel,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                  icon: Icons.place_outlined,
                  text:
                      provider.city.isNotEmpty ? provider.city : 'Sin ciudad'),
              _InfoChip(
                  icon: Icons.star_rounded,
                  text: provider.rating.toStringAsFixed(1)),
              _InfoChip(
                  icon: Icons.rate_review_outlined,
                  text: '${provider.reviewsCount} reseñas'),
              if (provider.createdAt != null)
                _InfoChip(
                    icon: Icons.calendar_today_outlined,
                    text: _formatDate(provider.createdAt!)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (provider.isPending || provider.isSuspended)
                Expanded(
                  child: _AdminActionButton(
                    label: provider.isPending ? 'Aprobar' : 'Reactivar',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    isBusy: isBusy,
                    onPressed: provider.isPending ? onApprove : onReactivate,
                  ),
                ),
              if (provider.isPending || provider.isSuspended)
                const SizedBox(width: 10),
              if (!provider.isSuspended)
                Expanded(
                  child: _AdminActionButton(
                    label: provider.isPending ? 'Rechazar' : 'Pausar',
                    icon: Icons.pause_circle_outline_rounded,
                    color: AppColors.warning,
                    isBusy: isBusy,
                    onPressed: onSuspend,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.appMutedSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.appTextSecondary),
          const SizedBox(width: 5),
          Text(text,
              style: TextStyle(color: context.appTextSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AdminActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isBusy;
  final VoidCallback onPressed;
  const _AdminActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isBusy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isBusy ? null : onPressed,
      icon: isBusy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
