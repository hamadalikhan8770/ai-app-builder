import 'package:my_first_app/core/errors/app_exception.dart';
import 'package:my_first_app/features/analytics/models/admin_analytics_summary_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAnalyticsRepository {
  const AdminAnalyticsRepository(this._client);
  final SupabaseClient _client;

  Future<AdminAnalyticsSummaryModel> getPlatformSummary() async {
    try {
      final response = await _client.rpc('admin_platform_summary');
      if (response is List && response.isNotEmpty)
        return AdminAnalyticsSummaryModel.fromJson(
          Map<String, dynamic>.from(response.first),
        );
      if (response is Map<String, dynamic>)
        return AdminAnalyticsSummaryModel.fromJson(response);
      return AdminAnalyticsSummaryModel.empty();
    } on PostgrestException catch (error) {
      throw AppException(error.message);
    } catch (_) {
      throw const AppException('Could not load platform summary.');
    }
  }

  Future<List<Map<String, dynamic>>> getDailyReports() async =>
      _rpcList('admin_daily_usage');
  Future<List<Map<String, dynamic>>> getUserGrowth() async =>
      _rpcList('admin_daily_usage');
  Future<List<Map<String, dynamic>>> getGenerationStats() async =>
      _rpcList('admin_daily_usage');
  Future<List<Map<String, dynamic>>> getMostUsedTemplates() async =>
      _rpcList('admin_template_usage');
  Future<Map<String, dynamic>> getSubscriptionStats() async {
    final list = await _rpcList('admin_subscription_summary');
    return list.isEmpty ? <String, dynamic>{} : list.first;
  }

  Future<List<Map<String, dynamic>>> getExportStats() async =>
      _rpcList('admin_daily_usage');
  Future<List<Map<String, dynamic>>> getNotificationStats() async =>
      _rpcList('admin_daily_usage');
  Future<List<Map<String, dynamic>>> getFailureStats() async =>
      _rpcList('admin_failure_stats');

  Future<List<Map<String, dynamic>>> _rpcList(String name) async {
    try {
      final response = await _client.rpc(name);
      if (response is List)
        return response
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      return [];
    } on PostgrestException catch (error) {
      throw AppException(error.message);
    } catch (_) {
      throw AppException('Could not load $name.');
    }
  }
}
