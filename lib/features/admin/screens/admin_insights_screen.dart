import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/admin/providers/admin_analytics_providers.dart';
import 'package:my_first_app/features/admin/widgets/admin_insight_card.dart';
import 'package:my_first_app/features/admin/widgets/daily_usage_chart.dart';
import 'package:my_first_app/features/admin/widgets/template_usage_table.dart';

class AdminInsightsScreen extends ConsumerWidget {
  const AdminInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(adminPlatformSummaryProvider);
    final dailyAsync = ref.watch(adminDailyReportsProvider);
    final templatesAsync = ref.watch(adminTemplateUsageProvider);
    final subscriptionAsync = ref.watch(adminSubscriptionSummaryProvider);
    final failuresAsync = ref.watch(adminFailureStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Insights & Analytics')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adminPlatformSummaryProvider);
          ref.invalidate(adminDailyReportsProvider);
          ref.invalidate(adminTemplateUsageProvider);
          ref.invalidate(adminSubscriptionSummaryProvider);
          ref.invalidate(adminFailureStatsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            summaryAsync.when(
              loading: () =>
                  const LoadingView(message: 'Loading platform summary...'),
              error: (error, _) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(adminPlatformSummaryProvider),
              ),
              data: (summary) => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  AdminInsightCard(
                    title: 'Total Users',
                    value: '${summary.totalUsers}',
                    icon: Icons.people_outline,
                  ),
                  AdminInsightCard(
                    title: 'Active Users',
                    value: '${summary.activeUsers}',
                    icon: Icons.bolt_outlined,
                  ),
                  AdminInsightCard(
                    title: 'Premium Users',
                    value: '${summary.premiumUsers}',
                    icon: Icons.workspace_premium_outlined,
                    color: Colors.amber.shade800,
                  ),
                  AdminInsightCard(
                    title: 'Projects',
                    value: '${summary.totalProjects}',
                    icon: Icons.folder_copy_outlined,
                  ),
                  AdminInsightCard(
                    title: 'AI Generations',
                    value: '${summary.aiGenerations}',
                    icon: Icons.auto_awesome,
                  ),
                  AdminInsightCard(
                    title: 'Failed AI',
                    value: '${summary.aiGenerationFailures}',
                    icon: Icons.error_outline,
                    color: Colors.redAccent,
                  ),
                  AdminInsightCard(
                    title: 'PDF Exports',
                    value: '${summary.pdfExports}',
                    icon: Icons.picture_as_pdf_outlined,
                  ),
                  AdminInsightCard(
                    title: 'Notifications',
                    value: '${summary.notificationsSent}',
                    icon: Icons.notifications_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.date_range_rounded),
                title: const Text('Date Range'),
                subtitle: const Text(
                  'Last 30 days selected. Custom range coming in report export phase.',
                ),
                trailing: OutlinedButton(
                  onPressed: null,
                  child: const Text('Coming soon'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            dailyAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Daily reports error: $error'),
              data: (rows) => DailyUsageChart(rows: rows),
            ),
            const SizedBox(height: 20),
            Text(
              'Template Usage',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            templatesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Template usage error: $error'),
              data: (rows) => TemplateUsageTable(rows: rows),
            ),
            const SizedBox(height: 20),
            Text(
              'Subscription Insights',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            subscriptionAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Subscription error: $error'),
              data: (row) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    row.isEmpty ? 'No subscription data yet.' : row.toString(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Failure Trends',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            failuresAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Failure stats error: $error'),
              data: (rows) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    rows.isEmpty ? 'No failures tracked yet.' : rows.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
