import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/core/widgets/empty_state.dart';
import 'package:my_first_app/core/widgets/error_view.dart';
import 'package:my_first_app/core/widgets/loading_view.dart';
import 'package:my_first_app/features/marketplace/providers/marketplace_providers.dart';
import 'package:my_first_app/features/marketplace/widgets/marketplace_category_chips.dart';
import 'package:my_first_app/features/marketplace/widgets/marketplace_template_card.dart';
import 'package:my_first_app/routing/route_names.dart';

class MarketplaceHomeScreen extends ConsumerWidget {
  const MarketplaceHomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(marketplaceTemplatesProvider);
    final featured = ref.watch(featuredMarketplaceTemplatesProvider);
    final filters = ref.watch(marketplaceFiltersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Marketplace'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.marketplaceFavorites),
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () => context.pushNamed(RouteNames.marketplaceSearch),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(marketplaceTemplatesProvider);
          ref.invalidate(featuredMarketplaceTemplatesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search templates',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (v) {
                ref.read(marketplaceSearchProvider.notifier).state = v;
                context.pushNamed(RouteNames.marketplaceSearch);
              },
            ),
            const SizedBox(height: 16),
            MarketplaceCategoryChips(
              selected: filters.category,
              onSelected: (category) =>
                  ref.read(marketplaceFiltersProvider.notifier).state = filters
                      .copyWith(category: category),
            ),
            const SizedBox(height: 20),
            Text(
              'Featured',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            featured.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (items) => items.isEmpty
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 245,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: items
                            .map(
                              (t) => SizedBox(
                                width: 320,
                                child: MarketplaceTemplateCard(
                                  template: t,
                                  onTap: () => context.pushNamed(
                                    RouteNames.marketplaceTemplateDetail,
                                    pathParameters: {'id': t.id},
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              'All Templates',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            templates.when(
              loading: () => const LoadingView(message: 'Loading templates...'),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(marketplaceTemplatesProvider),
              ),
              data: (items) => items.isEmpty
                  ? const EmptyState(
                      title: 'No templates found',
                      message: 'Try another search or filter.',
                      icon: Icons.storefront,
                    )
                  : Column(
                      children: items
                          .map(
                            (t) => MarketplaceTemplateCard(
                              template: t,
                              onTap: () => context.pushNamed(
                                RouteNames.marketplaceTemplateDetail,
                                pathParameters: {'id': t.id},
                              ),
                              onFavorite: () => ref
                                  .read(
                                    marketplaceActionControllerProvider
                                        .notifier,
                                  )
                                  .addFavorite(t.id),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
