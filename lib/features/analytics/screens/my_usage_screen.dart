import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/analytics/providers/analytics_providers.dart';
import 'package:my_first_app/features/analytics/widgets/activity_timeline.dart';
import 'package:my_first_app/features/analytics/widgets/analytics_stat_card.dart';
import 'package:my_first_app/features/analytics/widgets/usage_summary_card.dart';
import 'package:my_first_app/features/subscription/providers/subscription_providers.dart';
import 'package:my_first_app/routing/route_names.dart';

class MyUsageScreen extends ConsumerWidget {
  const MyUsageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(myUsageSummaryProvider);
    final activityAsync = ref.watch(myRecentActivityProvider);
    final subscriptionAsync = ref.watch(subscriptionSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Usage')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myUsageSummaryProvider);
          ref.invalidate(myRecentActivityProvider);
          ref.invalidate(subscriptionSummaryProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            subscriptionAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => ErrorView(message: error.toString()),
              data: (subscription) => summaryAsync.when(
                loading: () => const LoadingView(message: 'Loading usage...'),
                error: (error, _) => ErrorView(message: error.toString()),
                data: (summary) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UsageSummaryCard(
                      summary: summary,
                      subscription: subscription,
                    ),
                    if (!subscription.isPremium &&
                        (subscription.remaining ?? 0) <= 2) ...[
                      const SizedBox(height: 12),
                      Card(
                        color: Colors.amber.withValues(alpha: 0.12),
                        child: ListTile(
                          leading: const Icon(Icons.workspace_premium_outlined),
                          title: const Text(
                            'Running low on free generations',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          subtitle: const Text(
                            'Upgrade to Premium for more monthly AI generations and advanced exports.',
                          ),
                          trailing: FilledButton(
                            onPressed: () =>
                                context.pushNamed(RouteNames.upgrade),
                            child: const Text('Upgrade'),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.of(context).size.width > 700
                          ? 4
                          : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        AnalyticsStatCard(
                          title: 'Projects',
                          value: '${summary.projectsCreated}',
                          icon: Icons.folder_copy_outlined,
                        ),
                        AnalyticsStatCard(
                          title: 'AI Generations',
                          value: '${summary.aiGenerations}',
                          icon: Icons.auto_awesome,
                        ),
                        AnalyticsStatCard(
                          title: 'Outputs',
                          value: '${summary.templateOutputs}',
                          icon: Icons.article_outlined,
                        ),
                        AnalyticsStatCard(
                          title: 'PDF Exports',
                          value: '${summary.pdfExports}',
                          icon: Icons.picture_as_pdf_outlined,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            activityAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Could not load activity: $error'),
              data: (events) => ActivityTimeline(events: events),
            ),
          ],
        ),
      ),
    );
  }
}
