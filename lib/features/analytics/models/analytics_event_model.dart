class AnalyticsEventModel {
  const AnalyticsEventModel({
    required this.id,
    required this.userId,
    required this.eventName,
    required this.eventCategory,
    required this.entityType,
    required this.metadata,
    required this.platform,
    required this.createdAt,
    this.entityId,
    this.appVersion,
    this.deviceId,
    this.sessionId,
  });

  final String id;
  final String userId;
  final String eventName;
  final String eventCategory;
  final String entityType;
  final String? entityId;
  final Map<String, dynamic> metadata;
  final String? platform;
  final String? appVersion;
  final String? deviceId;
  final String? sessionId;
  final DateTime createdAt;

  factory AnalyticsEventModel.fromJson(Map<String, dynamic> json) =>
      AnalyticsEventModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        eventName: json['event_name']?.toString() ?? '',
        eventCategory: json['event_category']?.toString() ?? 'system',
        entityType: json['entity_type']?.toString() ?? 'none',
        entityId: json['entity_id']?.toString(),
        metadata: json['metadata'] is Map<String, dynamic>
            ? json['metadata'] as Map<String, dynamic>
            : <String, dynamic>{},
        platform: json['platform']?.toString(),
        appVersion: json['app_version']?.toString(),
        deviceId: json['device_id']?.toString(),
        sessionId: json['session_id']?.toString(),
        createdAt:
            DateTime.tryParse(json['created_at']?.toString() ?? '') ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'event_name': eventName,
    'event_category': eventCategory,
    'entity_type': entityType,
    'entity_id': entityId,
    'metadata': metadata,
    'platform': platform,
    'app_version': appVersion,
    'device_id': deviceId,
    'session_id': sessionId,
    'created_at': createdAt.toIso8601String(),
  };

  AnalyticsEventModel copyWith({
    String? id,
    String? userId,
    String? eventName,
    String? eventCategory,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? metadata,
    String? platform,
    String? appVersion,
    String? deviceId,
    String? sessionId,
    DateTime? createdAt,
  }) => AnalyticsEventModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    eventName: eventName ?? this.eventName,
    eventCategory: eventCategory ?? this.eventCategory,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    metadata: metadata ?? this.metadata,
    platform: platform ?? this.platform,
    appVersion: appVersion ?? this.appVersion,
    deviceId: deviceId ?? this.deviceId,
    sessionId: sessionId ?? this.sessionId,
    createdAt: createdAt ?? this.createdAt,
  );
}
