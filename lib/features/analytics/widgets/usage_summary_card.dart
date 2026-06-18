import 'package:flutter/material.dart';
import 'package:my_first_app/features/analytics/models/user_usage_summary_model.dart';
import 'package:my_first_app/features/subscription/providers/subscription_providers.dart';

class UsageSummaryCard extends StatelessWidget {
  const UsageSummaryCard({
    super.key,
    required this.summary,
    required this.subscription,
  });
  final UserUsageSummaryModel summary;
  final SubscriptionSummary subscription;

  @override
  Widget build(BuildContext context) {
    final limit = subscription.generationLimit;
    final used = subscription.generationCount;
    final progress = limit == null || limit == 0
        ? 0.0
        : (used / limit).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Usage',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text('Plan: ${subscription.planType.toUpperCase()}'),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: limit == null ? null : progress),
            const SizedBox(height: 8),
            Text(
              limit == null
                  ? '$used AI generations used • unlimited'
                  : '$used/$limit AI generations used • ${subscription.remaining} remaining',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('${summary.projectsCreated} projects')),
                Chip(label: Text('${summary.templateOutputs} outputs')),
                Chip(label: Text('${summary.pdfExports} exports')),
                Chip(
                  label: Text('${summary.notificationsReceived} notifications'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
