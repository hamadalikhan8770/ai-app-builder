class TeamActivityLogModel {
  const TeamActivityLogModel({
    required this.id,
    required this.teamId,
    this.actorUserId,
    required this.action,
    required this.entityType,
    this.entityId,
    required this.metadata,
    required this.createdAt,
  });
  final String id;
  final String teamId;
  final String? actorUserId;
  final String action;
  final String entityType;
  final String? entityId;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  factory TeamActivityLogModel.fromJson(Map<String, dynamic> json) =>
      TeamActivityLogModel(
        id: json['id']?.toString() ?? '',
        teamId: json['team_id']?.toString() ?? '',
        actorUserId: json['actor_user_id']?.toString(),
        action: json['action']?.toString() ?? '',
        entityType: json['entity_type']?.toString() ?? 'none',
        entityId: json['entity_id']?.toString(),
        metadata: _map(json['metadata']),
        createdAt: _date(json['created_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'team_id': teamId,
    'actor_user_id': actorUserId,
    'action': action,
    'entity_type': entityType,
    'entity_id': entityId,
    'metadata': metadata,
    'created_at': createdAt.toIso8601String(),
  };
  TeamActivityLogModel copyWith({
    String? id,
    String? teamId,
    String? actorUserId,
    String? action,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) => TeamActivityLogModel(
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    actorUserId: actorUserId ?? this.actorUserId,
    action: action ?? this.action,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    metadata: metadata ?? this.metadata,
    createdAt: createdAt ?? this.createdAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
Map<String, dynamic> _map(dynamic value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};
