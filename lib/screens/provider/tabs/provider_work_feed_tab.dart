part of '../provider_dashboard.dart';

class _ProviderWorkFeedTab extends StatelessWidget {
  final String categoryFilter;
  final ValueChanged<String> onCategoryChanged;

  const _ProviderWorkFeedTab({
    required this.categoryFilter,
    required this.onCategoryChanged,
  });

  static const _categories = [
    'Todas',
    'Limpieza',
    'Plomería',
    'Electricidad',
    'Jardinería',
    'Pintura',
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Consumer<CustomTaskProvider>(
      builder: (context, taskProvider, _) {
        final openTasks = taskProvider.getOpenTasks();
        final tasks = categoryFilter == 'Todas'
            ? openTasks
            : openTasks
                .where((task) => task.category == categoryFilter)
                .toList();

        return Column(
          children: [
            _ProviderFilterBar(
              values: {for (final category in _categories) category: category},
              selected: categoryFilter,
              onChanged: onCategoryChanged,
            ),
            Expanded(
              child: tasks.isEmpty
                  ? const _ProviderEmptyState(
                      icon: Icons.work_outline_rounded,
                      text: 'No hay trabajos abiertos en esta categoría.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final hasOffer = user != null &&
                            task.offers
                                .any((offer) => offer.providerId == user.id);
                        return _ProviderTaskCard(
                          task: task,
                          hasOffer: hasOffer,
                          onBid: user == null || hasOffer
                              ? null
                              : () => _showBidSheet(context, task, user),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showBidSheet(
      BuildContext context, CustomTaskModel task, UserModel user) {
    final priceController =
        TextEditingController(text: task.budget.toStringAsFixed(0));
    final messageController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: context.appBorder,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Enviar propuesta',
                    style: TextStyle(
                      color: context.appTextPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.title,
                    style: TextStyle(color: context.appTextSecondary),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tarifa ofertada',
                      prefixIcon: Icon(Icons.attach_money_rounded),
                    ),
                    validator: (value) {
                      final price = double.tryParse(value ?? '');
                      if (price == null || price <= 0) {
                        return 'Ingresa un valor válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Mensaje para el cliente',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().length < 10) {
                        return 'Describe brevemente tu propuesta.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            context.read<CustomTaskProvider>().submitOffer(
                                  taskId: task.id,
                                  providerId: user.id,
                                  providerName: user.name,
                                  providerRating: user.rating,
                                  priceOffer:
                                      double.parse(priceController.text),
                                  message: messageController.text.trim(),
                                );
                            Navigator.pop(sheetContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Propuesta enviada correctamente'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Enviar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
