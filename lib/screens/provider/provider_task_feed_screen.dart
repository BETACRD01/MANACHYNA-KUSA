import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/utils/helpers.dart';
import '../../models/custom_task_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/custom_task_provider.dart';

class ProviderTaskFeedScreen extends StatefulWidget {
  const ProviderTaskFeedScreen({Key? key}) : super(key: key);

  @override
  State<ProviderTaskFeedScreen> createState() => _ProviderTaskFeedScreenState();
}

class _ProviderTaskFeedScreenState extends State<ProviderTaskFeedScreen> {
  String _selectedCategory = 'Todas';

  final List<String> _categories = [
    'Todas',
    'Limpieza',
    'Plomería',
    'Electricidad',
    'Jardinería',
    'Pintura',
  ];

  IconData _getCategoryIcon(String category) {
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

  String _getFictionalDistance(String taskId) {
    // Generar una distancia simulada según el ID de la tarea
    final hash = taskId.hashCode % 10;
    final dist = (hash * 0.7) + 0.8;
    return '${dist.toStringAsFixed(1)} km';
  }

  String _getTimeAgo(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} h';
    } else {
      return 'Hace ${diff.inDays} d';
    }
  }

  void _showBidBottomSheet(CustomTaskModel task) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) {
      Helpers.showCustomSnackBar(context,
          message: 'Inicia sesión para hacer una oferta.', isError: true);
      return;
    }

    final priceController =
        TextEditingController(text: task.budget.toStringAsFixed(0));
    final messageController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: context.appBorder,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.gavel_rounded,
                              color: AppColors.primary, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Enviar Propuesta',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: context.appTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tarea: ${task.title}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.appTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Precio Ofertado
                      Text(
                        'Tu Tarifa Ofertada (\$)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.appTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: context.appTextPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Monto en USD',
                          hintStyle: TextStyle(
                              color: context.appTextSecondary
                                  .withValues(alpha: 0.5)),
                          prefixIcon: const Icon(Icons.attach_money,
                              color: AppColors.primary),
                          filled: true,
                          fillColor: context.appMutedSurface,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: context.appBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: context.appBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Por favor ingresa un precio.';
                          }
                          final price = double.tryParse(val);
                          if (price == null || price <= 0) {
                            return 'Monto inválido (debe ser mayor a 0).';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Mensaje
                      Text(
                        'Mensaje de Presentación',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.appTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: messageController,
                        maxLines: 3,
                        style: TextStyle(color: context.appTextPrimary),
                        decoration: InputDecoration(
                          hintText:
                              'Ej: Estimado cliente, tengo amplia experiencia en esta área y dispongo de herramientas profesionales. Puedo ayudarle el día pactado sin inconvenientes.',
                          hintStyle: TextStyle(
                              color: context.appTextSecondary
                                  .withValues(alpha: 0.5)),
                          filled: true,
                          fillColor: context.appMutedSurface,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: context.appBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: context.appBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Por favor ingresa una breve propuesta.';
                          }
                          if (val.trim().length < 10) {
                            return 'Tu mensaje debe ser un poco más descriptivo.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Botones de acción
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                foregroundColor: context.appTextPrimary,
                                side: BorderSide(color: context.appBorder),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Cancelar',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!formKey.currentState!.validate()) return;

                                final customTaskProvider =
                                    Provider.of<CustomTaskProvider>(
                                        this.context,
                                        listen: false);
                                customTaskProvider.submitOffer(
                                  taskId: task.id,
                                  providerId: user.id,
                                  providerName: user.name,
                                  providerRating: user.rating,
                                  priceOffer:
                                      double.parse(priceController.text),
                                  message: messageController.text.trim(),
                                );

                                Navigator.pop(context); // Cierra bottom sheet

                                Helpers.showCustomSnackBar(
                                  this.context,
                                  message:
                                      '¡Propuesta enviada con éxito! El cliente la revisará pronto.',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text('Enviar Oferta',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text('Tareas Disponibles'),
        elevation: 0,
        backgroundColor: context.appSurface,
        foregroundColor: context.appTextPrimary,
      ),
      body: Consumer<CustomTaskProvider>(
        builder: (context, taskProvider, child) {
          final openTasks = taskProvider.getOpenTasks();

          // Filtrado por categoría
          List<CustomTaskModel> filteredTasks = [];
          if (_selectedCategory == 'Todas') {
            filteredTasks = openTasks;
          } else {
            filteredTasks = openTasks
                .where((t) => t.category == _selectedCategory)
                .toList();
          }

          return Column(
            children: [
              // Banner con resumen
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  border: Border(bottom: BorderSide(color: context.appBorder)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: context.appSoftGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flash_on_rounded,
                              color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '¡Trabajos al Instante en Napo!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: context.appTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Revisa solicitudes personalizadas de clientes cercanos y envíales ofertas directas.',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appTextSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Selector de categorías deslizante
                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              },
                              selectedColor: context.appPrimary,
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : context.appTextPrimary,
                              ),
                              backgroundColor: context.appMutedSurface,
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: isSelected
                                        ? Colors.transparent
                                        : context.appBorder),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de tareas
              Expanded(
                child: filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          final myOffer = user != null
                              ? task.offers
                                  .where((o) => o.providerId == user.id)
                                  .toList()
                              : [];
                          final hasAlreadyApplied = myOffer.isNotEmpty;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: context.appBorder),
                              boxShadow: context.appCardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: context.appSoftGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                          _getCategoryIcon(task.category),
                                          color: AppColors.primary,
                                          size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: context.appTextPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Text(
                                                task.category,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      context.appTextSecondary,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                      color: context
                                                          .appTextSecondary,
                                                      shape: BoxShape.circle)),
                                              const SizedBox(width: 8),
                                              Text(
                                                _getFictionalDistance(task.id),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: context
                                                        .appTextSecondary),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                      color: context
                                                          .appTextSecondary,
                                                      shape: BoxShape.circle)),
                                              const SizedBox(width: 8),
                                              Text(
                                                _getTimeAgo(task.createdAt),
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: context
                                                        .appTextSecondary,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  task.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.4,
                                    color: context.appTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_rounded,
                                        size: 16,
                                        color: context.appTextSecondary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        task.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: context.appTextSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(height: 1),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Presupuesto del Cliente',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: context.appTextSecondary),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '\$${task.budget.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (hasAlreadyApplied)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: context.appSoftGreen,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.check_circle_rounded,
                                                color: AppColors.primary,
                                                size: 16),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Postulado (\$${myOffer.first.priceOffer.toStringAsFixed(0)})',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                                color: context.appTextPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _showBidBottomSheet(task),
                                        icon: const Icon(Icons.gavel_rounded,
                                            size: 16),
                                        label: const Text('Hacer Oferta'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          elevation: 0,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: context.appSurface,
                shape: BoxShape.circle,
                boxShadow: context.appCardShadow,
              ),
              child: Icon(Icons.work_off_rounded,
                  size: 54, color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay tareas disponibles en esta categoría.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: context.appTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
