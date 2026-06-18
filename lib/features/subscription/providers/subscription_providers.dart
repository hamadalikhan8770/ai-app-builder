import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';

class SubscriptionSummary {
  const SubscriptionSummary({
    required this.planType,
    required this.generationCount,
    required this.generationLimit,
  });
  final String planType;
  final int generationCount;
  final int? generationLimit;
  bool get isAdmin => planType == 'admin';
  bool get isPremium => planType == 'premium' || isAdmin;
  int? get remaining => generationLimit == null
      ? null
      : (generationLimit! - generationCount).clamp(0, generationLimit!);
}

final subscriptionSummaryProvider = FutureProvider<SubscriptionSummary>((
  ref,
) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null)
    return const SubscriptionSummary(
      planType: 'free',
      generationCount: 0,
      generationLimit: 5,
    );
  final profile = await client
      .from('profiles')
      .select('role, subscription_tier')
      .eq('id', user.id)
      .maybeSingle();
  final role = profile?['role']?.toString() ?? 'free_user';
  final tier = profile?['subscription_tier']?.toString() ?? 'free';
  final plan = role == 'admin'
      ? 'admin'
      : (role == 'premium_user' || tier == 'premium' ? 'premium' : 'free');
  final monthKey = DateTime.now().toIso8601String().substring(0, 7);
  final usage = await client
      .from('usage_limits')
      .select('generation_count, generation_limit')
      .eq('user_id', user.id)
      .eq('month_key', monthKey)
      .maybeSingle();
  return SubscriptionSummary(
    planType: plan,
    generationCount: (usage?['generation_count'] as num?)?.toInt() ?? 0,
    generationLimit: usage?['generation_limit'] == null
        ? (plan == 'admin'
              ? null
              : plan == 'premium'
              ? 250
              : 5)
        : (usage!['generation_limit'] as num).toInt(),
  );
});
