import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:my_first_app/features/analytics/models/analytics_event_model.dart';
import 'package:my_first_app/features/analytics/models/user_usage_summary_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AnalyticsRepository {
  AnalyticsRepository(this._client);

  final SupabaseClient _client;
  final _uuid = const Uuid();
  String? _sessionId;

  String? get sessionId => _sessionId;

  Future<String?> startSession() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    _sessionId = _uuid.v4();
    final context = await _deviceContext();
    try {
      await _client.from('user_sessions').insert({
        'user_id': user.id,
        'session_id': _sessionId,
        'platform': context.platform,
        'app_version': context.appVersion,
        'device_id': context.deviceId,
        'started_at': DateTime.now().toIso8601String(),
        'last_seen_at': DateTime.now().toIso8601String(),
      });
      await trackEvent(
        eventName: 'user_logged_in',
        eventCategory: 'auth',
        entityType: 'user',
        entityId: user.id,
      );
    } catch (_) {}
    return _sessionId;
  }

  Future<void> updateSessionHeartbeat() async {
    final user = _client.auth.currentUser;
    if (user == null || _sessionId == null) return;
    try {
      await _client
          .from('user_sessions')
          .update({'last_seen_at': DateTime.now().toIso8601String()})
          .eq('user_id', user.id)
          .eq('session_id', _sessionId!);
    } catch (_) {}
  }

  Future<void> endSession() async {
    final user = _client.auth.currentUser;
    if (user == null || _sessionId == null) return;
    try {
      await _client
          .from('user_sessions')
          .update({
            'ended_at': DateTime.now().toIso8601String(),
            'last_seen_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id)
          .eq('session_id', _sessionId!);
    } catch (_) {
    } finally {
      _sessionId = null;
    }
  }

  Future<void> trackEvent({
    required String eventName,
    required String eventCategory,
    String entityType = 'none',
    String? entityId,
    Map<String, dynamic> metadata = const {},
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    try {
      final context = await _deviceContext();
      await _client.from('analytics_events').insert({
        'user_id': user.id,
        'event_name': eventName,
        'event_category': eventCategory,
        'entity_type': entityType,
        'entity_id': entityId,
        'metadata': metadata,
        'platform': context.platform,
        'app_version': context.appVersion,
        'device_id': context.deviceId,
        'session_id': _sessionId,
      });
    } catch (_) {
      // Analytics must never block core UI.
    }
  }

  Future<UserUsageSummaryModel> getMyUsageSummary() async {
    final user = _client.auth.currentUser;
    if (user == null) return UserUsageSummaryModel.empty('');
    final monthKey = DateTime.now().toIso8601String().substring(0, 7);
    try {
      final response = await _client
          .from('user_usage_summaries')
          .select()
          .eq('user_id', user.id)
          .eq('month_key', monthKey)
          .maybeSingle();
      if (response == null) return UserUsageSummaryModel.empty(user.id);
      return UserUsageSummaryModel.fromJson(response);
    } catch (_) {
      return UserUsageSummaryModel.empty(user.id);
    }
  }

  Future<List<AnalyticsEventModel>> getMyRecentActivity({
    int limit = 30,
  }) async {
    try {
      final response = await _client
          .from('analytics_events')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      return response
          .map<AnalyticsEventModel>(
            (item) => AnalyticsEventModel.fromJson(item),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<UserUsageSummaryModel>> getMyMonthlyStats({
    int limit = 12,
  }) async {
    try {
      final response = await _client
          .from('user_usage_summaries')
          .select()
          .order('month_key', ascending: false)
          .limit(limit);
      return response
          .map<UserUsageSummaryModel>(
            (item) => UserUsageSummaryModel.fromJson(item),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<_DeviceContext> _deviceContext() async {
    String platform = 'unknown';
    String? deviceId;
    if (Platform.isIOS) {
      platform = 'ios';
      deviceId = (await DeviceInfoPlugin().iosInfo).identifierForVendor;
    } else if (Platform.isAndroid) {
      platform = 'android';
      deviceId = (await DeviceInfoPlugin().androidInfo).id;
    } else if (Platform.isWindows) {
      platform = 'windows';
      deviceId = (await DeviceInfoPlugin().windowsInfo).deviceId;
    } else if (Platform.isMacOS) {
      platform = 'macos';
      deviceId = (await DeviceInfoPlugin().macOsInfo).systemGUID;
    } else if (Platform.isLinux) {
      platform = 'linux';
      deviceId = (await DeviceInfoPlugin().linuxInfo).machineId;
    }
    final package = await PackageInfo.fromPlatform();
    return _DeviceContext(
      platform: platform,
      appVersion: '${package.version}+${package.buildNumber}',
      deviceId: deviceId,
    );
  }
}

class _DeviceContext {
  const _DeviceContext({
    required this.platform,
    required this.appVersion,
    required this.deviceId,
  });
  final String platform;
  final String appVersion;
  final String? deviceId;
}
