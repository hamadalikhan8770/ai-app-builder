class MarketplaceUsageModel {
  const MarketplaceUsageModel({
    required this.id,
    required this.userId,
    required this.templateId,
    this.projectId,
    required this.actionType,
    required this.createdAt,
  });
  final String id;
  final String userId;
  final String templateId;
  final String? projectId;
  final String actionType;
  final DateTime createdAt;
  factory MarketplaceUsageModel.fromJson(Map<String, dynamic> json) =>
      MarketplaceUsageModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        templateId: json['template_id']?.toString() ?? '',
        projectId: json['project_id']?.toString(),
        actionType: json['action_type']?.toString() ?? 'viewed',
        createdAt: _date(json['created_at']),
      );
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'template_id': templateId,
    'project_id': projectId,
    'action_type': actionType,
    'created_at': createdAt.toIso8601String(),
  };
  MarketplaceUsageModel copyWith({
    String? id,
    String? userId,
    String? templateId,
    String? projectId,
    String? actionType,
    DateTime? createdAt,
  }) => MarketplaceUsageModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    templateId: templateId ?? this.templateId,
    projectId: projectId ?? this.projectId,
    actionType: actionType ?? this.actionType,
    createdAt: createdAt ?? this.createdAt,
  );
}

DateTime _date(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
