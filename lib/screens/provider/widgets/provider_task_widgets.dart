part of '../provider_dashboard.dart';

class _ProviderTaskCard extends StatelessWidget {
  final CustomTaskModel task;
  final bool hasOffer;
  final VoidCallback? onBid;

  const _ProviderTaskCard({
    required this.task,
    required this.hasOffer,
    required this.onBid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _providerPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.appSoftGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _taskCategoryIcon(task.category),
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.appTextPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      task.category,
                      style: TextStyle(
                          color: context.appTextSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                _money(task.budget),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            task.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.appTextSecondary, height: 1.35),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ProviderInfoChip(
                icon: Icons.location_on_outlined,
                text: task.address,
              ),
              _ProviderInfoChip(
                icon: Icons.access_time_rounded,
                text: _timeAgo(task.createdAt),
              ),
              _ProviderInfoChip(
                icon: Icons.groups_outlined,
                text: '${task.offers.length} ofertas',
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: hasOffer
                ? OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Propuesta enviada'),
                  )
                : ElevatedButton.icon(
                    onPressed: onBid,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Enviar propuesta'),
                  ),
          ),
        ],
      ),
    );
  }
}
