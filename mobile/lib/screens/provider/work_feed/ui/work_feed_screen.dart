import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../models/booking/booking_model.dart';
import '../../../../providers/booking_provider.dart';

import '../../shared/ui/provider_shared_widgets.dart';
import 'task_widgets.dart';
class ProviderWorkFeedTab extends StatelessWidget {
  final String categoryFilter;
  final ValueChanged<String> onCategoryChanged;

  const ProviderWorkFeedTab({super.key, 
    required this.categoryFilter,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, _) {
        final source = bookingProvider.bookings.isEmpty
            ? mockProviderBookings()
            : bookingProvider.bookings;
        final inProgress = source
            .where((booking) =>
                booking.status == BookingStatus.confirmed ||
                booking.status == BookingStatus.inProgress)
            .toList();
        final completed = source
            .where((booking) => booking.status == BookingStatus.completed)
            .toList();
        final newJobs = source
            .where((booking) => booking.status == BookingStatus.pending)
            .toList();
        final current = categoryFilter == 'Finalizados'
            ? completed
            : categoryFilter == 'Nuevos'
                ? newJobs
                : inProgress;

        return ProviderPage(
          title: 'Trabajos',
          subtitle: 'Solicitudes aceptadas y actividad en curso',
          slivers: [
            SliverToBoxAdapter(
              child: ProviderSegmentedTabs(
                values: {
                  'Nuevos': newJobs.length,
                  'En curso': inProgress.length,
                  'Finalizados': completed.length,
                },
                selected: ['Nuevos', 'En curso', 'Finalizados']
                        .contains(categoryFilter)
                    ? categoryFilter
                    : 'En curso',
                onChanged: onCategoryChanged,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(
                child: ProviderJobsSummary(
                  newJobs: newJobs.length,
                  activeJobs: inProgress.length,
                  completed: completed.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProviderJobCard(
                    booking: current[index],
                    onComplete: () => _complete(context, current[index]),
                  ),
                  childCount: current.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _complete(BuildContext context, BookingModel booking) async {
    final ok = await context
        .read<BookingProvider>()
        .updateBookingStatus(booking.id, BookingStatus.completed);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(ok ? 'Trabajo marcado como listo' : 'No se pudo actualizar'),
        backgroundColor: ok ? AppColors.success : AppColors.error,
      ),
    );
  }
}
