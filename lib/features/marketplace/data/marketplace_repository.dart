import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:my_first_app/features/marketplace/models/marketplace_favorite_model.dart';
import 'package:my_first_app/features/marketplace/models/marketplace_review_model.dart';
import 'package:my_first_app/features/marketplace/models/marketplace_template_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarketplaceRepository {
  const MarketplaceRepository(this._client);
  final SupabaseClient _client;

  Future<List<MarketplaceTemplateModel>> getTemplates() => filterTemplates();

  Future<List<MarketplaceTemplateModel>> getFeaturedTemplates() async {
    final response = await _templatesBase().eq('is_featured', true).limit(10);
    return response
        .map<MarketplaceTemplateModel>(
          (item) => MarketplaceTemplateModel.fromJson(item),
        )
        .toList();
  }

  Future<List<MarketplaceTemplateModel>> getPopularTemplates() async {
    final response = await _templatesBase()
        .order('usage_count', ascending: false)
        .limit(10);
    return response
        .map<MarketplaceTemplateModel>(
          (item) => MarketplaceTemplateModel.fromJson(item),
        )
        .toList();
  }

  Future<MarketplaceTemplateModel?> getTemplateById(String templateId) async {
    final response = await _client
        .from('marketplace_templates')
        .select()
        .eq('id', templateId)
        .maybeSingle();
    if (response == null) return null;
    await trackTemplateView(templateId);
    return MarketplaceTemplateModel.fromJson(response);
  }

  Future<List<MarketplaceTemplateModel>> searchTemplates(String query) async {
    if (query.trim().isEmpty) return getTemplates();
    final response = await _templatesBase().or(
      'title.ilike.%$query%,short_description.ilike.%$query%,category.ilike.%$query%',
    );
    return response
        .map<MarketplaceTemplateModel>(
          (item) => MarketplaceTemplateModel.fromJson(item),
        )
        .toList();
  }

  Future<List<MarketplaceTemplateModel>> filterTemplates({
    String? category,
    String? platform,
    String? stack,
    String? accessType,
    String? difficulty,
  }) async {
    var query = _templatesBase();
    if (category != null && category != 'all')
      query = query.eq('category', category);
    if (platform != null && platform != 'all')
      query = query.ilike('target_platform', '%$platform%');
    if (stack != null && stack != 'all')
      query = query.ilike('recommended_stack', '%$stack%');
    if (accessType != null && accessType != 'all')
      query = query.eq('access_type', accessType);
    if (difficulty != null && difficulty != 'all')
      query = query.eq('difficulty', difficulty);
    final response = await query;
    return response
        .map<MarketplaceTemplateModel>(
          (item) => MarketplaceTemplateModel.fromJson(item),
        )
        .toList();
  }

  Future<List<MarketplaceFavoriteModel>> getMyFavorites() async {
    final response = await _client
        .from('marketplace_template_favorites')
        .select()
        .order('created_at', ascending: false);
    return response
        .map<MarketplaceFavoriteModel>(
          (item) => MarketplaceFavoriteModel.fromJson(item),
        )
        .toList();
  }

  Future<void> addFavorite(String templateId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AppException('You must be logged in.');
    await _client.from('marketplace_template_favorites').upsert({
      'user_id': userId,
      'template_id': templateId,
    }, onConflict: 'user_id,template_id');
    await _trackUsage(templateId, 'favorited');
  }

  Future<void> removeFavorite(String templateId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client
        .from('marketplace_template_favorites')
        .delete()
        .eq('user_id', userId)
        .eq('template_id', templateId);
    await _trackUsage(templateId, 'unfavorited');
  }

  Future<bool> isFavorite(String templateId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final response = await _client
        .from('marketplace_template_favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('template_id', templateId)
        .maybeSingle();
    return response != null;
  }

  Future<List<MarketplaceReviewModel>> getReviews(String templateId) async {
    final response = await _client
        .from('marketplace_template_reviews')
        .select()
        .eq('template_id', templateId)
        .eq('status', 'published')
        .order('created_at', ascending: false);
    return response
        .map<MarketplaceReviewModel>(
          (item) => MarketplaceReviewModel.fromJson(item),
        )
        .toList();
  }

  Future<void> submitReview(
    String templateId,
    int rating,
    String reviewText,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AppException('You must be logged in.');
    await _client.from('marketplace_template_reviews').insert({
      'user_id': userId,
      'template_id': templateId,
      'rating': rating,
      'review_text': reviewText,
      'status': 'pending',
    });
    await _trackUsage(templateId, 'reviewed');
  }

  Future<String> useTemplate(String templateId, String? projectTitle) async {
    final response = await _invokeMap('use-marketplace-template', {
      'templateId': templateId,
      'projectTitle': projectTitle,
    });
    final project = Map<String, dynamic>.from(response['project'] as Map);
    return project['id'].toString();
  }

  Future<void> trackTemplateView(String templateId) async =>
      _trackUsage(templateId, 'viewed');

  dynamic _templatesBase() {
    return _client
        .from('marketplace_templates')
        .select()
        .eq('status', 'published')
        .order('is_featured', ascending: false)
        .order('usage_count', ascending: false);
  }

  Future<void> _trackUsage(String templateId, String actionType) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await _client.from('marketplace_template_usage').insert({
        'user_id': userId,
        'template_id': templateId,
        'action_type': actionType,
      });
    } catch (_) {}
  }

  Future<Map<String, dynamic>> _invokeMap(
    String functionName,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client.functions.invoke(functionName, body: body);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['error'] != null) throw AppException(data['error'].toString());
        return data;
      }
      throw const AppException('Invalid server response.');
    } on FunctionException catch (error) {
      throw AppException(
        error.details?.toString() ??
            error.reasonPhrase ??
            'Server function failed.',
      );
    } on PostgrestException catch (error) {
      throw AppException(error.message);
    }
  }
}
