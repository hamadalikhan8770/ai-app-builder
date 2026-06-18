import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_first_app/features/auth/providers/auth_providers.dart';
import 'package:my_first_app/features/marketplace/data/marketplace_repository.dart';
import 'package:my_first_app/features/marketplace/models/marketplace_favorite_model.dart';
import 'package:my_first_app/features/marketplace/models/marketplace_review_model.dart';
import 'package:my_first_app/features/marketplace/models/marketplace_template_model.dart';

class MarketplaceFilters {
  const MarketplaceFilters({
    this.category = 'all',
    this.platform = 'all',
    this.stack = 'all',
    this.accessType = 'all',
    this.difficulty = 'all',
  });
  final String category;
  final String platform;
  final String stack;
  final String accessType;
  final String difficulty;
  MarketplaceFilters copyWith({
    String? category,
    String? platform,
    String? stack,
    String? accessType,
    String? difficulty,
  }) => MarketplaceFilters(
    category: category ?? this.category,
    platform: platform ?? this.platform,
    stack: stack ?? this.stack,
    accessType: accessType ?? this.accessType,
    difficulty: difficulty ?? this.difficulty,
  );
}

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>(
  (ref) => MarketplaceRepository(ref.watch(supabaseClientProvider)),
);
final marketplaceSearchProvider = StateProvider<String>((ref) => '');
final marketplaceFiltersProvider = StateProvider<MarketplaceFilters>(
  (ref) => const MarketplaceFilters(),
);

final marketplaceTemplatesProvider =
    FutureProvider<List<MarketplaceTemplateModel>>((ref) async {
      final query = ref.watch(marketplaceSearchProvider);
      final filters = ref.watch(marketplaceFiltersProvider);
      final repo = ref.watch(marketplaceRepositoryProvider);
      if (query.trim().isNotEmpty) return repo.searchTemplates(query);
      return repo.filterTemplates(
        category: filters.category,
        platform: filters.platform,
        stack: filters.stack,
        accessType: filters.accessType,
        difficulty: filters.difficulty,
      );
    });

final featuredMarketplaceTemplatesProvider =
    FutureProvider<List<MarketplaceTemplateModel>>(
      (ref) => ref.watch(marketplaceRepositoryProvider).getFeaturedTemplates(),
    );
final popularMarketplaceTemplatesProvider =
    FutureProvider<List<MarketplaceTemplateModel>>(
      (ref) => ref.watch(marketplaceRepositoryProvider).getPopularTemplates(),
    );
final marketplaceTemplateDetailProvider =
    FutureProvider.family<MarketplaceTemplateModel?, String>(
      (ref, templateId) =>
          ref.watch(marketplaceRepositoryProvider).getTemplateById(templateId),
    );
final marketplaceFavoritesProvider =
    FutureProvider<List<MarketplaceFavoriteModel>>(
      (ref) => ref.watch(marketplaceRepositoryProvider).getMyFavorites(),
    );
final marketplaceReviewsProvider =
    FutureProvider.family<List<MarketplaceReviewModel>, String>(
      (ref, templateId) =>
          ref.watch(marketplaceRepositoryProvider).getReviews(templateId),
    );
final marketplaceFavoriteStatusProvider = FutureProvider.family<bool, String>(
  (ref, templateId) =>
      ref.watch(marketplaceRepositoryProvider).isFavorite(templateId),
);
final marketplaceActionControllerProvider =
    StateNotifierProvider<MarketplaceActionController, AsyncValue<void>>(
      (ref) => MarketplaceActionController(ref),
    );

class MarketplaceActionController extends StateNotifier<AsyncValue<void>> {
  MarketplaceActionController(this.ref) : super(const AsyncData(null));
  final Ref ref;
  MarketplaceRepository get _repo => ref.read(marketplaceRepositoryProvider);

  Future<void> addFavorite(String templateId) async => _run(() async {
    await _repo.addFavorite(templateId);
    ref.invalidate(marketplaceFavoritesProvider);
    ref.invalidate(marketplaceFavoriteStatusProvider(templateId));
  });
  Future<void> removeFavorite(String templateId) async => _run(() async {
    await _repo.removeFavorite(templateId);
    ref.invalidate(marketplaceFavoritesProvider);
    ref.invalidate(marketplaceFavoriteStatusProvider(templateId));
  });
  Future<void> submitReview(String templateId, int rating, String text) async =>
      _run(() async {
        await _repo.submitReview(templateId, rating, text);
        ref.invalidate(marketplaceReviewsProvider(templateId));
      });

  Future<String?> useTemplate(String templateId, String? projectTitle) async {
    state = const AsyncLoading();
    try {
      final projectId = await _repo.useTemplate(templateId, projectTitle);
      state = const AsyncData(null);
      return projectId;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}
