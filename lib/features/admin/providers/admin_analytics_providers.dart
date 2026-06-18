import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/features/admin/data/admin_analytics_repository.dart';
import 'package:my_first_app/features/analytics/models/admin_analytics_summary_model.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';

final adminAnalyticsRepositoryProvider = Provider<AdminAnalyticsRepository>((
  ref,
) {
  return AdminAnalyticsRepository(ref.watch(supabaseClientProvider));
});

final adminPlatformSummaryProvider = FutureProvider<AdminAnalyticsSummaryModel>(
  (ref) async {
    return ref.watch(adminAnalyticsRepositoryProvider).getPlatformSummary();
  },
);

final adminDailyReportsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return ref.watch(adminAnalyticsRepositoryProvider).getDailyReports();
});

final adminTemplateUsageProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return ref.watch(adminAnalyticsRepositoryProvider).getMostUsedTemplates();
});

final adminSubscriptionSummaryProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  return ref.watch(adminAnalyticsRepositoryProvider).getSubscriptionStats();
});

final adminFailureStatsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return ref.watch(adminAnalyticsRepositoryProvider).getFailureStats();
});
