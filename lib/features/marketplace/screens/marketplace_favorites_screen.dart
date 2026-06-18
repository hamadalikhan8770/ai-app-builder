import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/core/widgets/empty_state.dart';
import 'package:my_first_app/features/marketplace/providers/marketplace_providers.dart';

class MarketplaceFavoritesScreen extends ConsumerWidget {
  const MarketplaceFavoritesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(marketplaceFavoritesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Templates')),
      body: favorites.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(marketplaceFavoritesProvider),
          child: items.isEmpty
              ? const EmptyState(
                  title: 'No favorites yet',
                  message: 'Save templates to quickly find them later.',
                  icon: Icons.favorite_border,
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: items
                      .map(
                        (f) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.favorite),
                            title: Text('Template ${f.templateId}'),
                            subtitle: Text('Saved ${f.createdAt.toLocal()}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => ref
                                  .read(
                                    marketplaceActionControllerProvider
                                        .notifier,
                                  )
                                  .removeFavorite(f.templateId),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}
