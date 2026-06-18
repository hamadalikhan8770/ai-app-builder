import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/features/analytics/data/analytics_repository.dart';
import 'package:my_first_app/features/analytics/models/analytics_event_model.dart';
import 'package:my_first_app/features/analytics/models/user_usage_summary_model.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(supabaseClientProvider));
});

final myUsageSummaryProvider = FutureProvider<UserUsageSummaryModel>((
  ref,
) async {
  return ref.watch(analyticsRepositoryProvider).getMyUsageSummary();
});

final myRecentActivityProvider = FutureProvider<List<AnalyticsEventModel>>((
  ref,
) async {
  return ref.watch(analyticsRepositoryProvider).getMyRecentActivity();
});

final myMonthlyStatsProvider = FutureProvider<List<UserUsageSummaryModel>>((
  ref,
) async {
  return ref.watch(analyticsRepositoryProvider).getMyMonthlyStats();
});

final analyticsSessionProvider = Provider<void>((ref) {
  Timer? timer;
  ref.listen(authStateProvider, (previous, next) {
    final session = next.valueOrNull?.session;
    final repo = ref.read(analyticsRepositoryProvider);
    if (session != null) {
      repo.startSession();
      timer?.cancel();
      timer = Timer.periodic(
        const Duration(minutes: 2),
        (_) => repo.updateSessionHeartbeat(),
      );
    } else {
      timer?.cancel();
      repo.endSession();
    }
  });
  ref.onDispose(() => timer?.cancel());
});
