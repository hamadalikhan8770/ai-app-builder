import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_first_app/core/widgets/empty_state.dart';
import 'package:my_first_app/features/marketplace/providers/marketplace_providers.dart';
import 'package:my_first_app/features/marketplace/widgets/marketplace_category_chips.dart';
import 'package:my_first_app/features/marketplace/widgets/marketplace_template_card.dart';
import 'package:my_first_app/routing/route_names.dart';

class MarketplaceSearchScreen extends ConsumerWidget {
  const MarketplaceSearchScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(marketplaceTemplatesProvider);
    final filters = ref.watch(marketplaceFiltersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Search Templates')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search by name, category, feature...',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) =>
                ref.read(marketplaceSearchProvider.notifier).state = v,
          ),
          const SizedBox(height: 12),
          MarketplaceCategoryChips(
            selected: filters.category,
            onSelected: (category) =>
                ref.read(marketplaceFiltersProvider.notifier).state = filters
                    .copyWith(category: category),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['all', 'free', 'premium']
                .map(
                  (a) => FilterChip(
                    selected: filters.accessType == a,
                    label: Text(a),
                    onSelected: (_) =>
                        ref.read(marketplaceFiltersProvider.notifier).state =
                            filters.copyWith(accessType: a),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['all', 'beginner', 'intermediate', 'advanced']
                .map(
                  (d) => FilterChip(
                    selected: filters.difficulty == d,
                    label: Text(d),
                    onSelected: (_) =>
                        ref.read(marketplaceFiltersProvider.notifier).state =
                            filters.copyWith(difficulty: d),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          templates.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
            data: (items) => items.isEmpty
                ? const EmptyState(
                    title: 'No results',
                    message: 'Try changing your query or filters.',
                    icon: Icons.search_off,
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
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
