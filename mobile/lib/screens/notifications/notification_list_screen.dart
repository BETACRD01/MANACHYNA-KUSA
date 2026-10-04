import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_theme_colors.dart';
import '../../models/notification/notification_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user =
          Provider.of<AuthProvider>(context, listen: false).currentUser;
      Provider.of<NotificationProvider>(context, listen: false)
          .loadNotifications(user);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          final unreadCount = provider.unreadCount;

          return NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
              _buildSliverAppBar(ctx, provider, unreadCount),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildList(provider.notifications, provider),
                _buildList(provider.unread, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── SliverAppBar ─────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(
    BuildContext ctx,
    NotificationProvider provider,
    int unreadCount,
  ) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 0,
      backgroundColor: ctx.appBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: ctx.appTextPrimary, size: 20),
        onPressed: () => Navigator.pop(ctx),
      ),
      title: Text(
        'Notificaciones',
        style: TextStyle(
          color: ctx.appTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        if (unreadCount > 0)
          TextButton.icon(
            onPressed: () {
              provider.markAllAsRead().then((_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todas las notificaciones marcadas como leídas'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            },
            icon: const Icon(Icons.done_all_rounded,
                color: AppColors.primary, size: 18),
            label: const Text(
              'Leído todo',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ctx.appBorder, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: ctx.appTextSecondary,
            indicator: UnderlineTabIndicator(
              borderSide: const BorderSide(color: AppColors.primary, width: 2.5),
              borderRadius: BorderRadius.circular(8),
              insets: const EdgeInsets.symmetric(horizontal: 20),
            ),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: [
              const Tab(text: 'Todas'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No leídas'),
                    if (provider.unreadCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${provider.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Notification List ─────────────────────────────────────────────────────

  Widget _buildList(
    List<NotificationModel> items,
    NotificationProvider provider,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final n = items[index];
        return _buildNotificationCard(n, provider);
      },
    );
  }

  Widget _buildNotificationCard(
    NotificationModel n,
    NotificationProvider provider,
  ) {
    return Dismissible(
      key: ValueKey(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
            SizedBox(height: 4),
            Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        provider.deleteNotification(n.id).then((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notificación eliminada'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        });
      },
      child: GestureDetector(
        onTap: () {
          provider.markAsRead(n.id).then((_) {
            if (!mounted) return;
            if (n.type == NotificationType.booking && n.relatedId != null) {
              Navigator.pushNamed(context, AppRoutes.bookingDetail,
                  arguments: n.relatedId);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: n.isRead ? context.appSurface : context.appSoftGreen,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: n.isRead
                  ? context.appBorder
                  : AppColors.primary.withValues(alpha: 0.25),
              width: n.isRead ? 1 : 1.5,
            ),
            boxShadow: n.isRead ? const [] : context.appCardShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeIcon(n),
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
                            n.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: n.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: context.appTextPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (!n.isRead)
                          Container(
                            margin: const EdgeInsets.only(left: 8, top: 2),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      n.body,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appTextSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _timeAgo(n.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: context.appTextSecondary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(NotificationModel n) {
    IconData icon;
    Color color;

    switch (n.type) {
      case NotificationType.booking:
        icon = Icons.calendar_today_rounded;
        color = AppColors.primary;
        break;
      case NotificationType.chat:
        icon = Icons.chat_bubble_outline_rounded;
        color = AppColors.info;
        break;
      case NotificationType.system:
        icon = Icons.notifications_outlined;
        color = AppColors.warning;
        break;
    }

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: context.appSoftGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 42,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sin notificaciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Todo está al día. Cuando recibas\nalgo nuevo aparecerá aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: context.appTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Ahora mismo';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    return '${date.day}/${date.month}/${date.year}';
  }
}
