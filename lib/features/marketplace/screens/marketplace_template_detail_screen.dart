import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/marketplace/providers/marketplace_providers.dart';
import 'package:my_first_app/features/marketplace/widgets/access_type_badge.dart';
import 'package:my_first_app/features/marketplace/widgets/difficulty_badge.dart';
import 'package:my_first_app/features/marketplace/widgets/premium_template_lock_card.dart';
import 'package:my_first_app/features/marketplace/widgets/rating_stars.dart';
import 'package:my_first_app/features/marketplace/widgets/template_feature_list.dart';
import 'package:my_first_app/routing/route_names.dart';

class MarketplaceTemplateDetailScreen extends ConsumerWidget {
  const MarketplaceTemplateDetailScreen({super.key, required this.templateId});
  final String templateId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = ref.watch(marketplaceTemplateDetailProvider(templateId));
    final reviews = ref.watch(marketplaceReviewsProvider(templateId));
    final fav = ref.watch(marketplaceFavoriteStatusProvider(templateId));
    final action = ref.watch(marketplaceActionControllerProvider);
    ref.listen(
      marketplaceActionControllerProvider,
      (_, next) => next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString()))),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Detail'),
        actions: [
          fav.when(
            data: (isFav) => IconButton(
              onPressed: () => isFav
                  ? ref
                        .read(marketplaceActionControllerProvider.notifier)
                        .removeFavorite(templateId)
                  : ref
                        .read(marketplaceActionControllerProvider.notifier)
                        .addFavorite(templateId),
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: template.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (t) {
          if (t == null) return const Center(child: Text('Template not found'));
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  t.isPremium ? Icons.workspace_premium : Icons.apps,
                  size: 72,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                t.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(t.fullDescription),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AccessTypeBadge(accessType: t.accessType),
                  DifficultyBadge(difficulty: t.difficulty),
                  Chip(label: Text(t.category.replaceAll('_', ' '))),
                  Chip(label: Text(t.templateType.replaceAll('_', ' '))),
                ],
              ),
              const SizedBox(height: 12),
              RatingStars(rating: t.ratingAverage, count: t.ratingCount),
              const SizedBox(height: 18),
              if (t.isPremium) const PremiumTemplateLockCard(),
              Text(
                'Features',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              TemplateFeatureList(features: t.features),
              const SizedBox(height: 16),
              Text(
                'Included Outputs',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              TemplateFeatureList(features: t.includedOutputs),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: action.isLoading
                    ? null
                    : () async {
                        final projectId = await ref
                            .read(marketplaceActionControllerProvider.notifier)
                            .useTemplate(templateId, null);
                        if (projectId != null && context.mounted)
                          context.pushNamed(
                            RouteNames.projectDetail,
                            pathParameters: {'id': projectId},
                          );
                      },
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Use Template'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.pushNamed(
                  RouteNames.marketplaceReview,
                  pathParameters: {'id': templateId},
                ),
                icon: const Icon(Icons.rate_review),
                label: const Text('Write Review'),
              ),
              const SizedBox(height: 20),
              Text(
                'Reviews',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              reviews.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('$e'),
                data: (items) => items.isEmpty
                    ? const Text('No reviews yet.')
                    : Column(
                        children: items
                            .map(
                              (r) => Card(
                                child: ListTile(
                                  title: RatingStars(
                                    rating: r.rating.toDouble(),
                                  ),
                                  subtitle: Text(r.reviewText ?? ''),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
