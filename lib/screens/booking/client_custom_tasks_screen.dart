import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../core/utils/helpers.dart';
import '../../models/custom_task_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/custom_task_provider.dart';

class ClientCustomTasksScreen extends StatefulWidget {
  const ClientCustomTasksScreen({Key? key}) : super(key: key);

  @override
  State<ClientCustomTasksScreen> createState() =>
      _ClientCustomTasksScreenState();
}

class _ClientCustomTasksScreenState extends State<ClientCustomTasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) return;
        setState(() {
          _selectedIndex = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  void _acceptOffer(CustomTaskModel task, CustomTaskOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Aceptar Oferta',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: 15,
              height: 1.45,
            ),
            children: [
              const TextSpan(text: '¿Estás seguro de que deseas contratar a '),
              TextSpan(
                text: offer.providerName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const TextSpan(text: ' por un valor de '),
              TextSpan(
                text: '\$${offer.priceOffer.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const TextSpan(
                  text:
                      '? Al aceptar, el proveedor será notificado para realizar el servicio.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                  color: context.appTextSecondary, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final provider =
                  Provider.of<CustomTaskProvider>(context, listen: false);
              provider.acceptOffer(task.id, offer.id);

              Helpers.showCustomSnackBar(
                context,
                message: '¡Proveedor contratado! Tarea asignada correctamente.',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _completeTask(CustomTaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Finalizar Tarea',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text(
          '¿Confirmas que la tarea ha sido completada satisfactoriamente por el proveedor?',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(
                  color: context.appTextSecondary, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final provider =
                  Provider.of<CustomTaskProvider>(context, listen: false);
              provider.completeTask(task.id);

              Helpers.showCustomSnackBar(
                context,
                message: '¡Excelente! Tarea marcada como Completada.',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sí, finalizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Inicia sesión para ver tus tareas.',
            style: TextStyle(color: context.appTextPrimary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text('Mis Tareas Solicitadas'),
        elevation: 0,
        backgroundColor: context.appSurface,
        foregroundColor: context.appTextPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: context.appTextSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          tabs: const [
            Tab(text: 'Abiertas'),
            Tab(text: 'En Progreso'),
            Tab(text: 'Completadas'),
          ],
        ),
      ),
      body: Consumer<CustomTaskProvider>(
        builder: (context, taskProvider, child) {
          final allMyTasks = taskProvider.getTasksForClient(user.id).isEmpty
              // Si la lista de mis tareas reales está vacía, mostramos también las mock de 'client-mock-X'
              // para fines demostrativos en esta maqueta interactiva.
              ? taskProvider.tasks
              : taskProvider.getTasksForClient(user.id);

          List<CustomTaskModel> filteredTasks = [];
          if (_selectedIndex == 0) {
            filteredTasks = allMyTasks
                .where((t) => t.status == CustomTaskStatus.open)
                .toList();
          } else if (_selectedIndex == 1) {
            filteredTasks = allMyTasks
                .where((t) => t.status == CustomTaskStatus.accepted)
                .toList();
          } else {
            filteredTasks = allMyTasks
                .where((t) => t.status == CustomTaskStatus.completed)
                .toList();
          }

          if (filteredTasks.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return _buildTaskCard(task);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = '';
    IconData icon = Icons.assignment_outlined;
    if (_selectedIndex == 0) {
      message = 'No tienes tareas abiertas solicitando ofertas.';
      icon = Icons.assignment_late_outlined;
    } else if (_selectedIndex == 1) {
      message = 'No tienes tareas en progreso asignadas a proveedores.';
      icon = Icons.handyman_outlined;
    } else {
      message = 'No tienes tareas completadas todavía.';
      icon = Icons.assignment_turned_in_outlined;
    }

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
              child: Icon(icon,
                  size: 58, color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.appTextSecondary,
              ),
            ),
            if (_selectedIndex == 0) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.customTaskForm),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Solicitar una Tarea'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(CustomTaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.appBorder),
        boxShadow: context.appCardShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.appSoftGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(_getCategoryIcon(task.category),
                color: AppColors.primary, size: 24),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Text(
                  'Presupuesto: ',
                  style:
                      TextStyle(fontSize: 12, color: context.appTextSecondary),
                ),
                Text(
                  '\$${task.budget.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Icon(Icons.calendar_today_rounded,
                    size: 12, color: context.appTextSecondary),
                const SizedBox(width: 4),
                Text(
                  '${task.date.day}/${task.date.month}',
                  style:
                      TextStyle(fontSize: 12, color: context.appTextSecondary),
                ),
              ],
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 12),
            // Detalles de la Tarea
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descripción de lo solicitado:',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: TextStyle(
                        fontSize: 13,
                        color: context.appTextPrimary,
                        height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 16, color: context.appTextSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          task.address,
                          style: TextStyle(
                              fontSize: 12, color: context.appTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Lógica según el estado
            if (task.status == CustomTaskStatus.open) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ofertas recibidas de proveedores:',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 10),
              if (task.offers.isEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: context.appMutedSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.appBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: AppColors.accent, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Aún no hay ofertas de proveedores. Te notificaremos apenas recibas una propuesta.',
                          style: TextStyle(
                              fontSize: 13,
                              color: context.appTextSecondary,
                              height: 1.3),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: task.offers.map((offer) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.appMutedSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.appBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: context.appSoftGreen,
                                child: Text(
                                  offer.providerName[0],
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offer.providerName,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: context.appTextPrimary),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.amber.shade700,
                                            size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          offer.providerRating
                                              .toStringAsFixed(1),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: context.appTextSecondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: context.appSoftGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '\$${offer.priceOffer.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '"${offer.message}"',
                              style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: context.appTextPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                    context, AppRoutes.chat),
                                icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 16),
                                label: const Text('Chat'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(color: context.appBorder),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _acceptOffer(task, offer),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Aceptar Oferta',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ] else if (task.status == CustomTaskStatus.accepted) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.appSoftGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.handyman_rounded,
                        color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Proveedor Contratado:',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            task.providerName ?? 'Sin asignar',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: context.appTextPrimary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_rounded,
                          color: AppColors.primary),
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.chat),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _completeTask(task),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Marcar como Completada'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ] else if (task.status == CustomTaskStatus.completed) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.appSoftGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment_turned_in_rounded,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      '¡Trabajo Completado con éxito!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: context.appTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
